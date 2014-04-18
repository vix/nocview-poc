package Catalyst::Helper::Controller::ManocCRUD;

use Class::Load;
use namespace::autoclean;

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin:../lib";

use File::Spec::Functions qw(catdir catfile canonpath);

=head1 NAME

Catalyst::Helper::Controller::Manoc::CRUD

=head1 SYNOPSIS

    $ script/manoc_create.pl controller Manoc::CRUD ResultClass


=head1 DESCRIPTION

  This creates (1) a REST controller according to the specifications at
  L<Catalyst::Controller::DBIC::API> and L<Catalyst::Controller::DBIC::API::REST>
  for the specified DB Class (2) templates for angular CRUD interface.

=head2 CONFIGURATION

    The idea is to make configuration as painless and as automatic as possible, so most
    of the work has been done for you.

    There are 8 __PACKAGE__->config(...) options for L<Catalyst::Controller::DBIC::API/CONFIGURATION>.
    Here are the defaults.

=head2 create_requires

    All non-nullable columns that are (1) not autoincrementing,
    (2) don't have a default value, are neither (3) nextvals,
    (4) sequences, nor (5) timestamps.

=head2 create_allows

    All nullable columns that are (1) not autoincrementing,
    (2) don't have a default value, are neither (3) nextvals,
    (4) sequences, nor (5) timestamps.

=head2 update_allows

    The union of create_requires and create_allows.

=head2 list_returns

    Every column in the class.

=head2 list_prefetch

    Nothing is prefetched by default.

=head2 list_prefetch_allows

    (1) An arrayref consisting of the name of each of the class's
    has_many relationships, accompanied by (2) a hashref keyed on
    the name of that relationship, whose values are the names of
    its has_many's, e.g., in the "Producer" controller above, a
    Producer has many cd_to_producers, many tags, and many tracks.
    None of those classes have any has_many's:

    list_prefetch_allows    =>  [
        [qw/cd_to_producer/], { 'cd_to_producer'  => [qw//] },
        [qw/tags/],           { 'tags'            => [qw//] },
        [qw/tracks/],         { 'tracks'          => [qw//] },
    ],

=head2 list_ordered_by

    The primary key.

=head2 list_search_exposes

    (1) An arrayref consisting of the name of each column in the class,
    and (2) a hashref keyed on the name of each of the class's has many
    relationships, the values of which are all the columns in the
    corresponding class, e.g.,

    list_search_exposes => [
        qw/cdid artist title year/,
        { 'cd_to_producer' => [qw/cd producer/] },
        { 'tags'           => [qw/tagid cd tag/] },
        { 'tracks'         => [qw/trackid cd position title last_updated_on/] },
    ],    # columns that can be searched on via list

=head1 METHODS

=head2 mk_compclass

    Where all the stuff is done.

=over

=back

=head1 AUTHOR

Gabriele Mambrini <g.mambrini@gmail.com>

=head1 SEE ALSO

L<Catalyst::Controller::DBIC::API>
L<Catalyst::Controller::DBIC::API::REST>
L<Catalyst::Controller::DBIC::API::RPC>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

sub mk_compclass {
  my $self = shift;
  my $helper = shift;
  my @args = @_;
  
  my $schema_class = "Manoc::DB";
  my $model_class = "Manoc::Model::DB";
  # don't use $helper->{class}; as we are create API controller
  
  my $model_name = $helper->{name};
  my $controller_class = "$helper->{app}::Controller::API::$model_name";

  my $manoc_base_path = canonpath(catdir( $FindBin::Bin, ".."));
  my $manoc_lib_path  = catdir("lib", split( /::/, $helper->{app} ) );

  Class::Load::load_class($schema_class);
  my $schema = $schema_class->connect;
  my $source = $schema->source( $model_name );

  print "controller_class = $controller_class\n";
  print "app path $manoc_base_path\n";
  
  # user for REST controller .pm file
  my $controller_params = {
			   class => $controller_class, # full class name
			   create_requires => [],
			   create_allows => [],
			   update_allows => [],
			   list_prefetch => [],
			   list_search_exposes  => [],
			   list_returns => [],
			  };

  # used for angularjs interface files (js + html fragments)
  my $ng_params = {
		   object_name => lc($model_name),
		   class_name => $model_name,
		   fields => [],
		  };
  

  foreach my $col ($source->columns() ) {
    print "Scanning column $col\n";
    my $info = $source->column_info($col);
    my $default = $info->{default_value};
    my $nullable = $info->{is_nullable};
    my $autoinc = $info->{is_auto_increment};

    my $allowed = !$autoinc && !($default && $default =~ /(nextval|sequence|timestamp)/);
    my $required = (!$default || !$nullable) && !$autoinc;

    $allowed and push @{$controller_params->{create_allows}}, $col;
    $required and push @{$controller_params->{create_requires}}, $col;
    !$autoinc and push @{$controller_params->{update_allows}}, $col;
    
    push @{$controller_params->{list_returns}}, $col;

    my $field = { 
		 name => $col,
		 type => $info->{data_type},
		 display_name => $col,
		};
    push @{$ng_params->{fields}}, $field;
  }
  $controller_params->{list_ordered_by} = [ $source->primary_columns() ];
  
  # relationship stuff
  
  foreach my $name ($source->relationships() ) {
    print "Scanning relationship $name\n";
    my $info = $source->relationship_info($name);
    print "  foreign\n" if $info->{attrs}->{is_foreign_key_constraint};
    print "  multi\n" if $info->{attrs}->{accessor} eq 'multi';
    #use Data::Dumper;
    #print Dumper($info)
  }

  my $controller_file = catfile( $manoc_lib_path, "Controller", "API",
					     $model_name . ".pm" );
  print "render file $controller_file\n";
  $helper->render_file('compclass', $controller_file, $controller_params); 

  my $fragments_dir = catdir( $manoc_base_path, "root", "generated-sources",
						"fragments", lc($model_name));

  $helper->mk_dir($fragments_dir);
  $helper->render_file('detail_html', catfile($fragments_dir, "detail.html"), $ng_params);
  $helper->render_file('list_html', catfile($fragments_dir, "list.html"), $ng_params);
  $helper->render_file('edit_html', catfile($fragments_dir, "edit.html"), $ng_params);
  
  $helper->render_file('controllers_js', catfile($fragments_dir, "controllers.js"), $ng_params);
  $helper->render_file('route_js', catfile($fragments_dir, "route.js"), $ng_params);
  $helper->render_file('services_js', catfile($fragments_dir, "services.js"), $ng_params);

  # $helper->{test} = $helper->next_test($source);
  # $helper->_mk_comptest;
}

1;

__DATA__

=begin pod_to_ignore
__compclass__
package [% class %];

use strict;
use warnings;
use JSON::XS;

use parent qw/[% app %]::ControllerBase::REST/;

__PACKAGE__->config(
    # Define parent chain action and partpath
    action                  =>  { setup => { PathPart => '[% class_name  %]', Chained => '/api/rest/rest_base' } },
    [% IF result_class %]
    # DBIC result class
    class                   =>  '[% result_class %]',
    [% END %]
    # Columns required to create
    create_requires         =>  [qw/[% create_requires.join(" ") %]/],
    # Additional non-required columns that create allows
    create_allows           =>  [qw/[% create_allows.join(" ") %]/],
    # Columns that update allows
    update_allows           =>  [qw/[% update_allows.join(" ") %]/],
    # Columns that list returns
    list_returns            =>  [qw/[% list_returns.join(" ") %]/],
[% IF list_prefetch %]
    # relationships prefetched by default
    list_prefetch           =>  [[% list_prefetch.join(" ") %]],
[% END %]
[% IF list_prefetch_allows %]
    # Every possible prefetch param allowed
    list_prefetch_allows    =>  [
        [% list_prefetch_allows.join(",") %]
    ],
[% END %]
    # Order of generated list
    list_ordered_by         => [qw/[% list_ordered_by.join(" ") %]/],
    # columns that can be searched on via list
    list_search_exposes     => [
        qw/[% list_search_exposes.join(" ") %]/,
        [% sub_list_search_exposes.join(",") %]
    ],);

=head1 NAME

[% CLASS %] - REST Controller for [% schema_class %]

=head1 DESCRIPTION

REST Methods to access the DBIC Result Class [% class_name %]

=head1 AUTHOR

[% author %]

=head1 SEE ALSO

L<Catalyst::Controller::DBIC::API>
L<Catalyst::Controller::DBIC::API::REST>
L<Catalyst::Controller::DBIC::API::RPC>

=head1 LICENSE

[% license %]

=cut
__detail_html__
<div>
  <ul class="details">
  [% FOR field IN fields -%]
    <dl>
      <dt>[% field.name %]</dt>
      <dd>{{ [% object_name %].[% field.name %]}}</dd>
    </dl>
  [% END -%]
</div>
__edit_html__
<div class="container">
  <h1>Edit [% name %]</h1>
  <form novalidate="novalidate" class="form-horizontal">
[% FOR field IN fields -%]
    <div class="control-group">
      <label class="control-label" for="input[% field.name.ucfirst %]">[% field.display_name %]:</label>
      <div class="controls">
[%   SWITCH field.type -%]
[%     CASE 'text' -%]
        <textarea id="input[% field.name.ucfirst %]" ng-model="[% name %].[% field.name %]"/></textarea>
[%     CASE -%]
        <input type="text" id="input[% field.name.ucfirst %]" ng-model="[% name %].[% field.name %]"/>
[%   END -%]
      </div>
    </div>
[% END -%]
    <div class="control-group">
      <div class="controls">
	<a ng-click="cancel()" class="btn btn-small">cancel</a>
	<a ng-click="save()" class="btn btn-small btn-primary">Save</a>
      </div>
    </div>
    </form>
</div><!-- container -->
__list_html__
<h2>[% name %]</h2>
<div class="container-fluid">
  <div class="row-fluid">
    <div class="span2">
      <!--Sidebar content-->
      <button class="btn btn-success" ng-click="create()">Create New</button>
      Search: <input ng-model="query">
      Sort by:
      <select ng-model="orderProp">
	<option value="name">Name</option>
	<option value="description">Description</option>
      </select>
    </div>
    <div class="span10">
     <!-- Table content-->
     <table class="table table-striped">
       <thead>
	 <tr>
	   <th>Name</th>
	   <th>Description</th>
	   <th></th>
	 </tr>
       </thead>
       <tbody>
	 <tr ng-repeat="[% object_name %] in [% list_name %]s | filter: query | orderBy: orderProp">
	   <td><a href="#/[% object_name %]/{{[% object_name %].id}}">{{[% object_name %].[% name_field %]}}</a></td>
	   <td>{{[% object_name %].[% description_field %]}}</td>
	   <td>
	     <a ng-click="edit([% object_name %].id)" class="btn btn-small btn-primary">edit</a>
             <a ng-click="delete([% object_name %].id)" class="btn btn-small btn-danger">delete</a>
	   </td>
	 </tr>
       </tbody>
     </table>
   </div><!-- row -->
   </div><!-- container -->   
__controllers_js__
manocControllers.controller('[% name %]ListCtrl', ['$scope', '[% name %]', '$location', function($scope, [% name %], $location) {
    $scope.[% name.lower %]s = [% name %].query();
    $scope.orderProp = 'name';

    $scope.edit = function ([% name.lcfirst %]Id) {
        $location.path('/[% name.lower %]/' + [% name.lower %]Id + '/edit');
    };
    $scope.delete = function ([% name.lower %]Id) {
        [% name %].delete({ id: [% name.lower %]Id });
	$scope.[% name.lower %]s = [% name %].query();

    };    
    $scope.create = function () {
        $location.path('/[% name.lower %]/new/');
    };
}]);

manocControllers.controller('[% name %]DetailCtrl', ['$scope', '$routeParams', '[% name %]',
function($scope, $routeParams, [% name %]) {
    $scope.[% name.lower %] = [% name %].get({'[% name.lower %]Id' : $routeParams.[% name.lower %]Id});
}]);

manocControllers.controller('[% name %]EditCtrl', ['$scope', '$routeParams', '[% name %]', '$location',
    function ($scope, $routeParams, [% name %], $location) {

        // callback for ng-click 'save':
        $scope.save = function () {
	    $scope.[% name.lower %].$save();
	    $location.path('/[% name.lower %]/');
        };

        // callback for ng-click 'cancel':
        $scope.cancel = function () {
	    $location.path('/[% name.lower %]/');
        };

	if ($routeParams.[% name.lower %]Id ) {
	    $scope.[% name.lower %] = [% name %].get({'[% name.lower %]Id' : $routeParams.[% name.lower %]Id});
	} else {
	    $scope.[% name.lower %] = new [% name %]();
	}

    }]);

__route_js__
'use strict';
  $routeProvider
	.when('/[% name.lower %]', {
	    templateUrl: 'static/partials/[% name.lower %]/list.html', 
	    controller: '[% name %]ListCtrl'
	})
	.when('/[% name.lower %]/new', {
	    templateUrl: 'static/partials/[% name.lower %]/edit.html', 
	    controller: '[% name %]EditCtrl'
	})
	.when('/[% name.lower %]/:[% name.lower %]Id', {
	    templateUrl: 'static/partials/[% name.lower %]/detail.html', 
	    controller: '[% name %]DetailCtrl'
	})
    	.when('/[% name.lower %]/:[% name.lower %]Id/edit', {
	    templateUrl: 'static/partials/[% name.lower %]/edit.html', 
	    controller: '[% name %]EditCtrl'
	})
*/
__services_js__
'use strict';
// [% name %] Resource
module.factory("[% name %]", [ 'ManocResource', function ($resource) {
    return $resource("/api/[% name.lower %]/:[% name.lower %]Id",  {
	'[% name.lower %]Id': '@id'
    });
}]);

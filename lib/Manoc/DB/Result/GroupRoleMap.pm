# Copyright 2014 by the Manoc Team
#
# This library is free software. You can redistribute it and/or modify
# it under the same terms as Perl itself.
package Manoc::DB::Result::GroupRoleMap;

use base qw(DBIx::Class);

__PACKAGE__->load_components(qw/PK::Auto Core/);

__PACKAGE__->table('group_role_map');
__PACKAGE__->add_columns(
			 group_id => {
				      data_type => 'int',
				      is_foreign_key => 1,
				      is_nullable => 0, 
				     }, 
			 role_id => { 
				     data_type => 'int', 
				     is_foreign_key => 1, 
				     is_nullable => 0, 
				    } 
			);

__PACKAGE__->set_primary_key(qw/group_id role_id/);

__PACKAGE__->belongs_to( group => 'Manoc::DB::Result::Group', 'group_id' );
__PACKAGE__->belongs_to( role => 'Manoc::DB::Result::Role', 'role_id' );

=head1 NAME

Manoc::DB::Result::GroupRoleMap - A model object representing the JOIN between Users and
Roles.

=head1 DESCRIPTION

This is an object that represents a row in the 'user_roles' table of your
application database.  It uses DBIx::Class (aka, DBIC) to do ORM.

=cut

1;

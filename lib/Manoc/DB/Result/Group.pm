# Copyright 2014 by the Manoc Team
#
# This library is free software. You can redistribute it and/or modify
# it under the same terms as Perl itself.
package Manoc::DB::Result::Group;

use base qw(DBIx::Class);

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('groups');

__PACKAGE__->add_columns(
    id => {
        data_type         => 'int',
        is_nullable       => 0,
        is_auto_increment => 1,
    },
    name => {
        data_type   => 'varchar',
        size        => 255,
        is_nullable => 0
    },
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint( ['name'] );

__PACKAGE__->has_many( map_user_group => 'Manoc::DB::Result::UserGroupMap', 'group_id' );
__PACKAGE__->many_to_many( users => 'map_user_group', 'user' );

__PACKAGE__->has_many( map_role_group => 'Manoc::DB::Result::GroupRoleMap', 'group_id' );
__PACKAGE__->many_to_many( roles => 'map_role_group', 'group' );


=head1 NAME

Manoc::DB::Result::Group - A model object representing a group of users.

=head1 DESCRIPTION

This is an object that represents a row in the 'usergroup' table of your
application database.  It uses DBIx::Class (aka, DBIC) to do ORM.

=cut

1;

# Copyright 2011 by the Manoc Team
#
# This library is free software. You can redistribute it and/or modify
# it under the same terms as Perl itself.
package Manoc::DB;

our $VERSION = '20140404';

use base qw/DBIx::Class::Schema/;

no warnings qw/qw/;

__PACKAGE__->load_namespaces;

sub get_version {
    return $__PACKAGE__::version;
}

1;


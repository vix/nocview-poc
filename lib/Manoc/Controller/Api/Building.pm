package Manoc::Controller::Api::Building;
use Moose;

BEGIN { extends 'Manoc::ControllerBase::ApiREST' }

use namespace::autoclean;
__PACKAGE__->config
    ( # define parent chain action and PathPart
      action => {
          setup => {
              Chained  => '/api/api_base',
              PathPart => 'building',
          }
      },
      class            => 'DB::Building',
      data_root        => 'data',
      create_requires  => ['name', 'description'],
      create_allows    => ['notes'],
      update_allows    => ['name', 'description', 'notes' ],
      use_json_boolean => 1,
      return_object    => 1,
      );

=head1 NAME

Manoc::Controller::Building::Api - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=encoding utf8

=head1 AUTHOR

Gabriele

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;

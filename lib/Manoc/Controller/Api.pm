package Manoc::Controller::Api;
use Moose;
use namespace::autoclean;


BEGIN { extends 'Catalyst::Controller'; }


sub api_base : Chained('/') PathPart('api') CaptureArgs(0) {
    my ( $self, $c ) = @_;
}

=head1 NAME

Manoc::Controller::Api - Catalyst Controller

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

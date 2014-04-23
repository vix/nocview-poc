package Manoc::Controller::JS;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Manoc::Controller::JS - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 base

=cut

sub js_base : Chained('/') PathPart('js') CaptureArgs(0) {
  my ( $self, $c ) = @_;
  $c->stash( crud_modules => [ qw(building) ] );
}

=head2 manoc_js

=cut

sub manoc_js : Chained('js_base') PathPart('manoc.js') Args(0) {
  my ( $self, $c ) = @_;
  $c->stash(modules => [
			'ngRoute',
			'manocControllers',
			'manocServices',
		       ]);
  $c->stash(routes => $c->stash->{crud_modules});
  $c->stash(template => 'manoc.tt.js');
}

sub services_js : Chained('js_base') PathPart('services.js') Args(0) {
  my ( $self, $c ) = @_;

  $c->stash(services => $c->stash->{crud_modules});
  $c->stash(template => 'services.tt.js');
}

sub controllers_js : Chained('js_base') PathPart('controllers.js') Args(0) {
  my ( $self, $c ) = @_;

  $c->stash(controllers => $c->stash->{crud_modules});
  $c->stash(template => 'controllers.tt.js');
}

sub end : Private {
  my ( $self, $c ) = @_;

  $c->forward( 'JavascriptTT' );
  $c->forward( 'Javascript' );
}

=encoding utf8

=head1 AUTHOR

Gabriele

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;

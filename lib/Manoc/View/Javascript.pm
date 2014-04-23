package Manoc::View::Javascript;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::JavaScript';

__PACKAGE__->config(
		    output => 1
);

=head1 NAME

Manoc::View::Javascript - Catalyst View

=head1 DESCRIPTION

Catalyst View.

=encoding utf8

=head1 AUTHOR

Gabriele

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

#__PACKAGE__->meta->make_immutable; #(inline_constructor => 0);

1;

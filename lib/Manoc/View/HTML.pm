package Manoc::View::HTML;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt.html',
    INCLUDE_PATH       => [
        Manoc->path_to( 'root', 'src' ),
        Manoc->path_to( 'root', 'src', 'include' ),
    ],
    PRE_PROCESS => 'init.tt.html',
    WRAPPER     => 'wrapper.tt.html',
    render_die => 1,
);

=head1 NAME

Manoc::View::HTML - TT View for Manoc

=head1 DESCRIPTION

TT View for Manoc.

=head1 SEE ALSO

L<Manoc>

=head1 AUTHOR

Gabriele

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

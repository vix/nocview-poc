package Manoc::View::JavascriptTT;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt.js',
    INCLUDE_PATH       => [
        Manoc->path_to( 'root', 'src', 'js' ),
    ],
    render_die => 1,
);

=head1 NAME

Manoc::View::JS - TT View for Manoc Javascript files

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

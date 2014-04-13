package Manoc;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.90;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
/;

my @todo = qw/
    Authentication
    Authorization::Roles

    Session
    Session::Store::DBI
    Session::State::Cookie

    StackTrace
/;


extends 'Catalyst';

our $VERSION = '2.99';

# Configure the application.
#
# Note that settings in manoc.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'Manoc',
    default_view => 'HTML',

    'Plugin::Static::Simple' => {
	dirs => [
	    'static',
	    ]
    },

    'Plugin::Authentication'                    => {
        default_realm => 'progressive',
        realms        => {
            progressive => {
                class  => 'Progressive',
                realms => [ 'normal', 'agents' ],
            },
            normal => {
                credential => {
                    class              => 'Password',
                    password_field     => 'password',
                    password_type      => 'hashed',
                    password_hash_type => 'MD5'
                },
                store => {
                    class         => 'DBIx::Class',
                    user_model    => 'ManocDB::User',
                    role_relation => 'roles',
                    role_field    => 'role',
                }
            },
            agents => {
                credential => {
                    class              => 'HTTP',
                    type               => 'basic',      # 'digest' or 'basic'
                    password_field     => 'password',
                    username_field     => 'login',
                    password_type      => 'hashed',
                    password_hash_type => 'MD5',
                },
                store => {
                    class         => 'DBIx::Class',
                    user_model    => 'ManocDB::User',
                    role_relation => 'roles',
                    role_field    => 'role',
                }
            },
        },
    },

    #remove stale sessions from db
    'Plugin::Session' => {
        expires           => 28800,
        dbi_dbh           => 'ManocDB',
        dbi_table         => 'sessions',
        dbi_id_field      => 'id',
        dbi_data_field    => 'session_data',
        dbi_expires_field => 'expires',
    },

    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header => 1, # Send X-Catalyst header
);

# Start the application
__PACKAGE__->setup();

=encoding utf8

=head1 NAME

Manoc - Catalyst based application

=head1 SYNOPSIS

    script/manoc_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<Manoc::Controller::Root>, L<Catalyst>

=head1 AUTHOR

See README

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

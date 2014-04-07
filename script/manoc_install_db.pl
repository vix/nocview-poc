#!/usr/bin/env perl

use strict;
use warnings;

use aliased 'DBIx::Class::DeploymentHandler' => 'DH';
use Getopt::Long;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Manoc::DB;

 my $force_overwrite = 0;

 unless ( GetOptions( 'force_overwrite!' => \$force_overwrite ) ) {
     die "Invalid options";
 }

 my $schema = Manoc::DB->connect('dbi:SQLite:manoc.db');

 my $dh = DH->new(
     {
         schema              => $schema,
         script_directory    => "$FindBin::Bin/../dbicdh",
         databases           => 'SQLite',
         sql_translator_args => { add_drop_table => 0 },
         force_overwrite     => $force_overwrite,
     }
 );

 $dh->prepare_install;
 $dh->install;

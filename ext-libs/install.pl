#!/usr/bin/env perl

use strict;
use warnings;
use File::Find;
use File::Copy;
use File::Remove 'remove';
use File::Spec;

my $DOWNLOAD_DIR='download';
my $EXTRACT_DIR='extract';

my $CATALYST_DIR= File::Spec->rel2abs('../root/static/lib');
-d $CATALYST_DIR || die "cannot find catalyst static directory";
my $JS_DIR = "$CATALYST_DIR/js";
my $CSS_DIR = "$CATALYST_DIR/css";
my $FONTS_DIR = "$CATALYST_DIR/fonts";
my $IMAGES_DIR = "$CATALYST_DIR/images";


sub get_filename {
    my $url = shift;

    $url =~ m|/([^/]+)$| and return $1;
    die "don't know how to save url $url";
}

sub download_extract {
   my ($url, $filename) = @_;
   
   $filename ||= "$DOWNLOAD_DIR/".get_filename($url); 
   
   -f $filename || download($url, $filename);
   system("unzip", $filename, "-d", $EXTRACT_DIR);
}

sub download {
    my ($url, $filename) = @_;

    $filename ||= get_filename($url); 
    system ("curl", "-L", "-s", "-S", $url, "-o", "$EXTRACT_DIR/$filename");
}

sub install_file {
    my $dest;

    -f or return;

    /\.js$/  and $dest = $JS_DIR;
    /\.css$/ and $dest = $CSS_DIR;
    /^glyphicons/ and $dest = $FONTS_DIR;

    $dest or return;

    copy($_, $dest) and print "$_ -> $dest\n" or die "cannot move $_ to $dest: $!";
}

mkdir $DOWNLOAD_DIR unless -d $DOWNLOAD_DIR;

-d $EXTRACT_DIR && remove(\1, $EXTRACT_DIR);
mkdir $EXTRACT_DIR;

download_extract("http://code.angularjs.org/1.2.9/angular-1.2.9.zip");
download_extract("https://github.com/twbs/bootstrap/releases/download/v3.1.1/bootstrap-3.1.1-dist.zip");

#provided by bootstrap
#download( "http://code.jquery.com/jquery-1.11.0.min.js");
#download( "http://code.jquery.com/jquery-1.11.0.js");

find( \&install_file, $EXTRACT_DIR  );


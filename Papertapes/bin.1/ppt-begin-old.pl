#!/usr/bin/perl -w

use strict;
use Config::Tiny;

my $ppt = Config::Tiny->read( "ppt.ini" ) or die "Can't open ppt.ini";

my $begin = shift @ARGV;

unless ( $begin ) {
    if ( $ppt->{ content }{ begin } ) {
	printf "%s\n", $ppt->{ content }{ begin };
	exit 0;
    } else {
	printf STDERR "<unset>\n";
	exit 1;
    }
}

unless ( $begin == $begin + 0 ) {
    die "Argument is not numeric";
}

$ppt->{ content }{ begin } = $begin;

$ppt->write( "ppt.ini" );


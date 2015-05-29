#!/usr/bin/perl -w

use strict;
use Config::Tiny;

my $ppt = Config::Tiny->read( "ppt.ini" ) or die "Can't open ppt.ini";

my $end = shift @ARGV;

unless ( $end ) {
    if ( $ppt->{ content }{ end } ) {
	printf "%s\n", $ppt->{ content }{ end };
	exit 0;
    } else {
	printf STDERR "<unset>\n";
	exit 1;
    }
}

unless ( $end == $end + 0 ) {
    die "Argument is not numeric";
}

$ppt->{ content }{ end } = $end;

$ppt->write( "ppt.ini" );


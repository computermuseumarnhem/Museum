#!/usr/bin/perl

# vim: set sw=4 sts=4 si:

use strict;
use File::Basename;
use lib dirname( $0 );
use PPT;

my @ppts = @ARGV;

foreach my $f ( @ppts ) {
    my $ppt = PPT->open( $f ) or next;

    my @ascii = $ppt->raw()->data();

    foreach ( 0 .. $#ascii ) {

	next unless $ascii[ $_ ] & 0x80;

	next if ( $ascii[ $_ ] == 0xff and $ascii[ $_ - 1 ] == 0x89 ); # del after tab
	next if ( $ascii[ $_ ] == 0x8d and $ascii[ $_ + 1 ] == 0x8a ); # cr before lf

	print chr($_);
    }

}


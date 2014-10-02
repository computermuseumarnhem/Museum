#!/usr/bin/perl -w

use strict;

use Config::Tiny;
use File::Basename;

my @ppt = glob( "*/ppt.ini" );

foreach ( sort @ppt ) {

	my $ini = Config::Tiny->read( $_ );
	my $l = $ini->{ label };
	my $b = $ini->{ location };
	my $loc = '';

	if ( $b->{ box } ) {
		$loc = sprintf( "%02d/%02d", $b->{ box }, $b->{ slot } );
	}	

	printf "%-25s %-5s %-25s %s\n", 
		dirname( $_ ) . ":",
		$loc,		
		$l->{ label }, 
		join( " ", grep { $_ } ( $l->{ desc }, $l->{ desc1 }, $l->{ desc2 } ) );

}

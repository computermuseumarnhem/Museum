#!/usr/bin/perl -w

use strict;

use Config::Tiny;
use File::Basename;

my @ppt = glob( "*/ppt.ini" );

foreach ( sort @ppt ) {

	my $ini = Config::Tiny->read( $_ );
	my $l = $ini->{ label };

	printf "%-25s %-25s %s\n", 
		dirname( $_ ) . ":",
		$l->{ label }, 
		join( " ", grep { $_ } ( $l->{ desc }, $l->{ desc1 }, $l->{ desc2 } ) );

}

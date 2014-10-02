#!/usr/bin/perl -w

use strict;

use Config::Tiny;
use File::Basename;

my ( $dir, $box, $slot )  = @ARGV;


die "Usage: ppt box [<dir> [<box> <slot>]]\n" if ( $dir || '' ) eq '-h';

my @ppt;

if ( $dir ) {
	@ppt = glob( "$dir/ppt.ini" );
} else {
	@ppt = glob( "*/ppt.ini" );
}

foreach ( sort @ppt ) {

	die "No ppt.ini found in $_\n" unless -e "$_";
	my $ini = Config::Tiny->read( "$_" );

	if ( $box ) {
		die "Usage: ppt box <dir> <box> <slot>\n" unless $slot;
		
		$ini->{ location }{ box } = $box;
		$ini->{ location }{ slot } = $slot;

		$ini->write( "$_" );
	}		

	printf "%02d/%02d: %s %s\n", 
		$ini->{ location }{ box } || 0, 
		$ini->{ location }{ slot } || 0, 
		$ini->{ label }{ label }, 
		join " ", grep { $_ } ( 
			$ini->{ label }{ desc }, 
			$ini->{ label }{ desc1 }, 
			$ini->{ label }{ desc2 } 
		);

}


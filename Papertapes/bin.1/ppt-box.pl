#!/usr/bin/perl -w

use strict;

use Config::Tiny;
use File::Basename;

my ( $dir, $tray, $slot )  = @ARGV;


die "Usage: ppt box [<dir> [<tray> <slot>]]\n" if ( $dir || '' ) eq '-h';

my @ppt;

if ( $dir ) {
	@ppt = glob( "$dir/ppt.ini" );
} else {
	@ppt = glob( "*/ppt.ini" );
}

foreach ( sort @ppt ) {

	die "No ppt.ini found in $_\n" unless -e "$_";
	my $ini = Config::Tiny->read( "$_" );

	if ( $tray ) {
		die "Usage: ppt box <dir> <tray> <slot>\n" unless $slot;
		
		$ini->{ location }{ tray } = $tray;
		$ini->{ location }{ slot } = $slot;

		$ini->write( "$_" );
	}		

	printf "%02d/%02d: %s %s\n", 
		$ini->{ location }{ tray } || 0, 
		$ini->{ location }{ slot } || 0, 
		$ini->{ label }{ id }, 
		join " ", grep { $_ } ( 
			$ini->{ label }{ 'desc.0' }, 
			$ini->{ label }{ 'desc.1' }, 
			$ini->{ label }{ 'desc.2' } 
		);

}


#!/usr/bin/perl -w
# vim: set sw=4 sts=4 si:

use strict;
use File::Basename;
use lib dirname( $0 );
use PPT;

my @ppts = @ARGV;

foreach my $f ( @ppts ) {

    my $ppt = PPT->open( $f ) or next;

    my $l = $ppt->label();
    my $b = $ppt->location();
    my $loc = '';

    if ( $b->tray() ) {
	$loc = sprintf( "%02d/%02d", $b->tray(), $b->slot() );
    }	

    printf "%-25s %-5s %-25s %s\n", 
	$f  . ":",
	$loc,		
	$l->id(), 
	$l->desc( 0 .. 9 ); 

}

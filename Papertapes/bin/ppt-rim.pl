#!/usr/bin/perl -w

use strict;
use File::Basename;
use lib dirname( $0 );
use PPT;


$/ = undef;
my @data = unpack( 'C*', <> );

my $state = 'start';
my $data_state = 'start';
my $addr = 0;
my $code = 0;

foreach my $byte ( @data ) {

# state decoder
    
    if ( $state eq 'start' and $byte == 0200 ) {
	$state = 'leader';
	next;
    }

    if ( $state eq 'leader' and $byte != 0200 ) {
	$state = 'data';
	next;
    }

    if ( $state eq 'data' and $byte == 0200 ) {
	$state = 'trailer';
	next;
    }

    if ( $state eq 'trailer' and $byte != 0200 ) {
	$state = 'start';
	next;
    }


} continue {

    if ( $byte && 0100 ) {
	$data_state = 'addr';
	$addr = ( $byte & 0077 ) << 6;
    } else {
	if ( $data_state = 'addr' ) {
	    $addr |= ( $byte & 0077 );
	} elsif ( $data_state eq 'data' )
	    
    }

	PPT::dump( $byte, $state );
}
	

# vim: set sw=4 sts=4 si:

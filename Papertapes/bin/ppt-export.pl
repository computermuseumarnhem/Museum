#!/usr/bin/perl -w
# vim: set sw=4 sts=4 si:

use strict;
use Config::Tiny;
use JSON;

$| = 1;

my ( $label, $ascii );

while ( my $arg = shift ) {

    if ( substr( $arg, 0, 1 ) eq '-' ) {
	$label = $arg if $arg eq '-label';
	$ascii = $arg if $arg eq '-ascii';
	next;
    }

    next unless -e "$arg/ppt.json";

    open PPT, '<', "$arg/ppt.json" or die "can't open $arg/ppt.json: $!";
    local $/ = undef;
    my $json = JSON->new->ascii->decode( <PPT> );
    close PPT;

    if ( $label ) {
	printf "%-24.24s  %-10.10s  %s\n", 
	    $json->{ label }{ label } || '',
	    $json->{ label }{ date } || '',
	    $json->{ label }{ code } || '';
	foreach ( 0 .. 3 ) {
	    printf "%s\n", $json->{ label }{ description }[ $_ ] || '';
	}
	printf "%s\n", $json->{ label }{ copyright } || '';
    }

    if ( $ascii ) {
	foreach ( @{ $json->{ content }{ raw } } ) {
	    if ( $_ & 0200 ) {
		my $c = $_ & 0177;
		if ( $c < 32 ) {
		    print "\t" if $c == 9;
		    print "\f" if $c == 12;
		    print "\n" if $c == 10;
		} elsif ( $c < 127 ) {
		    print chr( $c );
		}
	    }
	}
    }

    
}

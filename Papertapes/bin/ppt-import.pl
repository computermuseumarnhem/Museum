#!/usr/bin/perl -w
# vim: set sw=4 sts=4 si:

use strict;
use Config::Tiny;
use JSON::PP;

$| = 1;

while ( my $arg = shift ) {

    next unless -e "$arg/ppt.ini";

    print "[    ] $arg";

    my $ini = Config::Tiny->read( "$arg/ppt.ini" ) or die sprintf ( "%s: %s", Config::Tiny::errstr() || '', "$!" );

    my $json = {};

    $json->{ label }{ label } = $ini->{ label }{ label };
    $json->{ label }{ code } = $ini->{ label }{ code } if $ini->{ label }{ code };
    $json->{ label }{ date } = $ini->{ label }{ date } if $ini->{ label }{ date };
    $json->{ label }{ description } = [ grep { $_ } (
	$ini->{ label }{ desc },
	$ini->{ label }{ desc1 },
	$ini->{ label }{ desc2 }
    ) ];
    if ( $ini->{ label }{ year } ) {
	$json->{ label }{ copyright } = sprintf( "Copyright %s Digital Equipment Corporation", $ini->{ label }{ year } );

	if ( $ini->{ label }{ format } eq 'vg' ) {
	    $json->{ label }{ copyright } = "Copyright VG Data Systems";
	}
    }

    $json->{ location } = sprintf "Box %s, slot %s", 
	$ini->{ location }{ box },
	$ini->{ location }{ slot } if $ini->{ location };

    if ( -e "$arg/content.raw" ) {
	open RAW, '<', "$arg/content.raw" or die "Can't open $arg/content.raw: $!";
	binmode RAW;
	local $/ = undef;
	$json->{ content }{ raw } = [ unpack "C*", <RAW> ];
	close RAW;
    }

    open OUT, '>', "$arg/ppt.json" or die "Can't write to $arg/json.ppt: $!";
    print OUT JSON::PP->new->ascii->encode( $json );
    close OUT;
    #print JSON::PP->new->ascii->pretty->encode( $json );
    print "\r[DONE] $arg\n";
    
}

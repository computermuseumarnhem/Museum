#!/usr/bin/perl -w
# vim: set sw=4 sts=4 si:

use strict;
use Config::Tiny;

my $ppt = Config::Tiny->read( 'ppt.ini' ) or 
    die sprintf "Can't open ppt.ini: %s %s", "$!", Config::Tiny::errstr();

$ppt->{ content }{ raw } ||= 'content.raw';

open my $fh, '<', $ppt->{ content }{ raw } or 
    die sprintf "Can't open %s: %s", $ppt->{ content }{ raw },  "$!";

binmode $fh;
$/ = undef;
my @raw = unpack ( "C*", <$fh> );
close $fh;

$ppt->{ content }{ begin } ||= 0;
$ppt->{ content }{ end }   ||= $#raw;

$ppt->write( 'ppt.ini' );

sub dump_ppt {
    my $b = shift;

    return
	( ( $b & 0x80 ) ? 'o' : ' ' ) .
	( ( $b & 0x40 ) ? 'o' : ' ' ) .
	( ( $b & 0x20 ) ? 'o' : ' ' ) .
	( ( $b & 0x10 ) ? 'o' : ' ' ) .
	( ( $b & 0x08 ) ? 'o' : ' ' ) .
	'.' .
	( ( $b & 0x04 ) ? 'o' : ' ' ) .
	( ( $b & 0x02 ) ? 'o' : ' ' ) .
	( ( $b & 0x01 ) ? 'o' : ' ' );
}

my @ascii = qw( NUL SOH STX ETX EOT ENQ ACK BEL BS HT LF VT FF CR SO SI DLE DC1 DC2 DC3 DC4 NAK SYN ETB CAN EM SUM ESC FS GS RS US SPACE );

sub dump_ascii {
    my $b = shift;

    if ( $b < 32 ) {
	return sprintf( "%-3s ^%1s", $ascii[ $b ], chr( $b + 64 ) );
    } elsif ( $b == 32 ) {
	return $ascii[ $b ];
    } elsif ( $b == 127 ) {
	return "DEL";
    } elsif ( $b > 127 ) { 
	return "";
    } else {
	return chr( $b );
    } 	 
}

printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\n", " ADDR", "DEC"," HEX"," OCT"," CHAR", "       PPT",   "Some decoding";
printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\n", "------", "---","----","----","------","-----------", "--------------------";

foreach my $a ( $ppt->{ content }{ begin } .. $ppt->{ content }{ end } ) {

    my $b = $raw[ $a ];

    printf "%5d:\t%3d\t0x%02x\t0%03o\t%s\t|%-9.9s|", $a, $b, $b, $b, dump_ascii( $b ), dump_ppt( $b );
    if ( $b & 0200 ) {
	printf "\t%s", dump_ascii( $b & 0177 );
    }
    print "\n";
		
}

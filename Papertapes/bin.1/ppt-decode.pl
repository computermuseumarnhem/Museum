#!/usr/bin/perl -w

use strict;

sub debug {
#	my ( $fmt, @arg ) = @_;
#	warn sprintf $fmt, @arg;
}

my $tape;

my $filename = shift @ARGV or die "Usage: ppt-decode <filename>\n";

open FH, '<', $filename or die "Can't open $filename: $!";
read( FH, $tape, -s $filename ) == -s $filename or die "Error reading from $filename";
close FH;

debug( "read %s bytes\n", length( $tape ) );

my $state = 0;
my $field = 0;
my $addr  = 0;
my $data  = 0;
my $byte  = 0;

# trim 0200 from start and finish;

$tape =~ s/^\x80*//;
$tape =~ s/\x80*$//;

debug( "after trimming: %s bytes\n", length( $tape ) );

my @tape = unpack( 'C*', $tape );

debug( "split into an array of %s bytes\n", scalar( @tape ) );

while ( @tape ) {

	$byte = shift @tape;

	my $flag = $byte & 0300;

	debug( "flag, byte = %04o, %04o\n", $flag, $byte );

	if ( $flag == 0100 ) {
		# address pair
		$addr = ( $byte & 0077 ) << 6;
		$byte = shift @tape;
		$addr |= ( $byte & 0077 );
	}

	if ( $flag == 0200 ) {
		# dunno;
	}

	if ( $flag == 0300 ) {
		# field setting;
		$field = ( $byte & 0070 ) >> 3;
	}

	if ( $flag == 0000 ) {
		# data pair
		$data = ( $byte & 077 ) << 6;
		$byte = shift @tape;
		$data |= ( $byte & 0077 );
		printf "%1o.%04o/\t%04o\n", $field, $addr, $data;
		$addr++;
	}

}

#!/usr/bin/perl -w

use strict;

use Device::SerialPort;

my ( $comport, $baudrate, $parity, $databits, $stopbits, $handshake ) = 
	qw( /dev/ttyUSB0 1200 none 8 1 none );

my ( $output ) = qw( content.raw );

while ( my $arg = shift @ARGV ) {

	if ( $arg eq '-b' ) { 
		$baudrate = shift @ARGV;
		next;
	}

	if ( $arg eq '-p' ) {
		$parity = shift @ARGV;
		next;
	}

	if ( $arg eq '-d' ) {
		$databits = shift @ARGV;
		next;
	}

	if ( $arg eq '-s' ) {
		$handshake = shift @ARGV;
		next;
	}

	if ( $arg eq '-h' ) {
		$handshake = shift @ARGV;
		next;
	}

	if ( $arg eq '-o' ) {
		$output = shift @ARGV;
		next;
	}

	if ( $arg ) {
		$comport = shift @ARGV;
		next;
	}

}
		 
warn "Setting port: $comport\n";
my $port = Device::SerialPort->new( $comport );

warn "   baudrate:  $baudrate\n";
$port->baudrate( $baudrate );

warn "   parity:    $parity\n";
$port->parity( "none" );

warn "   databits:  $databits\n";
$port->databits( 8 );

warn "   stopbits:  $stopbits\n";
$port->stopbits( 1 );

warn "   handshake: $handshake\n";
$port->handshake( $handshake );

$port->read_char_time( 0 );
$port->read_const_time( 1000 );
my $timeout = 10;

warn "Writing to \"$output\"\n";
open FH, ">", "$output" or die "Can't write \"$output\": $!";


while ( $timeout > 0 ) {

	my ( $count, $data ) = $port->read( 255 );

	if ( $count > 0 ) {
		print FH $data;
	} else { 
		$timeout--;
		print STDERR "."
	}
}

close FH;

print STDERR "\n";


#!/usr/bin/perl -w

use strict;

use Device::SerialPort;

my ( $comport, $baudrate, $parity, $databits, $stopbits, $handshake ) = 
	qw( /dev/ttyS0   1200 none 8 1 none );

my ( $output ) = qw( content.raw );
my $ascii = 0;

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

	if ( $arg eq '-a' ) {
		$ascii = 1;
		$| = 1;
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

my @ctrl = (
# 0   1   2   3   4   5   6   7   8   9     10    11  12          13  14  15
  '', '', '', '', '', '', '', '', '', "\t", "\n", '', "\n<FF>\n", '', '', '',

#16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31
 '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''
);


while ( $timeout > 0 ) {

	my ( $count, $data ) = $port->read( 255 );

	if ( $count > 0 ) {
		print FH $data;
		if ( $ascii ) {
			my @d = unpack ( "C*", $data );
			foreach ( @d ) {
				$_ &= 0x7f;
				if ( $_ < 32 ) {
					print $ctrl[ $_ ];
				} else {
					print chr( $_ );
				}
			}
		}
		
	} else { 
		$timeout--;
		print STDERR "."
	}
}

close FH;

print STDERR "\n";


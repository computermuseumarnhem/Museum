#!/usr/bin/perl -w

use strict;
use Data::Dumper;

use PDP8;

my $core = PDP8::Core->new();
my $addr = -1;
my $data = 0;

binmode STDIN;
$/ = undef;
my @rim = unpack 'C*', <>;

while ( @rim ) {
	my $f = shift @rim;
	next if ( $f & 0200 ) == 0200;
	if ( $f & 0100 ) {
		$addr = ( $f & 077 ) << 6;
		$addr |= ( shift @rim ) & 077;
	} else {
		$data = ( $f & 077 ) << 6;
		$data |= ( shift @rim ) & 077;
		$core->add( $addr, $data );
		$addr++;
	}
}

$core->disassemble();
$core->crossref();

$core->listing();

__DATA__
7756	6032
	6031
	5357
	6036
	7106
	7006
	7510
	5357
	7006
	6031
	5367
	6034
	7420
	3776
	3376
	5356

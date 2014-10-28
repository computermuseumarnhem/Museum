#!/usr/bin/perl -w

use strict;
use Data::Dumper;

use PDP8;

my $core = PDP8::Core->new();
my $addr = -1;
my $data = 0;

while ( <DATA> ) {
	chomp;
	my ( $a, $d ) = split /\s+/;
	$addr = oct($a) || $addr + 1;
	next unless $data = oct($d);
	$core->add( $addr, $data );
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

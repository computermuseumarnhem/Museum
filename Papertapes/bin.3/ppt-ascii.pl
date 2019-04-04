#!/usr/bin/perl

use strict;

$/ = undef;

my @ascii = unpack( "C*", <>  );

my $tab = 0;
my $nwl = 0;
my $nul = 0;

foreach ( @ascii ) {

	if ( $_ == 0 ) {
		printf "%s\n", '-' x 80 unless $nul;
		$nul = 1;
	}

	next unless $_ & 0x80;

	$nul = 0;

	$_ &= 0x7f;

	if ( $tab && $_ == 0x7f ) {
		$tab = 0;
		next;
	}
	if ( $_ == 0x09 ) {
		$tab = 1;
	}

	print chr($_);

}


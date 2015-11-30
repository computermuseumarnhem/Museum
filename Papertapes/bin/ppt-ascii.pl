#!/usr/bin/perl

use strict;

$/ = undef;

my @ascii = unpack( "C*", <>  );

my $tab = 0;
my $nwl = 0;

foreach ( @ascii ) {

	next unless $_ & 0x80;

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


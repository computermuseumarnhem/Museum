#!/usr/bin/perl -w

use strict;

use Config::Tiny;

my @dirs = @ARGV;

foreach my $dir ( @dirs ) {

	my $ppt = Config::Tiny->new();

	my @descr = `cat "$dir"/descr.txt`;
	chomp @descr;

	$ppt->{ label }{ label } = $dir;
	$ppt->{ content }{ raw } = "content.bin";
	$ppt->{ label }{ "desc" } = $descr[ 0 ] || '';
	$ppt->{ label }{ "desc1" } = $descr[ 1 ] || '';
	$ppt->{ label }{ "desc2" } = $descr[ 2 ] || '';

	$ppt->write( "$dir/ppt.ini" );

}


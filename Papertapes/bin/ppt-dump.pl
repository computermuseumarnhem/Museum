#!/usr/bin/perl -w

# vim: set sw=4 sts=4 si:

use strict;
use Data::Printer;

my $length = 16;

my @line = ();
my $index = 0;

while ( my $c = getc ) {

    push @line, $c;

    unless ( scalar @line < $length ) {
	print_line( $index, @line );
	$index += $length;
	@line = ();
    }

}

sub print_line {
    my ( $index, @line ) = @_;

    printf( "%06o  ", $index );
    foreach ( 0 .. $length - 1 ) {
	unless ( $_ % 8 ) {
	    print " ";
	}
	if ( defined $line[ $_ ] ) {
	    printf "%03o ", ord $line[ $_ ];
	} else {
	    print "    ";
	}
    }
    print "  ";
    foreach ( 0 .. $length - 1 ) {
	if ( defined $line[ $_ ] ) {
	    my $c = ord $line[ $_ ] ^ 0200;
	    $c = ord '.' if $c < 32;
	    $c = ord '.' if $c > 126;
	    printf "%c", $c;
	} else { 
	    print " "
	}
    }

    print "\n";
}


#!/usr/bin/perl -w

# vim: set sw=4 sts=4 si:

use strict;
use File::Basename;
use lib dirname( $0 );
use PPT;

use Data::Dumper;

my @ppts = @ARGV;

$| = 1;

sub debug {
    my ( $s, $d ) = @_;

    return sprintf "%s = %s\n", $s, ( defined $d ? $d : "<undef>" );
}

foreach ( @ppts ) {
    
    my $ppt = PPT->open( $_ ) or next;
    
    printf "%s (%d)\n", $ppt->label->id(), $ppt->parts();

    my $c = $ppt->content();
    warn debug( "--- $c->begin()", $c->begin() );
    warn debug( "--- $c->end()  ", $c->end() );
    
    foreach ( 0 .. $ppt->parts() - 1 ) {
	my $p = $ppt->part( $_ ) or next;

	warn debug( "<<< $p->begin()", $p->begin() );
	warn debug( "<<< $p->end()  ", $p->end() );

	$p->begin( $c->begin() ) unless $p->begin();
	$p->end( $c->end() ) unless $p->end();

	warn debug( ">>> $p->begin()", $p->begin() );
	warn debug( ">>> $p->end()  ", $p->end() );

	printf( "    %d:", $_ );
	printf( " %d", $p->begin() );
	printf( " - %d:", $p->end() );
	printf( " %s\n", $p->type() || 'unknown/unknown' );
    }			
    printf( "%s\n", '-' x 40 );

    $ppt->close();
}

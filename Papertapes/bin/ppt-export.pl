#!/usr/bin/perl -w

# vim: set sw=4 sts=4 si:

use File::Basename;
use lib dirname( $0 );
use PPT;
use PPT::Title;

my @ppts = @ARGV;

foreach my $t ( @ppts ) {
    my $ppt = PPT->open( $t ) or next;

    print "\0" x 32;
    print PPT::Title->new( $ppt->label()->id() )->output();
    print "\0" x 32;

    $ppt->close();

}



#!/usr/bin/perl -w

# vim: set sw=4 sts=4 si:

use File::Basename;
use lib dirname( $0 );
use PPT;

my @ppts = @ARGV;

foreach $t ( @ppts ) {
    my $ppt = PPT->open( $t ) or next;

    my @lbl = split /\n/, $ppt->label()->output();
    my @loc = split /\n/, $ppt->location()->output();

    printf " -%s-    %s\n", '-' x length $lbl[0], 'Location:';
    print map { sprintf "| %s |   %s\n", $lbl[$_]||'', $loc[$_]||'' } 0 .. $#lbl;
    printf " -%s- \n", '-' x length $lbl[0];

    print "\n";

    $ppt->close();

}



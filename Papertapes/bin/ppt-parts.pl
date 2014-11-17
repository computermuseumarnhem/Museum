#!/usr/bin/perl -w
# vim: set sw=4 sts=4 si:

use strict;
use File::Basename;
use lib dirname( $0 );
use PPT;

my @ppts = @ARGV;

sub NUMERIC { $a <=> $b; }

foreach my $ini ( @ppts ) {
    my $ppt = PPT->open( $ini ) or next;

    printf "%s\n", $ini;

    printf "%s (%d)\n", $ini, $ppt->parts();
    printf "    %s\n", join "\n    ", map { sprintf "part.%s::type = %s", $_, $parts[ $_ ]->type(); } 0 .. $#parts;

}




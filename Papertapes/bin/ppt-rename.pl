#!/usr/bin/perl -w

use strict;

use Config::Tiny;

my $dir = shift @ARGV;

die "Usage: ppt rename <dir>\n" unless $dir;
die "No ppt.ini found in $dir\n" unless -e "$dir/ppt.ini";

my $ini = Config::Tiny->read( "$dir/ppt.ini" );

die "No label found in $dir/ppt.ini\n" unless $ini->{ label }{ label };

my $label = $ini->{ label }{ label };

die sprintf( "%s already exists. not renaming", $label ) if -d $label;

rename $dir, $label or
	die sprintf "Can't rename %s to %s: $!", $dir, $label;


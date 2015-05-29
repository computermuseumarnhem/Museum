#!/usr/bin/perl -w
#vim: set sw=4s sts=4 si:

use strict;

use File::Basename;
use lib dirname( $0 );
use PPT;

my @ppts = @ARGV;

foreach my $t ( @ppts ) {

	my $ppt = PPT->open( $t ) or next;

	my $lbl = $ppt->label();

	print $lbl->output();




use PPT;
use Text::Wrap qw( wrap $columns );

my $ppt = PPT->new(
my $ini = Config::Tiny->new();

$ini = Config::Tiny->read( 'ppt.ini' ) if -e 'ppt.ini';

my $file = 'label.txt';

$ini->{ label }{ format } ||= 'old';

while ( my $arg = shift @ARGV ) {
	$ini->{ label }{ format } = 'new' if $arg eq 'new';
	$ini->{ label }{ format } = 'vg'  if $arg eq 'vg';
}

sub promptline {
	my ( $prompt, $value ) = @_;

	printf "%s%s", $prompt, $value || '';
	printf "\r%s"  , $prompt;
	my $v = <>;
	chomp $v;
	$value = $v if $v;
	$value = '' if ( $value || '' ) eq '~';

	return $value || '';
}

sub wrap_desc {
	my $d = join "\n", (
		$ini->{ label }{ desc  } || '',
		$ini->{ label }{ desc1 } || '',
		$ini->{ label }{ desc2 } || ''
	);
	$d =~ s/\\n/\n/ig;

	$columns = 36;
	$d = wrap( '', '', $d );

	(
		$ini->{ label }{ desc  },
		$ini->{ label }{ desc1 },
		$ini->{ label }{ desc2 }
	) = split /\n/, $d;

}

if ( $ini->{ label }{ format } eq 'vg' ) {
	$ini->{ label }{ label } = uc promptline( "Label:       ", $ini->{ label }{ label } );
	$ini->{ label }{ date  } = uc promptline( "Date:        ", $ini->{ label }{ date  } );
	$ini->{ label }{ desc  } = uc promptline( "Description: ", $ini->{ label }{ desc  } );
} else {
	$ini->{ label }{ label } = uc promptline( "Label:       ", $ini->{ label }{ label } );
	$ini->{ label }{ date  } = uc promptline( "Date:        ", $ini->{ label }{ date  } );
	$ini->{ label }{ code  } = uc promptline( "Code:        ", $ini->{ label }{ code  } );
	$ini->{ label }{ desc  } = uc promptline( "Description: ", $ini->{ label }{ desc  } );
	$ini->{ label }{ desc1 } = uc promptline( "          :: ", $ini->{ label }{ desc1 } );
	$ini->{ label }{ desc2 } = uc promptline( "          :: ", $ini->{ label }{ desc2 } );
	$ini->{ label }{ year  } = uc promptline( "Copyright:   ", $ini->{ label }{ year  } );
}

wrap_desc();

$ini->{ label }{ desc  } ||= '';
$ini->{ label }{ desc1 } ||= '';
$ini->{ label }{ desc2 } ||= '';

my $label = $ini->{ label }{ label } || '';
my $date  = $ini->{ label }{ date  } || '';
my $code  = $ini->{ label }{ code  } || '';
my $desc  = $ini->{ label }{ desc  } || '';
my $desc1 = $ini->{ label }{ desc1 } || '';
my $desc2 = $ini->{ label }{ desc2 } || '';
my $year  = $ini->{ label }{ year  } || '';

format label_old =
@<<<<<<<<<<<<<<<<<<<<  @>>>>>>>  @<<
$label,                $date,    $code
@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$desc || ''
@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$desc1 || ''
@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$desc2 || ''
        @<<<<<<<<<<<<<<
	$year
.

format label_new =
@<<<<<<<<<<<<<<<<<<<<  @>>>>>>>  @<<
$label,                $date,    $code
@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$desc || ''
@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$desc1 || ''
@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$desc2 || ''
                           @<<<<<<<<<<<<<<
	                   $year
.

format label_vg =
@<<<<<<<<<<<<<<<<<<<<
$label
@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
"(C) VG DATA SYSTEMS LTD"
@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$date
@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$desc || ''
.

$~ = "label_" . $ini->{ label }{ format };
write;

open FH, '>', $file or die "Can't write to $file: $!";
select FH;
$~ = "label_" . $ini->{ label }{ format };

write;
close FH;

$ini->write( 'ppt.ini' );

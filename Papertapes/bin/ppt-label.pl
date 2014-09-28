#!/usr/bin/perl -w

use strict;

use Config::Tiny;

my $ini = Config::Tiny->new();

$ini = Config::Tiny->read( 'ppt.ini' ) if -e 'ppt.ini';

my $file = 'label.txt';

sub promptline {
	my ( $prompt, $value ) = @_;

	printf "%s%s", $prompt, $value || '';
	printf "\r%s"  , $prompt;
	my $v = <>;
	chomp $v;
	$value = $v if $v;

	return $value;
}

$ini->{ label }{ label } = uc promptline( "Label:       ", $ini->{ label }{ label } );
$ini->{ label }{ date  } = uc promptline( "Date:        ", $ini->{ label }{ date  } );
$ini->{ label }{ code  } = uc promptline( "Code:        ", $ini->{ label }{ code  } );
$ini->{ label }{ desc  } = uc promptline( "Description: ", $ini->{ label }{ desc  } );
$ini->{ label }{ year  } = uc promptline( "Copyright    ", $ini->{ label }{ year  } );

my $label = $ini->{ label }{ label };
my $date  = $ini->{ label }{ date  };
my $code  = $ini->{ label }{ code  };
my $desc  = $ini->{ label }{ desc  };
my $year  = $ini->{ label }{ year  };

format LABEL =
@<<<<<<<<<<<<<<<<<<<<  @>>>>>>>  @<<
$label,                $date,    $code
^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$desc
^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$desc
^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$desc
        @<<<<<<<<<<<<<<
	$year
.

$~ = 'LABEL';
write;

open FH, '>', $file or die "Can't write to $file: $!";
select FH;
$~ = 'LABEL';
$desc  = $ini->{ label }{ desc  };
write;
close FH;

$ini->write( 'ppt.ini' );

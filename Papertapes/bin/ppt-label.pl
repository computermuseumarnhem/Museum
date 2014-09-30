#!/usr/bin/perl -w

use strict;

use Config::Tiny;
use Text::Wrap;

my $ini = Config::Tiny->new();

$ini = Config::Tiny->read( 'ppt.ini' ) if -e 'ppt.ini';

my $file = 'label.txt';

$ini->{ label }{ format } = 'old';

while ( my $arg = shift @ARGV ) {
	$ini->{ label }{ format } = 'new' if $arg eq 'new';
}

sub promptline {
	my ( $prompt, $value ) = @_;

	printf "%s%s", $prompt, $value || '';
	printf "\r%s"  , $prompt;
	my $v = <>;
	chomp $v;
	$value = $v if $v;

	return $value || '';
}

{
	my $d = join "\n", (
		$ini->{ label }{ desc  } || '',
		$ini->{ label }{ desc1 } || '',
		$ini->{ label }{ desc2 } || ''
	);
	$d =~ s/\\n/\n/ig;

	$Text::Wrap::columns = 32;
	$d = wrap( '', '', $d );

	(
		$ini->{ label }{ desc  },
		$ini->{ label }{ desc1 },
		$ini->{ label }{ desc2 }
	) = split /\n/, $d;

}

$ini->{ label }{ label } = uc promptline( "Label:       ", $ini->{ label }{ label } );
$ini->{ label }{ date  } = uc promptline( "Date:        ", $ini->{ label }{ date  } );
$ini->{ label }{ code  } = uc promptline( "Code:        ", $ini->{ label }{ code  } );
$ini->{ label }{ desc  } = uc promptline( "Description: ", $ini->{ label }{ desc  } );
$ini->{ label }{ desc1 } = uc promptline( "          :: ", $ini->{ label }{ desc1 } );
$ini->{ label }{ desc2 } = uc promptline( "          :: ", $ini->{ label }{ desc2 } );
$ini->{ label }{ year  } = uc promptline( "Copyright:   ", $ini->{ label }{ year  } );

my $label = $ini->{ label }{ label };
my $date  = $ini->{ label }{ date  };
my $code  = $ini->{ label }{ code  };
my $desc  = $ini->{ label }{ desc  };
my $desc1 = $ini->{ label }{ desc1 };
my $desc2 = $ini->{ label }{ desc2 };
my $year  = $ini->{ label }{ year  };

format label_old =
@<<<<<<<<<<<<<<<<<<<<  @>>>>>>>  @<<
$label,                $date,    $code
@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$desc || ''
@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$desc1 || ''
@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$desc2 || ''
        @<<<<<<<<<<<<<<
	$year
.

format label_new =
@<<<<<<<<<<<<<<<<<<<<  @>>>>>>>  @<<
$label,                $date,    $code
@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$desc || ''
@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$desc1 || ''
@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$desc2 || ''
                           @<<<<<<<<<<<<<<
	                   $year
.

$~ = "label_" . $ini->{ label }{ format };
write;

open FH, '>', $file or die "Can't write to $file: $!";
select FH;
$~ = "label_" . $ini->{ label }{ format };

write;
close FH;

$ini->write( 'ppt.ini' );

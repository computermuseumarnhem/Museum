package PDP8::Instruction;
# vim: set sw=4 sts=4 si:

use strict;
use Data::Dumper;

sub new {
    my $class = shift;
    my $self = bless {}, $class;

    my ( $addr, $code ) = @_;

    $self->{ addr } = $addr;
    $self->{ code } = $code;

    return $self;
}

sub disassemble {
    my $self = shift;

    $self->disassemble_mri() if $self->instruction() <= 5;
    $self->disassemble_iot() if $self->instruction() == 6;
    $self->disassemble_opr() if $self->instruction() == 7;

}

sub disassemble_mri {
    my $self = shift;
    my $mnem = qw( ADD TAD ISZ DCA JMS JMP )[ $self->instruction() ];
    my $refl = qw(  D   D   D   D   S   L  )[ $self->instruction() ];
    my $i    = $self->{ code } & 00400 ? 'I' : '';
    my $z    = $self->{ code } & 00200 ? '' : 'Z';

    $mnem .= " $i$z" if "$i$z";
    $refl = 'I' if $i;

    $self->{ mnem } = $mnem;
    $self->{ dest } = $self->{ code } & 00177;
    $self->{ dest } |= $self->{ addr } & 07600 unless $z;

    $self->{ ref } = sprintf( "%s%04o", $refl, $self->{ dest } );

}

my %devices = (
    000 => {
	mnem => [ qw( SKON ION IOF SRQ GTF RTF SGT CAF ) ]
    },
    003 => {
	device => 'Console TTY',
	short  => 'TT0',
	mnem => [ qw( KCF KSF KCC IOT KRS KIE KRB IOT ) ]
    },
    040 => {
	device => 'Second TTY',
	short => 'TT1',
	mnem => [ qw( KCF KSF KCC IOT KRS KIE KRB IOT ) ]
    },
    065 => {
	device => 'Serial printer',
	short => 'TT2',
	mnem => [ qw( KCF KSF KCC IOT KRS KIE KRB IOT ) ]
    },
    030 => {
	device => 'VT78 serial #1',
	short => 'TT1',
	mnem => [ qw( KCF KSF KCC IOT KRS KIE KRB IOT ) ]
    },
    032 => {
	device => 'VT78 serial #2',
	short => 'TT2',
	mnem => [ qw( KCF KSF KCC IOT KRS KIE KRB IOT ) ]
    },
    004 => {
	device => 'Console TTY',
	short => 'TT0',
	mnem => [ qw( TFL TSF TCF IOT TPC TSK TLS IOT ) ]
    },
    041 => {
	device => 'Second TTY',
	short => 'TT1',
	mnem => [ qw( TFL TSF TCF IOT TPC TSK TLS IOT ) ]
    },
    066 => {
	device => 'Serial printer',
	device => 'TT2',
	mnem => [ qw( TFL TSF TCF IOT TPC TSK TLS IOT ) ]
    },
    031 => {
	device => 'VT78 serial #1',
	short => 'TT1',
	mnem => [ qw( TFL TSF TCF IOT TPC TSK TLS IOT ) ]
    },
    033 => {
	device => 'VT78 serial #2',
	short => 'TT2',
	mnem => [ qw( TFL TSF TCF IOT TPC TSK TLS IOT ) ]
    },
);

sub disassemble_mc8 {
    my $self = shift;

    my @mnem = ()

    if ( ( $self->{ code } & 07707 ) == 06204 ) {
	push @mnem, qw( CINT RDF RIF RIB RMF SINT CUF SUF )[ ( $self->{ code } >> 3 ) & 07 ];
    }
    if ( ( $self->{ code } & 07703 ) == 06201 ) {
	push @mnem, 'CDF';
	$self->{ dest } = ( $self->{ code } >> 3 ) & 07;
    }
    if ( ( $self->{ code } & 07703 ) == 06202 ) {
	push @mnem, 'CIF';
	$self->{ dest } = ( $self->{ code } >> 3 ) & 07;
    }
    if ( ( $self->{ code } & 07703 ) == 06203 ) {
	push @mnem, 'CDI';
	$self->{ dest } = ( $self->{ code } >> 3 ) & 07;
    }
    push @mnem, 'NOP' unless @mnem;
    my $self->{ mnem } = join " ", @mnem; 
}

sub disassemble_iot {
    my $self = shift;

    my $dev = ( $self->{ code } & 00770 ) >> 3;
    my $op  = $self->{ code } & 00007;

    $self->{ mnem } = $devices{ $dev }{ mnem }[ $op ];
    $self->{ dest } = $devices{ $dev }{ short };
    $self->{ comment } = $devices{ $dev }{ device };

    disassemble_mc8 if ( $dev & 070 ) == 020;

}

sub disassemble_opr {
    my $self = shift;

    unless ( $self->{ code } & 00400 ) {
	#group 1
	my @opr = ();
	push @opr, 'CLA' if $self->{ code } & 00200;
	push @opr, 'CLL' if $self->{ code } & 00100;
	push @opr, 'CMA' if $self->{ code } & 00040;
	push @opr, 'CML' if $self->{ code } & 00020;
	push @opr, 'IAC' if $self->{ code } & 00001;

	push @opr, 'BSW' if ( $self->{ code } & 00016 ) == 00002;
	push @opr, 'RAL' if ( $self->{ code } & 00016 ) == 00004;
	push @opr, 'RTL' if ( $self->{ code } & 00016 ) == 00006;
	push @opr, 'RAR' if ( $self->{ code } & 00016 ) == 00010;
	push @opr, 'RTL' if ( $self->{ code } & 00016 ) == 00012;

	@opr = ( 'CIA' ) if $self->{ code } == 07041;
	@opr = ( 'LAS' ) if $self->{ code } == 07604;
	@opr = ( 'STL' ) if $self->{ code } == 07120;
	@opr = ( 'GLK' ) if $self->{ code } == 07204;

	push @opr, 'NOP' unless @opr;

	$self->{ mnem } = join " ", @opr;
	return;
    }
    unless ( $self->{ code } & 00001 ) {
	#group 2
	my @opr = ();
	unless ( $self->{ code } & 00010 ) {
	    #or group
	    push @opr, 'SMA' if $self->{ code } & 00100;
	    push @opr, 'SZA' if $self->{ code } & 00040;
	    push @opr, 'SNL' if $self->{ code } & 00020;
	} else {
	    #and group
	    push @opr, 'SPA' if $self->{ code } & 00100;
	    push @opr, 'SNA' if $self->{ code } & 00040;
	    push @opr, 'SZL' if $self->{ code } & 00020;
	    push @opr, 'SKP' unless @opr;
	}
	push @opr, 'CLA' if $self->{ code } & 00200;
	push @opr, 'OSR' if $self->{ code } & 00004;
	push @opr, 'HLT' if $self->{ code } & 00002;

	push @opr, 'NOP' unless @opr;

	$self->{ mnem } = join " ", @opr;
	return;
    }
    {
	# mq
	my @opr = ();
	push @opr, 'CLA' if $self->{ code } & 00200;
	push @opr, 'MQA' if $self->{ code } & 00100;
	push @opr, 'MQL' if $self->{ code } & 00020;

	@opr = ( 'CAM' ) if $self->{ code } == 07621;
	@opr = ( 'SWP' ) if $self->{ code } == 07521;
	@opr = ( 'ACL' ) if $self->{ code } == 07701;
	@opr = ( 'CLA SWP' ) if $self->{ code } == 07721;

	push @opr, 'NOP' unless @opr;

	$self->{ mnem } = join " ", @opr;
	return;
    }
}

sub instruction {
    my $self = shift;
    return $self->{ code } >> 9;
}

sub display_short {
    my $self = shift;

    my $label = '        ';
    $label = sprintf "%-8.8s", $self->{ label } . ',' if $self->{ label };

    return sprintf "%s%04o", $label, $self->{ code } unless $self->{ mnem };
    return sprintf "%s%s", $label, $self->{ mnem } unless $self->{ dest };
    return sprintf "%s%-8.8s%s", $label, $self->{ mnem }, $self->{ ref } if $self->{ ref };
    return sprintf "%s%-8.8s%s", $label, $self->{ mnem }, $self->{ dest } unless $self->{ dest } =~ /^\d+$/;
    return sprintf "%s%-8.8s%04o", $label, $self->{ mnem }, $self->{ dest };
}

sub display {
    my $self = shift;

    return $self->display_short() unless $self->{ comment };

    return sprintf "%-40.40s// %s", $self->display_short, $self->{ comment };
}

1;

__DATA__
7041	CIA
7601	LAS
7120	STL
7204	GLK


__END__

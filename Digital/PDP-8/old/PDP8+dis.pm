package PDP8;
# vim: set sw=4 sts=4 si:

package PDP8::Core;

use base 'PDP8';

sub new {
    my $class = shift;
    my $core = bless {}, $class;

    return $core; 
}

sub listing {
    my $core = shift;
    
    my $field  = undef;
    my $origin = undef;

    foreach my $addr ( 0 .. 077777 ) {
	next unless $self->{ $addr };

	if ( !defined( $field ) or ( $addr >= ( $field << 12 ) ) ) {
	    $field = $addr >> 12;
	    printf "\t\tfield %1o\n", $field;
	}
	
	if ( !defind( $origin ) or ( abs( $origin - $addr ) > 7 ) ) {
	    $origin = $addr;
	    printf "\t\t*%04o\n", $origin;
	}

	printf "%04o\t%04o\t%s\t%s\t/%s\n", 
	    $addr,
	    $core->{ $addr }{ code },
	    $code->{ $addr }{ mnem },
	    $core->{ $addr }{ dest },
	    $code->{ $addr }{ desc }

    }
}

=pod 

sub disassemble {
    my $core = shift;

    foreach my $addr ( keys %$core ) {
	`my $basic = $core->{ $addr }{ code } & 07000;

	given ( $basic ) {
	    when ( 00000 ) {
		disassemble_mri( $addr, $core->{ $addr }, 'AND', 'logical AND' );
	    }
	    when ( 01000 ) {
		disassemble_mri( $addr, $core->{ $addr }, 'TAD', '2\'s complement add' );
	    }
	    when ( 02000 ) {
		disassemble_mri( $addr, $core->{ $addr }, 'ISZ', 'increment and skip if zero' );
	    }
	    when ( 03000 ) {
		disassemble_mri( $addr, $core->{ $addr }, 'DCA', 'deposit and clear AC' );
	    }
	    when ( 04000 ) {
		disassemble_mri( $addr, $core->{ $addr }, 'JMS', 'jump to subroutine' );
	    }
	    when ( 05000 ) {
		disassemble_mri( $addr, $core->{ $addr }, 'JMP', 'jump' );
	    }
	    when ( 06000 ) {
		disassemble_iot( $addr, $core->{ $addr }, 'IOT', 'in/out transfer' );
	    }
	    when ( 07000 ) {
		disassemble_opr( $addr, $core->{ $addr }, 'OPR', 'operate' );
	    }
	}
    }
}

sub disassemble_mri {
    my ( $addr, $core, $mnem, $desc ) = @_;

    my $i = ( $core->{ code } & 00400 ) ? 'I' : '';
    my $z = ( $core->{ code } & 00200 ) ? ''  : 'Z';
    
    $mnem .= " $i$z" if "$i$z";
    $desc .= '; indirect' if $i;
    $desc .= '; zero-page' if $z;

    $core->{ dest } = $core->{ code } & 00177;
    $core->{ dest } |= ( $addr & 07600 ) unless $z;
    $core->{ mnem } = $mnem;
    $core->{ description } = $desc;

}

sub disassemble_iot {
    my ( $addr, $core, $mnem, $desc ) = @_;
    ...
}

sub disassemble_opr {
    my ( $addr, $core, $mnem, $desc ) = @_;

    my @opr = ();
    my @dsc = ();

    if ( ( $core->{ code } & 07400 ) == 07000 ) {
	# group 1
	if ( $core->{ code } & 00200 ) {
	    push @opr, 'CLA';
	    push @dsc, 'clear AC';
	}
	if ( $core->{ code } & 00100 ) {
	    push @opr, 'CLL';
	    push @dsc, 'clear link';
	}
	if ( $core->{ code } & 00040 ) {
	    push @opr, 'CMA';
	    push @dsc, 'complement AC';
	}
	if ( $core->{ code } & 00020 ) {
	    push @opr, 'CML';
	    push @dsc, 'complement link';
	}
	if ( $core->{ code } & 00001 ) {
	    push @opr, 'IAC';
	    push @dsc, 'increment AC';
	}
	if ( ( $core->{ code } & 00016 ) = 00002 ) {
	    push @opr, 'BSW';
	    push @dsc, 'swap bytes in AC';
	}
	if ( ( $core->{ code } & 00016 ) = 00004 ) {
	    push @opr, 'RAL';
	    push @dsc, 'rotate AC and link left one';
	}
	if ( ( $core->{ code } & 00016 ) = 00006 ) {
	    push @opr, 'RTL';
	    push @dsc, 'rotate AC and link left two';
	}
	if ( ( $core->{ code } & 00016 ) = 00010 ) {
	    push @opr, 'RAR';
	    push @dsc, 'rotate AC and link right one';
	}
	if ( ( $core->{ code } & 00016 ) = 00012 ) {
	    push @opr, 'RTR';
	    push @dsc, 'rotate AC and link right two';
	}
	if ( ( $core->{ code } & 00016 ) = 00014 ) {
	    push @opr, 'RAL', 'RAR';
	    push @dsc, 'nop AC and link one';
	}
	if ( ( $core->{ code } & 00016 ) = 00016 ) {
	    push @opr, 'RTL', 'RTR';
	    push @dsc, 'nop AC and link two';
	}
    }
    if ( ( $core->{ code } & 07401 ) == 07400 ) {
	# group 2
	if ( $core->{ code } & 00010 ) {
	    push @dsc, '(and)';
	    # and group
	    if ( $core->{ code } & 00100 ) {
		push @opr, 'SPA';
		push @dsc, 'skip on plus AC';
	    }
	    if ( $core->{ code } & 00040 ) {
		push @opr, 'SNA';
		push @dsc, 'skip on non-zero AC';
	    }
	    if ( $core->{ code } & 00020 ) {
		push @opr, 'SZL';
		push @dsc, 'skip on zero link';
	    }
	} else {
	    # or group
	    push @dsc, '(or)';
	    if ( $core->{ code } & 00100 ) {
		push @opr, 'SMA';
		push @dsc, 'skip on minus AC';
	    }
	    if ( $core->{ code } & 00040 ) {
		push @opr, 'SZA';
		push @dsc, 'skip on zero AC';
	    }
	    if ( $core->{ code } & 00020 ) {
		push @opr, 'SNL';
		push @dsc, 'skip on non-zero link';
	    }
	}
	if ( $core->{ code } & 00200 ) {
	    push @opr, 'CLA';
	    push @dsc, 'clear AC';
	}
	if ( $core->{ code } & 00004 ) {
	    push @opr, 'OSR';
	    push @dsc, 'inclusive OR switch register with AC';
	}
	if ( $core->{ code } & 00002 ) {
	    push @opr, 'HLT';
	    push @dsc, 'Halts the program';
	}
    }
    if ( ( $core->{ code } & 07401 ) == 07401 ) {
	if ( $core->{ code } & 00200 ) {
	    push @opr, 'CLA';
	    push @dsc, 'clear AC';
	}
	if ( $core->{ code } & 00100 ) {
	    push @opr, 'MQA';
	    push @dsc, 'inclusive OR the MQ with the AC';
	}
	if ( $core->{ code } & 00020 ) {
	    push @opr, 'MQL';
	    push @dsc, 'load MQ with AC, then clear AC';
	}
    }

    $mnem = join ' ', @opr;
    $desc = join '; ', @dsc;

    if ( $specials{ $core->{ code } ) {
	$mnem = $specials{ $core->{ code } }{ mnem };
	$desc = $specials{ $core->{ code } }{ desc };
    }

}

=cut

1;

__DATA__
7041	CIA	complement and increment AC
7604	LAS	load AC with switch register
7120	STL	set link (to 1)
7204	GLK	get link (put link in AC bit 11)

7325	CLA CLL CMA RTR	load AC with -1025(d) 5777(o)
7333	CLA CLL CML IAC RTR	load AC with -1024(d) 6000(o)
7346	CLA CLL CMA RTL	load AC with -3(d) 7775(o)
7344	CLA CLL	CMA RAL	load AC with -2(d) 7776(o)
7340	CLA CLL CMA	load AC with -1(d) 7777(o)
7330	CLA CLL CML RAR	load AC with -0(d) 4000(o)
7300	CLA CLL	load AC with 0(d) 0000(o)
7301	CLA CLL IAC	load AC with 1(d) 0001(o)
7305	CLA CLL IAC RAL	load AC with 2(d) 0002(o)
7326	CLA CLL CML RTL load AC with 2(d) 0002(o)
7325	CLA CLL	CML IAC RAL	load AC with 3(d) 0003(o)
7307	CLA CLL IAC RTL	load AC with 4(d) 0004(o)
7327	CLA CLL CML IAC RTL	load AC with 6(d) 0006(o)
7302	CLA IAC BSW	load AC with 64(d) 0100(o)
7332	CLA CLL CML RTR	load AC with 1024(d) 2000(o)
7350	CLA CLL CMA RAR load AC with 2047(d) 3777(o)

7401	NOP	no operation
7621	CAM	clear AC and MQ
7521	SWP	swap AC and MQ
7701	ACL	load MQ into AC
7721	CLA SWP	load AC from MQ, then clear MQ

6000	SKON	skip if interrupt ON, and turn OFF
6001	ION	turn interrupt ON
6002	IOF	turn interrupt OFF
6003	SRQ	skip on interrupt request
6004	GTF	get interrupt flags
6005	RTF	restore interrupt flags
6006	SGT	skip on Greater Than flag
6007	CAF	clear all flags

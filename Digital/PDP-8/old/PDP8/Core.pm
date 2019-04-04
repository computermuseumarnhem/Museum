package PDP8::Core;
# vim: set sw=4 sts=4 si:

use strict;
use Data::Dumper;

use PDP8::Instruction;

sub new {
    my $class = shift;
    my $core = bless {}, $class;

    return $core; 
}

sub add {
    my $core = shift;
    my ( $addr, $data ) = @_;

    $core->{ $addr } = PDP8::Instruction->new( $addr, $data );
}

sub listing {
    my $core = shift;
    
    my $field  = undef;
    my $origin = undef;

    foreach my $addr ( 0 .. 077777 ) {
	next unless $core->{ $addr };

	if ( !defined( $field ) or ( $addr >> 12 ) != $field ) {
	    $field = $addr >> 12;
	    printf "                        field %1o\n", $field;
	}
	
	if ( !defined( $origin ) or abs( $origin - $addr ) > 7 ) {
	    $origin = $addr;
	    printf "                        *%04o\n", $origin;
	}
	$origin = $addr;

	printf "%04o\t%04o\t%s", 
	    $core->{ $addr }{ addr },
	    $core->{ $addr }{ code },
	    $core->{ $addr }->display();


	print "\n";
    }
}

sub disassemble {
    my $core = shift;

    foreach my $addr ( 0 .. 077777 ) {
	next unless $core->{ $addr };
	$core->{ $addr }->disassemble();
    }
}

sub crossref {
    my $core = shift;

    foreach my $addr ( 0 .. 077777 ) {
	next unless defined $core->{ $addr };
	next unless $core->{ $addr }{ ref };
	my $ref = $core->{ $addr }{ ref };
	my $dest = $core->{ $addr }{ dest };
	$core->{ $dest } = new PDP8::Instruction( $dest, 0 ) unless $core->{ $dest };
	$core->{ $dest }{ label } =  $ref;
   }
}

1;

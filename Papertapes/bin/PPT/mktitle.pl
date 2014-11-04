#!/usr/bin/perl -w

use strict;
use Data::Dumper;

$Data::Dumper::Purity=1;

my %table = ();

sub bin {
	my $s = shift;
	$s =~ s/\./0/g;
	$s =~ s/o/1/g;
	return oct( "0b$s" );
}


my $c = 0;
while ( <DATA> ) {

	chomp;
	next if /^\s*$/;

	if ( /(\d{3}) ([\.o]{5})/ ) {
		$c = oct($1);
		$table{ $c } = [ bin($2) ];
		next;
	}
	if ( /    ([\.o]{5})/ ) {
		push @{ $table{ $c } }, bin($1);
		next;
	} 
	if ( /(\d{3}) ->(\d{3})/ ) {
		$c = oct($1);
		$table{ $c } = [ @{$table{ oct($2) }} ];
		next;
	}

}

sub transpose {
	my @in = @_;
	@in = @{$_[0]} if ref $_[0];

	#   43210
	# 4 .ooo.
	# 3 o...o
	# 2 ooooo
	# 1 o...o
	# 0 o...o

	my @out = ( 0,0,0,0,0 );

	foreach my $x ( 0 .. 4 ) {
		foreach my $y ( 0 .. 4 ) {
			$out[ $x ] |= ( 1 << $y ) if $in[ $y ] & ( 1 << $x);
		}
	}
	return @out if wantarray;
	return [ @out ];
}

foreach ( keys %table ) {
	$table{ $_ } = transpose( $table{ $_ } );
}

print "%font = (\n";
foreach ( sort { $a <=> $b } keys %table ) {
	printf "    %04o => [ %s ],\n", 
		$_, 
		join ", ", map { sprintf "%04o", $_ } @{$table{ $_ }}
}
print ");\n";



__DATA__

040 .....
    ..... 
    .....
    .....
    .....

041 ..o..
    ..o..
    ..o..
    .....
    ..o..

042 .o.o.
    .o.o.
    .....
    .....
    .....

043 .o.o.
    ooooo
    .o.o.
    ooooo
    .o.o.

044 .oooo
    o.o..
    .ooo.
    ..o.o
    oooo.

045 oo..o
    oo.o.
    ..o..
    .o.oo
    o..oo

046 ..o..
    .o.o.
    .oo..
    o..oo
    .oooo

047 ..o..
    ..o..
    .....
    .....
    .....

050 ..o..
    .o...
    .o...
    .o...
    ..o..

051 ..o..
    ...o.
    ...o.
    ...o.
    ..o..

052 o...o
    .o.o.
    ooooo
    .o.o.
    o...o

053 ..o..
    ..o..
    ooooo
    ..o..
    ..o..

054 .....
    .....
    .....
    ..o..
    .oo..

055 .....
    .....
    ooooo
    .....
    .....

056 .....
    .....
    .....
    .oo..
    .oo..

057 ....o
    ...o.
    ..o..
    .o...
    o....

060 .ooo.
    oo..o
    o.o.o
    o..oo
    .ooo.

061 ..o..
    .oo..
    ..o..
    ..o..
    .ooo.

062 .ooo.
    o...o
    ...o.
    ..o..
    ooooo

063 oooo.
    ....o
    ..oo.
    ....o
    oooo.

064 ...o.
    ..oo.
    .o.o.
    ooooo
    ...o.

065 ooooo
    o....
    oooo.
    ....o
    oooo.

066 .ooo.
    o....
    oooo.
    o...o
    .ooo.

067 ooooo
    ....o
    ...o.
    ..o..
    .o...

070 .ooo.
    o...o
    .ooo.
    o...o
    .ooo.

071 .ooo.
    o...o
    .oooo
    ....o
    .ooo.

072 .oo..
    .oo..
    .....
    .oo..
    .oo..

073 .oo..
    .oo..
    .....
    ..o..
    .oo..

074 ...o.
    ..o..
    .o...
    ..o..
    ...o.

075 .....
    ooooo
    .....
    ooooo
    .....

076 .o...
    ..o..
    ...o.
    ..o..
    .o...

077 .ooo.
    o...o
    ...o.
    .....
    ..o..

100 .ooo.
    o...o
    o.oo.
    o....
    .ooo.

101 .ooo.
    o...o
    ooooo
    o...o
    o...o

102 oooo.
    o...o
    oooo.
    o...o
    oooo.

103 .oooo
    o....
    o....
    o....
    .oooo

104 oooo.
    o...o
    o...o
    o...o
    oooo.

105 ooooo
    o....
    oooo.
    o....
    ooooo

106 ooooo
    o....
    oooo.
    o....
    o....

107 .oooo
    o....
    o..oo
    o...o
    .oooo

110 o...o
    o...o
    ooooo
    o...o
    o...o

111 .ooo.
    ..o..
    ..o..
    ..o..
    .ooo.

112 ...oo
    ....o
    ....o
    o...o
    .ooo.

113 o...o
    o..o.
    ooo..
    o..o.
    o...o

114 o....
    o....
    o....
    o....
    ooooo

115 o...o
    oo.oo
    o.o.o
    o...o
    o...o

116 o...o
    oo..o
    o.o.o
    o..oo
    o...o

117 .ooo.
    o...o
    o...o
    o...o
    .ooo.

120 oooo.
    o...o
    oooo.
    o....
    o....

121 .ooo.
    o...o
    o...o
    o..oo
    .oooo

122 oooo.
    o...o
    oooo.
    o..o.
    o...o

123 .ooo.
    o....
    .ooo.
    ....o
    oooo.

124 ooooo
    ..o..
    ..o..
    ..o..
    ..o..

125 o...o
    o...o
    o...o
    o...o
    .ooo.

126 o...o
    o...o
    o...o
    .o.o.
    ..o..

127 o...o
    o...o
    o...o
    o.o.o
    .o.o.

130 o...o
    .o.o.
    ..o..
    .o.o.
    o...o

131 o...o
    .o.o.
    ..o..
    ..o..
    ..o..

132 ooooo
    ...o.
    ..o..
    .o...
    ooooo

133 .ooo.
    .o...
    .o...
    .o...
    .ooo.

134 o....
    .o...
    ..o..
    ...o.
    ....o

135 .ooo.
    ...o.
    ...o.
    ...o.
    .ooo.

136 ..o..
    .o.o.
    o...o
    .....
    .....

137 .....
    .....
    .....
    .....
    ooooo

140 .o...
    ..o..
    .....
    .....
    .....

141 ->101
142 ->102
143 ->103
144 ->104
145 ->105
146 ->106
147 ->107
150 ->110
151 ->111
152 ->112
153 ->113
154 ->114
155 ->115
156 ->116
157 ->117
160 ->120
161 ->121
162 ->122
163 ->123
164 ->124
165 ->125
166 ->126
167 ->127
170 ->130
171 ->131
172 ->132

173 ..oo.
    ..o..
    .oo..
    ..o..
    ..oo.

174 ..o..
    ..o..
    ..o..
    ..o..
    ..o..

175 .oo..
    ..o..
    ..oo.
    ..o..
    .oo..

176 .....
    .o...
    o.o.o
    ...o.
    .....

177 ..o..
    .o.o.
    o...o
    o...o
    ooooo



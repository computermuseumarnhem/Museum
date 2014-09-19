package VT55;

package VT55::Escape;

sub cursor_down		{ return "\eB"; }
sub reverse_line_feed	{ return "\eI"; }
sub cursor_up		{ return "\eA"; }
sub cursor_right	{ return "\eC"; }
sub cursor_home		{ return "\eH"; }
sub cursor_address	{ 
    my ( $x, $y ) = @_;
    return "\eY" . chr( $y + 040 ), chr( $x + 040 ); } 
}
sub erase_line		{ return "\eK"; }
sub erase_screen    	{ return "\eJ"; }
sub identify		{ return "\eZ"; }
sub id_vt55		{ return "\e/E"; }
sub hold_screen		{ return "\e["; }
sub release_screen	{ return "\e\\"; }
sub alt_keypad		{ return "\e="; }
sub normal_keypad	{ return "\e>"; }




package VT55::Graph;

sub width() { return 0354; }
sub height() { return 01000; }

sub encode  {
    my $v = shift;
    return chr( ( $v & 037 ) + 040 ) . chr( ( ( &v >> 5 ) & 037 ) + 040 );
}

sub enter   { return "\e1"; }
sub exit    { return "\e2"; }


sub nop	    { return "@"; }
sub load    { return "B"; }
sub control { return "A"; }
sub marker  { return "D"; }
sub setupx  { return 'H"; }
	

1;

# vim: set sw=4 sts=4 si:

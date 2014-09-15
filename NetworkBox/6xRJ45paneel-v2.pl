#!/usr/bin/perl -w

use strict;

sub box { my ( $w, $h ) = @_; return ( -$w/2, -$h/2, $w, $h ) };
sub screw { my ( $x, $y ) = @_; return ( $x - 1.5, $y - 1.5, 3, 3 ) };

printf "panel      : X=%6.2f Y=%6.2f W=%6.2f H=%6.2f\n", box( 126, 73 );  
printf "screws     : X=%6.2f Y=%6.2f W=%6.2f H=%6.2f\n", screw( -100/2, -31/2);
printf "screws     : X=%6.2f Y=%6.2f W=%6.2f H=%6.2f\n", screw( 100/2, -31/2);
printf "screws     : X=%6.2f Y=%6.2f W=%6.2f H=%6.2f\n", screw( -100/2, 31/2);
printf "screws     : X=%6.2f Y=%6.2f W=%6.2f H=%6.2f\n", screw( 100/2, 31/2);
printf "connectors : X=%6.2f Y=%6.2f W=%6.2f H=%6.2f\n", box( 92, 19 );

__END__


$fn = 90;

module screw( v ) {
	translate ( [ -v[0]/2, -v[1]/2, -v[2]/2 ] ) {

		translate( [   0,    0,  0 ] ) cylinder( r = 1.5, h = 10 );
		translate( [ v[0],	  0,  0 ] ) cylinder( r = 1.5, h = 10 );
		translate( [   0,  v[1], 0 ] ) cylinder( r = 1.5, h = 10 );
		translate( [ v[0], v[1], 0 ] ) cylinder( r = 1.5, h = 10 );

	}
}

module conn( v ) {
	translate ( [ -v[0]/2, -v[1]/2, -v[2]/2 ] ) {
		cube( v );
	}
}

module panel( v ) {
	translate ( [ -v[0]/2, -v[1]/2, -v[2]/2 ] ) {
		cube( v );
	}
}
module model() {

	difference() {
		conn( [ 126, 73, 2 ] );

		screw( [ 100, 31, 10 ] );
		panel( [ 92, 19, 10 ] );

	}
}

projection( cut = true )
	model();

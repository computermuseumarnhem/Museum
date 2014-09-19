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

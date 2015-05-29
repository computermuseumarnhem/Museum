#!/usr/bin/perl -w

use Config::Tiny;
use JSON::PP;
use Data::Printer;

sub json_read {
	my $name = shift;

	return {} unless -e $name;

	open F, '<', $name or die "Can't open $name: $!";
	my $json = JSON::PP->new->utf8->decode( join '', <F> );
	close F;

	return $json;
}

sub json_write {
	my $name = shift;
	my $json = shift;

	open F, '>', $name or die "Can't write to $name: $!";
	print F JSON::PP->new->utf8->canonical->pretty->encode( $json );
	close F;
}

my $ini = Config::Tiny->read( "ppt.ini" ) or
	die Config::Tiny::errstr();

my $json = json_read( 'ppt.json' );

print STDERR "before: ppt.ini:\n"; p $ini;

print STDERR "\nbefore: ppt.json:\n"; p $json;

# >>>>>>>>>>>>>>>>>>>>>

if ( defined $ini->{ content }{ begin } ) {
	$json->{ content }{ begin } = $ini->{ content }{ begin };
	delete $ini->{ content }{ begin };
}

if ( $ini->{ content }{ end } ) {
	$json->{ content }{ end } = $ini->{ content }{ end };
	delete $ini->{ content }{ end };
}

if ( $ini->{ content }{ raw } ) {
	$json->{ content }{ filename } = $ini->{ content }{ raw };
	delete $ini->{ content }{ raw };
}
if ( $ini->{ content }{ filename } ) {
	$json->{ content }{ filename } = $ini->{ content }{ filename };
	delete $ini->{ content }{ filename };
}

foreach ( 0 .. 2 ) {
	if ( $ini->{ label }{ "desc.$_" } ) {
		$json->{ description }[ $_ ] = $ini->{ label }{ "desc.$_" };
		delete $ini->{ label }{ "desc.$_" };
	}
}

if ( $ini->{ label }{ id } ) {
	$json->{ label } = $ini->{ label }{ id };
	delete $ini->{ label }{ id };
}

foreach ( 0 .. 4 ) {
	next unless defined $ini->{ "part.$_" };
	if ( defined $ini->{ "part.$_" }{ begin } ) {
		$json->{ content }{ part }[ $_ ]{ begin } = $ini->{ "part.$_" }{ begin };
		delete $ini->{ "part.$_" }{ begin };
	}
	if ( $ini->{ "part.$_" }{ end } ) {
		$json->{ content }{ part }[ $_ ]{ end } = $ini->{ "part.$_" }{ end };
		delete $ini->{ "part.$_" }{ end };
	}
	if ( $ini->{ "part.$_" }{ type } ) {
		$json->{ content }{ part }[ $_ ]{ type } = $ini->{ "part.$_" }{ type };
		delete $ini->{ "part.$_" }{ type };
	}
}

if ( $ini->{ source }{ email } ) {
	$json->{ source }{ email } = $ini->{ source }{ email };
	delete $ini->{ source }{ email };
}
if ( $ini->{ source }{ name } ) {
	$json->{ source }{ name } = $ini->{ source }{ name };
	delete $ini->{ source }{ name };
}
if ( $ini->{ source }{ url } ) {
	$json->{ source }{ url } = $ini->{ source }{ url };
	delete $ini->{ source }{ url };
}

if ( $ini->{ label }{ date } ) {
	$json->{ date } = $ini->{ label }{ date };
	delete $ini->{ label }{ date };
}
if ( $ini->{ label }{ copyright } ) {
	$json->{ copyright }{ year } = $ini->{ label }{ copyright };
	delete $ini->{ label }{ copyright };
}
if ( $ini->{ label }{ 'copyright.long' } ) {
	$json->{ copyright }{ format }{ long } = $ini->{ label }{ 'copyright.long' };
	delete $ini->{ label }{ 'copyright.long' };
}
if ( $ini->{ label }{ 'copyright.short' } ) {
	$json->{ copyright }{ format }{ short } = $ini->{ label }{ 'copyright.short' };
	delete $ini->{ label }{ 'copyright.short' };
}

if ( $ini->{ location }{ slot } ) {
	$json->{ location }{ slot } = $ini->{ location }{ slot };
	delete $ini->{ location }{ slot };
}
if ( $ini->{ location }{ tray } ) {
	$json->{ location }{ tray } = $ini->{ location }{ tray };
	delete $ini->{ location }{ tray };
}

if ( $ini->{ source }{ media } ) {
	$json->{ media } = $ini->{ source }{ media };
	delete $ini->{ source }{ media };
}
if ( $ini->{ source }{ donated } ) {
	$json->{ origin } = $ini->{ source }{ donated };
	delete $ini->{ source }{ donated }
}
if ( $ini->{ label }{ code } ) {
	$json->{ labelcode } = $ini->{ label }{ code };
	delete $ini->{ label }{ code };
}


# <<<<<<<<<<<<<<<<<<<<<

print STDERR "\nafter: ppt.ini:\n"; p $ini;

print STDERR "\nafter: ppt.json:\n"; p $json;

json_write( 'ppt.json', $json );

foreach ( keys %$ini ) {
	delete $ini->{ $_ } unless %{ $ini->{ $_ } };
}

$ini->write( 'ppt.ini' );

unlink 'ppt.ini' unless %$ini;



package PPT;

use strict;

sub open {
    my $class = shift;
    my ( $path ) = @_;

    my $self = bless {}, $class;
    $self->{ path } = $path;

# json in subdir
    if ( -e "$path/ppt.json" ) {
	open my $fh, '<', "$path/ppt.json" or croak "Can't open $path/ppt.json: $!";
	my $json = PP::JSON->new->ascii->decode( <$fh> );
	$self->{ label } = $json->{ label };
	$self->{ location } = $json->{ location };
	$self->{ content } = $json->{ content };
	$self->{ content }{ data } = $self->{ content }{ raw };
	if ( $
	delete $self->{ content }{ raw };
	return $self;
    }

# inifile
    if ( -e "$path/ppt.ini" ) {

	return $self;
    }

}

sub close {


}
    


1;
# vim: set sw=4 sts=4 si:

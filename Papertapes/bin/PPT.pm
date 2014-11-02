package PPT;

# vim: set sw=4 sts=4 si:

my $version = 1;

use Carp; 
use Config::Tiny;

use PPT::Label;
use PPT::Location;

sub open {
    my $class = shift;
    my $self  = bless {}, $class;

    my ( $path ) = @_;

    $self->path( $path );

    return undef unless -e $self->inifile();

    $self->{ ppt } = Config::Tiny->read( $self->inifile() ) or
	croak Config::Tiny::errstr();

    return $self;
}

sub close {
    my $self = shift;

    $self->{ ppt }->write( $self->inifile() );

}

sub path {
    my $self = shift;
    my ( $path ) = @_;

    $self->{ path } = $path if $path;
    return $self->{ path };
}

sub label {
    my $self = shift;

    $self->{ ppt }{ label } = {} unless $self->{ ppt }{ label };
    return PPT::Label->new( $self->{ ppt }{ label } );
}

sub location {
    my $self = shift;

    $self->{ ppt }{ location } = {} unless $self->{ ppt }{ location };
    return PPT::Location->new( $self->{ ppt }{ location } );
}

sub content {
    my $self = shift;

    open FH, "<", $self->content_filename()
	or die sprintf "Can't open %s: %s", $self->content_filename(), "$!";
    binmode FH;
    local $/ = undef;
    $self->{ data } = <FH>;
    close FH;
    
}

sub content_filename {
    my $self = shift;

    my $filename = $self->{ ppt }{ content }{ filename };
    
    return undef unless $filename;
    return sprintf "%s/%s", 
	$self->{ path },
	$self->{ ppt }{ content }{ filename };
}

sub inifile {
    my $self = shift;
    
    return sprintf "%s/ppt.ini", $self->{ path };
}

1;

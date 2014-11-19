package PPT::Part;

# vim: set sw=4 sts=4 si:

sub new {
    my $class = shift;
    my $part  = shift;

    my $self = bless {}, $class;

    $self->{ 'part' } = $part || {};

    $self->upgrade();

    return $self;
}

sub part {
    my $class = shift;
    my $part = shift or return undef;
    return $class->new( $part );
}

sub upgrade {
    my $self = shift;
}

sub begin {
    my $self = shift;
    my ( $begin ) = @_;
    $self->{ part }{ begin } = $begin if defined $begin;
    return $self->{ part }{ begin };
}

sub end {
    my $self = shift;
    my ( $end ) = @_;
    $self->{ part }{ end } = $end if defined $end;
    return $self->{ part }{ end };
}

sub type {
    my $self = shift;
    my ( $type ) = @_;
    $self->{ part }{ type } = $type if defined $type;
    return $self->{ part }{ type }
}

1;

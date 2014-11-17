package PPT::Part;

# vim: set sw=4 sts=4 si:

package PPT::Parts;

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    return $self;
}

sub add {
    my $self = shift;
    my $part = shift;

    push @$self, PPT::Part->new( $part );   
}

sub remove {
    my $self = shift;
    my $num  = shift;

    delete $self->[ $num ];
}

sub count {
    my $self = shift;
    return scalar @$self;
}

sub sort {
    return $self->{ part }
}


package PPT::Part;

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
    $self->{ part }{ begin } = $begin if $begin;
    return $self->{ part }{ begin };
}

sub end {
    my $self = shift;
    my ( $end ) = @_;
    $self->{ part }{ end } = $end if $end;
    return $self->{ part }{ end };
}

sub type {
    my $self = shift;
    my ( $type ) = @_;
    $self->{ part }{ type } = $type if $type;
    return $self->{ part }{ type }
}

1;

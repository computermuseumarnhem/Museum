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

1;

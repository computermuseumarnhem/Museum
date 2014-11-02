package PPT::Data;

# vim: set sw=4 sts=4 si:

sub new {
    my $class = shift;
    my $self = bless {}, $class;

    $self->{ 'data' } = shift;

    $self->upgrade();

    return $self;
}

sub upgrade {
    my $self = shift;
}

1;

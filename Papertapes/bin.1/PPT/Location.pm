package PPT::Location;

# vim: set sw=4 sts=4 si:

sub new {
    my $class = shift;
    my $self = bless {}, $class;

    $self->{ 'location' } = shift;

    $self->upgrade();

    return $self;
}

sub upgrade {
    my $self = shift;
    my $l = $self->{ location };

    # location box becomes tray
    $l->{ 'tray' } = $l->{ 'box' } unless $l->{ 'tray' };
    delete $l->{ 'box' };

    # remove empty tags;
    foreach ( keys %$l ) {
	delete $l->{ $_ } unless $l->{ $_ };
    }

}

sub output {
    my $self = shift;

    my $o = "";

    $o .= sprintf "Tray: %s\n", $self->tray();
    $o .= sprintf "Slot: %s\n", $self->slot();

    return $o;
}

sub tray {
    my $self = shift;
    my $l = $self->{ location };

    return $l->{ tray } || '';

}

sub slot {
    my $self = shift;
    my $l = $self->{ location };

    return $l->{ slot } || '';
}

1;

package PPT::Label;

# vim: set sw=4 sts=4 si:

sub new {
    my $class = shift;
    my $self = bless {}, $class;

    $self->{ 'label' } = shift;

    $self->upgrade();

    return $self;
}

sub upgrade {
    my $self = shift;
    my $l = $self->{ label };

    # label id was 'label'. now 'id'
    $l->{ 'id' } = $l->{ 'label' } unless $l->{ 'id' };
    delete $l->{ 'label' };

    # change copyright stuff, in combination with label format
    if ( $l->{ format } and $l->{ 'format' } eq 'vg' ) {
	$l->{ 'copyright.long' } = "(C) %s VG DATA SYSTEMS LTD";
	$l->{ 'copyright.short' } = "(C) %s VG DATA";
	$l->{ 'copyright' } = $l->{ date };
	delete $l->{ 'year' };
	delete $l->{ 'date' };
	delete $l->{ 'format' };
    }
    if ( $l->{ format } and $l->{ 'format' } eq 'old' ) {
	$l->{ 'copyright.long' } = "COPYRIGHT (C) %s DIGITAL EQUIPMENT CORPORATION";
	$l->{ 'copyright.short' } = "(C) %s DIGITAL EQUIP. CORP.";
	$l->{ 'copyright' } = $l->{ 'year' };
	delete $l->{ 'year' };
	delete $l->{ 'format' };
    }
    if ( $l->{ format } and $l->{ 'format' } eq 'new' ) {
	$l->{ 'copyright.long' } = "COPYRIGHT (C) DIGITAL EQUIPMENT CORPORATION %s";
	$l->{ 'copyright.short' } = "(C) DIGITAL EQUIP. CORP. %s";
	$l->{ 'copyright' } = $l->{ 'year' };
	delete $l->{ 'year' };
	delete $l->{ 'format' };
    }

    # retag descriptions and fix whitespaces
    $l->{ 'desc.0' } = $l->{ 'desc' } unless $l->{ 'desc.0' }; 
    $l->{ 'desc.1' } = $l->{ 'desc1' } unless $l->{ 'desc.1' };
    $l->{ 'desc.2' } = $l->{ 'desc2' } unless $l->{ 'desc.2' };
    delete $l->{ 'desc' };
    delete $l->{ 'desc1' };
    delete $l->{ 'desc2' };
    $l->{ 'desc.0' } =~ s/\s+/ /g if $l->{ 'desc.0' };
    $l->{ 'desc.1' } =~ s/\s+/ /g if $l->{ 'desc.1' };
    $l->{ 'desc.2' } =~ s/\s+/ /g if $l->{ 'desc.2' };

    # remove empty tags;
    foreach ( keys %$l ) {
	delete $l->{ $_ } unless $l->{ $_ };
    }

}

sub output {
    my $self = shift;

    my $o = "";

    $o .= sprintf "%-22.22s  %-8.8s  %2.2s\n", 
	$self->id(), $self->date(), $self->code();
    foreach ( 0 .. 3 ) {
	$o .= sprintf "%-36.36s\n", $self->desc( $_ );
    }
    $o .= sprintf "%-36.36s\n", $self->copyright();

    return $o;
}

sub id {
    my $self = shift;
    my $l = $self->{ label };

    return $l->{ id };

}

sub date {
    my $self = shift;
    my $l = $self->{ label };

    return $l->{ date } || '';
}

sub code {
    my $self = shift;
    my $l = $self->{ label };

    return $l->{ code } || '';
}

sub desc {
    my $self = shift;
    my ( $num ) = @_;
    my $l = $self->{ label };

    $num ||= 0;

    return $l->{ "desc.$num" } || '';
}

sub copyright {
    my $self = shift;
    my $l = $self->{ label };
    my ( $format ) = @_;

    $format ||= 'short';

    if ( $l->{ "copyright.$format" } ) {
	return sprintf $l->{ "copyright.$format" }, $l->{ copyright } || '';
    }
    return $l->{ copyright } || '';;
}

1;

package Osadmin::Benchmark;

use 5.010001;
#use 5.018002;
use strict;
use warnings;
use IO::File;
use POSIX;
use Data::Dumper;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';

sub new {
    my ($this) = @_;

    my $class = ref($this) || $this;
    my $self = {
        'mem_fld'   => [qw| vsz rss sha txt lib dat drt |],
        'form_n'    => "%10d\t%10d\t%10d\t%10d\t%10d\t%10d\t%10d\n",
        'page_size' => POSIX::sysconf(POSIX::_SC_PAGESIZE),
    };
    bless $self, $class;

    $self->{'form_s'} = $self->{'form_n'};
    $self->{'form_s'} =~ tr/d/s/;

    $self->mem_clean();

    return $self;
}

sub mem_clean {
    my ($self) = @_;

    $self->{'mds'} = undef;
    $self->{'mdf'} = undef;
    $self->{'mem_dif'} = undef;

    return 1;
}

sub mem_usage {
    my ($self) = @_;

    my $fp = "/proc/$$/statm";

    my $fh = IO::File->new($fp, 'r');

    return
        unless defined $fh;

    my $l = <$fh>;
    chomp $l;
    $fh->close;

    my @s = map { int $_} split ' ', $l;
    my $tr = {};
    for (my $i=0; $i<@s; $i++) {
        $tr->{ $self->{'mem_fld'}->[$i] } = $s[$i];
    }
    return $tr;
}

sub mds_clean {
    my ($self) = @_;
    $self->mem_clean;
    $self->mds;
    return 1;
}

sub mds {
    my ($self) = @_;
    $self->{'mds'} = $self->mem_usage();
    return 1;
}

sub mdf {
    my ($self) = @_;
    $self->{'mdf'} = $self->mem_usage();
    return 1;
}

sub mem_dif {
    my ($self) = @_;

    return 0
        unless defined $self->{'mds'};

    $self->mdf()
        unless defined $self->{'mdf'};

    my $mds = $self->{'mds'};
    my $mdf = $self->{'mdf'};

    my $tr = {};

    foreach my $col (@{$self->{'mem_fld'}}) {
        $tr->{$col} = $mdf->{$col} - $mds->{$col};
    }
    $self->{'mem_dif'} = $tr;
    return 1;
}

sub mem_dif_print {
    my ($self, $title) = @_;

    return 0
        unless $self->mem_dif();

    $self->mem_usage_print( $title, $self->{'mem_dif'} );
    return 1;
}

sub mem_usage_print {
    my ($self, $title, $mu) = @_;

    print "$title\n"
        if defined $title;

    $mu = $self->mem_usage()
        unless defined $mu;


    printf $self->{'form_s'}, @{$self->{'mem_fld'}};
    printf $self->{'form_n'}, map {int ($self->{'page_size'} * $_ / 1024) } @$mu{ @{$self->{'mem_fld'}} };
    return 1;
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Osadmin::Benchmark - Custom Benchmark module

=head1 SYNOPSIS

  use Osadmin::Benchmark;
  blah blah blah

=head1 DESCRIPTION

Custom Benchmark module

=head2 EXPORT

None by default.

=head1 AUTHOR

Magyarevity Miroszlav, E<lt>perl@osadmin.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014 by Magyarevity Miroszlav

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

Except for the typemap code perlobject.map, which is copyright 1996 Dean Roehrich

I'm not sure about the license terms on perlobject.map, you'll have to see about
that yourself

=cut

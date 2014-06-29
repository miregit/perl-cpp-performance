package Osadmin_PP;

use 5.010001;
#use 5.018002;
use strict;
use warnings;
use IO::File;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Osadmin_PP ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';

# Preloaded methods go here.

sub new {
    my ($this, $dict_fp) = @_;

    my $class = ref($this) || $this;
    my $self = {
        'dict_fp' => $dict_fp,
    };
    bless $self, $class;

    $self->{'w'} = {};

    return $self;
}

sub dict_load_words {
    my ($self) = @_;

    my $fh = IO::File->new($self->{'dict_fp'}, 'r');

    if (defined $fh) {
        
        my $w = $self->{'w'};

        while (<$fh>) {
            chomp;
            $w->{$_} = {
                'vowels'  => 0,
                'palindrome' => 0,
            };
        }
        $fh->close;

    } else {
        die "ERROR: problem loading $self->{'dict_fp'}\n";
    }
    return 1;    
}

# transliteration should be fast

sub vowel_calc {
    my ($self) = @_;

    my $w = $self->{'w'};

    foreach my $word (keys %$w) {
        $w->{$word}->{'vowels'} = $word =~ tr/aeiouAEIOU//;
    }
    return 1;
}

sub word_get_hr {
    my ($self, $w) = @_;

    return exists($self->{'w'}->{$w})?$self->{'w'}->{$w}:{};
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Osadmin_PP - pure perl module

=head1 SYNOPSIS

  use Osadmin_PP;
  blah blah blah

=head1 DESCRIPTION

Performance testing - perl vs. c++

requires a c++ compiler, g++ works fine

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

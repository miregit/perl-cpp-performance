package Osadmin_XS;

use 5.010001;
#use 5.018002;
use strict;
use warnings;
use Osadmin;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Osadmin_XS ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';

#require XSLoader;
#XSLoader::load('Osadmin', $VERSION);

# Preloaded methods go here.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Osadmin_XS - uses C++ code via xs

=head1 SYNOPSIS

  use Osadmin_XS;
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

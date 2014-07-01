# Before 'make install' is performed this script should be runnable with
# 'make test'. After 'make install' it should work as 'perl Osadmin.t'

#########################

use strict;
use warnings;

use Test::More tests => 1;

BEGIN { 
    use_ok('Osadmin') 
};

__END__

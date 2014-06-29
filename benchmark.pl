#!/usr/bin/perl -w
use strict;
use warnings;

use blib;

use Benchmark;
use Osadmin_XS;
use Osadmin_PP;
use Osadmin::Benchmark;

use Data::Dumper;

my $dict_fp = '/usr/share/dict/words';

my $xs = Osadmin_XS->new($dict_fp);
my $pp = Osadmin_PP->new($dict_fp);

my $ob = Osadmin::Benchmark->new();
$ob->mem_usage_print('memory usage start');


=pod
on my box, perl takes 35 MB RSS to load words, c++ requires 10MB RSS
=cut
 
$ob->mds_clean;
$pp->dict_load_words();
$ob->mem_dif_print('mem dif after pp load');

$ob->mds_clean;
$xs->dict_load_words();
$ob->mem_dif_print('mem dif after xs load');

# lets time them
# my box says c++ is twice as fast as perl loading data from file

$ob->mds_clean;
timethese (
    -10, 
    {
        'c++' => sub { my $xs = Osadmin_XS->new($dict_fp); $xs->dict_load_words(); },
        'pp'  => sub { my $pp = Osadmin_PP->new($dict_fp); $pp->dict_load_words(); },
    }
);
$ob->mem_dif_print('mem dif after 10 second load words test');

exit;



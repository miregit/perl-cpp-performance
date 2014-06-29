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
$ob->mem_usage_print('memory usage');

$ob->mds;
$xs->dict_load_words();
$ob->mem_dif_print('mem dif after xs load');

exit;
undef $xs;

$pp->dict_load_words();
sleep 10;
undef $pp;

#print Dumper $pp;


exit;



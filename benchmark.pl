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


my $do_other = 1;

# on my box, perl takes 35 MB RSS to load words, c++ requires 10MB RSS
 
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
        'c++ load words' => sub { my $xs = Osadmin_XS->new($dict_fp); $xs->dict_load_words(); },
        'pp  load words'  => sub { my $pp = Osadmin_PP->new($dict_fp); $pp->dict_load_words(); },
    }
)
    if $do_other;

$ob->mem_dif_print('mem dif after 10 second load words test');

# on my box, c++ is 14 times faster than perl at vowel calc
$ob->mds_clean;
timethese (
    -10, 
    {
        'pp  vowels' => sub { $pp->vowel_calc(); },
        'c++ vowels' => sub { $xs->vowel_calc(); },
    }
);
$ob->mem_dif_print('mem dif after 10 second vowels test');

#$pp->vowel_calc();
#$xs->vowel_calc();

#print Dumper $pp->{'w'}->{'faith'};

exit;

__END__

my results:

memory usage start
       vsz	       rss	       sha	       txt	       lib	       dat	       drt
     59984	      7240	      2620	         8	         0	      4880	         0
mem dif after pp load
       vsz	       rss	       sha	       txt	       lib	       dat	       drt
     35196	     35060	        32	         0	         0	     35196	         0
mem dif after xs load
       vsz	       rss	       sha	       txt	       lib	       dat	       drt
     10824	     10824	        60	         0	         0	     10824	         0
Benchmark: running c++ load words, pp  load words for at least 10 CPU seconds...
c++ load words: 10 wallclock secs ( 9.99 usr +  0.12 sys = 10.11 CPU) @  5.54/s (n=56)
pp  load words: 11 wallclock secs (10.21 usr +  0.12 sys = 10.33 CPU) @  2.13/s (n=22)
mem dif after 10 second load words test
       vsz	       rss	       sha	       txt	       lib	       dat	       drt
     28932	     28408	        44	         0	         0	     28932	         0
Benchmark: running c++ vowels, pp  vowels for at least 10 CPU seconds...
c++ vowels: 11 wallclock secs (10.50 usr +  0.08 sys = 10.58 CPU) @ 67.30/s (n=712)
pp  vowels: 11 wallclock secs (10.23 usr +  0.09 sys = 10.32 CPU) @  4.84/s (n=50)
mem dif after 10 second vowels test
       vsz	       rss	       sha	       txt	       lib	       dat	       drt
      2304	      2904	         0	         0	         0	      2304	         0


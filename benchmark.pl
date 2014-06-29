#!/usr/bin/perl -w
use strict;
use warnings;

use blib;

use Benchmark ':hireswallclock';
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
        'pp  load words' => sub { my $pp = Osadmin_PP->new($dict_fp); $pp->dict_load_words(); },
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
) if $do_other;
$ob->mem_dif_print('mem dif after 10 second vowels test');

#print Dumper $pp->word_get_hr('faith');
#print Dumper $xs->word_get_hr('marathon');

# c++ is almost 2 times slower since it has to create perl hash ref each time
# perl just returns a reference ;)

$ob->mds_clean;
timethese (
    -10,
    {
        'c++ word hash ref' => sub { $xs->word_get_hr('marathon'); },
        'pp  word hash ref' => sub { $pp->word_get_hr('marathon'); },
    }
);
$ob->mem_dif_print('mem dif after 10 second word get hr, c++ had to create perl hashref each time');

exit;

__END__

my results:
memory usage start
       vsz	       rss	       sha	       txt	       lib	       dat	       drt
     59976	      7244	      2620	         8	         0	      4868	         0
mem dif after pp load
       vsz	       rss	       sha	       txt	       lib	       dat	       drt
     35200	     35072	        32	         0	         0	     35200	         0
mem dif after xs load
       vsz	       rss	       sha	       txt	       lib	       dat	       drt
     10824	     10824	        60	         0	         0	     10824	         0
Benchmark: running c++ load words, pp  load words for at least 10 CPU seconds...
c++ load words: 10.4201 wallclock secs ( 9.92 usr +  0.13 sys = 10.05 CPU) @  5.57/s (n=56)
pp  load words: 10.5832 wallclock secs (10.30 usr +  0.10 sys = 10.40 CPU) @  2.12/s (n=22)
mem dif after 10 second load words test
       vsz	       rss	       sha	       txt	       lib	       dat	       drt
     28944	     28412	        44	         0	         0	     28944	         0
Benchmark: running c++ vowels, pp  vowels for at least 10 CPU seconds...
c++ vowels: 10.6663 wallclock secs (10.49 usr +  0.06 sys = 10.55 CPU) @ 65.97/s (n=696)
pp  vowels: 10.6793 wallclock secs (10.50 usr +  0.08 sys = 10.58 CPU) @  4.73/s (n=50)
mem dif after 10 second vowels test
       vsz	       rss	       sha	       txt	       lib	       dat	       drt
      2312	      2904	         0	         0	         0	      2312	         0
Benchmark: running c++ word hash ref, pp  word hash ref for at least 10 CPU seconds...
c++ word hash ref: 10.6853 wallclock secs (10.56 usr +  0.06 sys = 10.62 CPU) @ 484581.36/s (n=5146254)
pp  word hash ref: 10.9967 wallclock secs (10.67 usr +  0.04 sys = 10.71 CPU) @ 727761.25/s (n=7794323)
mem dif after 10 second word get hr, c++ had to create perl hashref each time
       vsz	       rss	       sha	       txt	       lib	       dat	       drt
         0	         0	         0	         0	         0	         0	         0


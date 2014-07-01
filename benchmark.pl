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

# the difference is huge on my box, c++ has 139.3 iterations/sec while perl has 2.72

$ob->mds_clean;
timethese (
    -10,
    {
        'c++ palindrome' => sub { $xs->palindrome_calc(); },
        'pp  palindrome' => sub { $pp->palindrome_calc(); },
    }
);

$ob->mem_dif_print('mem dif after 10 second palindrome test');

$ob->mds_clean;
timethese (
    -10, 
    {
        'pp  vowels' => sub { $pp->vowel_calc(); },
        'c++ vowels' => sub { $xs->vowel_calc(); },
    }
);
$ob->mem_dif_print('mem dif after 10 second vowels test');

print "INFO: dumping perl and c++ structure for the word level\n";

print Dumper $pp->word_get_hr('level');
print Dumper $xs->word_get_hr('level');

# c++ is almost 2 times slower since it has to create perl hash ref each time
# perl just returns a reference ;)

$ob->mds_clean;
timethese (
    -10,
    {
        'c++ word hash ref' => sub { $xs->word_get_hr('marathon'); },
        'pp  word hash ref' => sub { $pp->word_get_hr('marathon'); },
    }
)  if $do_other;
$ob->mem_dif_print('mem dif after 10 second word get hr, c++ had to create perl hashref each time');



exit;

__END__

my results:

memory usage start
       vsz	       rss	       sha	       txt	       lib	       dat	       drt
     59968	      7260	      2612	         8	         0	      4860	         0
mem dif after pp load
       vsz	       rss	       sha	       txt	       lib	       dat	       drt
     35212	     35092	        40	         0	         0	     35212	         0
mem dif after xs load
       vsz	       rss	       sha	       txt	       lib	       dat	       drt
     10824	     10824	        60	         0	         0	     10824	         0
Benchmark: running c++ load words, pp  load words for at least 10 CPU seconds...
c++ load words: 10.9024 wallclock secs ( 9.98 usr +  0.13 sys = 10.11 CPU) @  5.54/s (n=56)
pp  load words: 10.6402 wallclock secs (10.26 usr +  0.10 sys = 10.36 CPU) @  2.12/s (n=22)
mem dif after 10 second load words test
       vsz	       rss	       sha	       txt	       lib	       dat	       drt
     28976	     28404	        44	         0	         0	     28976	         0
Benchmark: running c++ palindrome, pp  palindrome for at least 10 CPU seconds...
c++ palindrome: 10.6553 wallclock secs (10.47 usr +  0.08 sys = 10.55 CPU) @ 141.33/s (n=1491)
pp  palindrome: 10.2845 wallclock secs (10.13 usr +  0.06 sys = 10.19 CPU) @  2.45/s (n=25)
mem dif after 10 second palindrome test
       vsz	       rss	       sha	       txt	       lib	       dat	       drt
      2308	      2904	         0	         0	         0	      2308	         0
Benchmark: running c++ vowels, pp  vowels for at least 10 CPU seconds...
c++ vowels: 10.6253 wallclock secs (10.45 usr +  0.08 sys = 10.53 CPU) @ 67.62/s (n=712)
pp  vowels: 10.4902 wallclock secs (10.33 usr +  0.07 sys = 10.40 CPU) @  4.71/s (n=49)
mem dif after 10 second vowels test
       vsz	       rss	       sha	       txt	       lib	       dat	       drt
         0	         0	         0	         0	         0	         0	         0
INFO: dumping perl and c++ structure for the word level
$VAR1 = {
          'vowels' => 2,
          'palindrome' => 1
        };
$VAR1 = {
          'palindrome' => 1,
          'vowels' => 2
        };
Benchmark: running c++ word hash ref, pp  word hash ref for at least 10 CPU seconds...
c++ word hash ref: 10.5404 wallclock secs (10.45 usr +  0.03 sys = 10.48 CPU) @ 469006.68/s (n=4915190)
pp  word hash ref: 10.8767 wallclock secs (10.84 usr +  0.04 sys = 10.88 CPU) @ 683223.81/s (n=7433475)
mem dif after 10 second word get hr, c++ had to create perl hashref each time
       vsz	       rss	       sha	       txt	       lib	       dat	       drt
         0	         0	         0	         0	         0	         0	         0


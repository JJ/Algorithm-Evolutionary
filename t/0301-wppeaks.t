#-*-cperl-*-
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 3;

use warnings;
use strict;

use lib qw( ../../lib ../lib lib ); #Just in case we are testing it in-place

use Algorithm::Evolutionary::Utils qw(hamming);

use_ok( "Algorithm::Evolutionary::Fitness::wP_Peaks", "using Fitness::wP_Peaks OK" );

my $peaks = 100;
my $bits = 32;
my @weights = (1);
for (1..$bits ) {
  push @weights, 0.99;
}
my $p_peaks = new Algorithm::Evolutionary::Fitness::wP_Peaks( $bits, @weights );
isa_ok( $p_peaks,  "Algorithm::Evolutionary::Fitness::wP_Peaks" );

my $string = $p_peaks->random_string();
ok( $p_peaks->p_peaks( $string ) > 0, "Seems to work" );


#-*-cperl-*-
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 7;

use warnings;
use strict;

use lib qw( ../../lib ../lib lib ); #Just in case we are testing it in-place

use_ok( "Algorithm::Evolutionary::Fitness::P_Peaks", "using Fitness::P_Peaks OK" );

my $peaks = 100;
my $bits = 32;
my $p_peaks = new Algorithm::Evolutionary::Fitness::P_Peaks( $peaks, $bits );
isa_ok( $p_peaks,  "Algorithm::Evolutionary::Fitness::P_Peaks" );

is( Algorithm::Evolutionary::Fitness::P_Peaks::hamming( "111000111", "011100110" ), 3, "Hamming OK" );

my $string = $p_peaks->random_string();
ok( $p_peaks->p_peaks( $string ) > 0, "Seems to work" );

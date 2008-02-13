#-*-Perl-*-
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 7;
use warnings;
use strict;

use lib qw( ../../lib ../lib lib ); #Just in case we are testing it in-place

use_ok( "Algorithm::Evolutionary::Fitness::P_Peaks", "using Fitness::P_Peaks OK" );

my $p_peaks = new Algorithm::Evolutionary::Fitness::P_Peaks( 100, 32 );
isa_ok( $p_peaks,  "Algorithm::Evolutionary::Fitness::P_Peaks" );



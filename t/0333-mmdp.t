#-*-Perl-*-
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 7;
use warnings;
use strict;

use lib qw( ../../lib ../lib lib ); #Just in case we are testing it in-place

use_ok( "Algorithm::Evolutionary::Fitness::MMDP", "using Fitness::MMDP OK" );

my $units = "000000";
for (my $i = 0; $i < 6; $i++ ) {
    my $clone = $units;
    substr($clone, $i, 1 ) = "1";
    is(  Algorithm::Evolutionary::Fitness::MMDP::mmdp( $clone ),
	 $Algorithm::Evolutionary::Fitness::MMDP::unitation[$i+1],
      "Unitation $i OK");
    $units = $clone;
}

#-*-cperl-*-

#Test the MMDP fitness function

use Test::More ;

use warnings;
use strict;

use lib qw( ../../../lib ../../lib ../lib lib ); #Just in case we are testing it in-place

use Algorithm::Evolutionary::Fitness::SkewTrap;
use Algorithm::Evolutionary::Individual::String;
use Math::Random qw(random_normal);

use_ok( "Algorithm::Evolutionary::Fitness::Randomized", "using Fitness::Randomized OK" );

my $units = "00000000";
my $st = new  Algorithm::Evolutionary::Fitness::SkewTrap( length($units)/2 );
my $noisy = new Algorithm::Evolutionary::Fitness::Randomized( $st, { _skewness => { min => -1,
										    range => 2 }
								   });
for (my $i = 0; $i < length($units); $i++ ) {
    my $clone = $units;
    substr($clone, $i, 1 ) = "1";
    my $this_chromosome = Algorithm::Evolutionary::Individual::String->fromString( $clone );
    my $this_skewness = $st->{'_skewness'};
    isnt(  $noisy->apply( $this_chromosome ),
	   $noisy->apply( $this_chromosome ),
	   "Fitness different");
    isnt(  $this_skewness,
	   $st->{ '_skewness' },
	   "Skewness changed");

    $units = $clone;
}

done_testing();

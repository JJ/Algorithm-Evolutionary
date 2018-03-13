#-*-cperl-*-

#Test the MMDP fitness function

use Test::More ;

use warnings;
use strict;

use lib qw( ../../../lib ../../lib ../lib lib ); #Just in case we are testing it in-place

use Algorithm::Evolutionary::Fitness::MMDP;
use Algorithm::Evolutionary::Individual::String;
use Math::Random qw(random_normal);

use_ok( "Algorithm::Evolutionary::Fitness::Skewed", "using Fitness::Skewed OK" );

my $units = "000000";
my $mmdp = new  Algorithm::Evolutionary::Fitness::MMDP;
my $noisy = new Algorithm::Evolutionary::Fitness::Skewed( $mmdp );
for (my $i = 0; $i < length($units); $i++ ) {
    my $clone = $units;
    substr($clone, $i, 1 ) = "1";
    my $this_chromosome = Algorithm::Evolutionary::Individual::String->fromString( $clone );
    isnt(  $noisy->apply( $this_chromosome ),
	   $noisy->apply( $this_chromosome ),
	   "Fitness different");
    $units = $clone;
}

$noisy = new Algorithm::Evolutionary::Fitness::Skewed( $mmdp, 1, 0.5 );
for (my $i = 0; $i < length($units); $i++ ) {
    my $clone = $units;
    substr($clone, $i, 1 ) = "1";
    my $this_chromosome = Algorithm::Evolutionary::Individual::String->fromString( $clone );
    isnt(  $noisy->apply( $this_chromosome ),
	   $noisy->apply( $this_chromosome ),
	   "Fitness different");
    $units = $clone;
}

done_testing();

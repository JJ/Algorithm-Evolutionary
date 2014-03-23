#-*-cperl-*-

#Test the MMDP fitness function

use Test::More ;

use warnings;
use strict;

use lib qw( ../../../lib ../../lib ../lib lib ); #Just in case we are testing it in-place

use Algorithm::Evolutionary::Fitness::MMDP;
use Algorithm::Evolutionary::Individual::String;
use Math::Random qw(random_normal);

use_ok( "Algorithm::Evolutionary::Fitness::Noisy", "using Fitness::Noisy OK" );

my $units = "000000";
my $mmdp = new  Algorithm::Evolutionary::Fitness::MMDP;
my $noisy = new Algorithm::Evolutionary::Fitness::Noisy( $mmdp );
for (my $i = 0; $i < length($units); $i++ ) {
    my $clone = $units;
    substr($clone, $i, 1 ) = "1";
    my $this_chromosome = Algorithm::Evolutionary::Individual::String->fromString( $clone );
    isnt(  $noisy->apply( $this_chromosome ),
	   $noisy->apply( $this_chromosome ),
	   "Fitness different");
    $units = $clone;
}

$noisy = new Algorithm::Evolutionary::Fitness::Noisy( $mmdp, sub { return random_normal( 1, 0, 0.1) } );
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

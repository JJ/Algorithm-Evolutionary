#-*-cperl-*-
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 22;

use warnings;
use strict;

use lib qw( ../../lib ../lib lib ); #Just in case we are testing it in-place

use Algorithm::Evolutionary::Utils qw(random_bitstring);

use_ok( "Algorithm::Evolutionary::Fitness::SkewTrap", "using Fitness::Trap OK" );

my $number_of_bits = 5;

my $trap = new Algorithm::Evolutionary::Fitness::SkewTrap( $number_of_bits );
isa_ok( $trap,  "Algorithm::Evolutionary::Fitness::SkewTrap" );

my $string = random_bitstring(100);
ok( $trap->skewtrap( $string ) > 0, "Seems to work" );

for ( my $i = 0; $i < 16; $i++ ) {
  my $binary = sprintf "%04b", $i;
  my $resultado = $trap->skewtrap( $binary );
  isnt( $resultado,  $trap->skewtrap( $binary ), "Result for $binary is $resultado, but not twice" );
}

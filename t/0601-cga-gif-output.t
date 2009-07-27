#-*-CPerl-*-

#########################
use strict;
use warnings;

use Test::More tests => 3;
use lib qw( lib ../lib ../../lib ); #Just in case we are testing it in-place

use Algorithm::Evolutionary qw(Fitness::ONEMAX 
			       Individual::BitString
			       Op::Easy);

BEGIN {
  use_ok( "Algorithm::Evolutionary::Op::Animated_GIF_Output" );
}

#########################

my $number_of_bits = 32;
my $pixels_per_bit = 3;
my $om = new Algorithm::Evolutionary::Fitness::ONEMAX $number_of_bits;

my @pop;

my $population_size = 100;
for ( 1..$population_size ) {
  my $indi = new Algorithm::Evolutionary::Individual::BitString 30*$number_of_bits ; #Creates random individual
  push( @pop, $indi );
}

my $e =  new Algorithm::Evolutionary::Op::Easy $om;

my $gif_output = new Algorithm::Evolutionary::Op::Animated_GIF_Output 
  { length => $number_of_bits, 
      pixels_per_bit => $pixels_per_bit,
	number_of_strings => $population_size };
	
isa_ok( $gif_output, 'Algorithm::Evolutionary::Op::Animated_GIF_Output');

for ( 1..40 ) {
  $e->apply( \@pop);
  $gif_output->apply( \@pop );
}
$gif_output->terminate();
is( $gif_output->output() ne '', 1, "Salida OK" );


=cut

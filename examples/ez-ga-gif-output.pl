#!/usr/bin/perl

#########################
use strict;
use warnings;

use lib qw( lib ../lib ../../lib ); #Just in case we are testing it in-place

use Algorithm::Evolutionary qw(Fitness::ONEMAX 
			       Individual::BitString
			       Op::Easy Op::Animated_GIF_Output );

my $number_of_bits = shift || 32;
my $pixels_per_bit = shift || 3;
my $om = new Algorithm::Evolutionary::Fitness::ONEMAX $number_of_bits;

my @pop;

my $population_size = shift || 100;
for ( 1..$population_size ) {
  my $indi = new Algorithm::Evolutionary::Individual::BitString $number_of_bits ; #Creates random individual
  push( @pop, $indi );
}

my $e =  new Algorithm::Evolutionary::Op::Easy $om;

my $gif_output = new Algorithm::Evolutionary::Op::Animated_GIF_Output 
  { length => $number_of_bits, 
      pixels_per_bit => $pixels_per_bit,
	number_of_strings => $population_size };

my $generations = shift || 40;
for ( 1..$generations ) {
  $e->apply( \@pop);
  $gif_output->apply( \@pop );
}
$gif_output->terminate();
print $gif_output->output();;



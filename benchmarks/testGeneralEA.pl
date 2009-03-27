#!/usr/bin/perl

use warnings;
use strict;
use lib "../lib";

use Time::HiRes qw( gettimeofday tv_interval);

=head1 NAME

    testGeneralEA.pl - program that tests a simple evolutionary algorithm
                       on the royal road function

=cut

=head1 SYNOPSIS

At the command line, type
  bash% ./testGeneralEA.pl [numBits] [blockSize]
or
  bash% perl testEA.pl [numBits] [blockSize]
Default number of bits is 128, and default block size is 4. The number of
bits should be a divisor of 128, but that is not compulsory.

=cut 

#EA-related modules
use Mutation;
use Crossover;
use GenerationalTerm;
use DeltaTerm;
use EZFullAlgo;
use BinaryIndi;
use RouletteWheel;
use TournamentSelect;
use GeneralGeneration;

=head1 DESCRIPTION

Sample evolutionary algorithm, applied to bitstrings, implementing the 
royal road function.

=cut


my $numBits = shift || 128;
my $blockSize = shift || 4;
my $popSize = shift || 500;
my $numGens = shift || undef; #If there are no more params, we assume delta termination, that
#is, run until you find the end


#Define the fitness function. We will use the well known Royal Road function,
#with a predefined block size
my $rr = sub {
  my $chrom = shift;
  my $str = $chrom->Chrom();
  my $fitness = 0;
  for ( my $i = 0; $i < length( $str ) / $blockSize; $i++ ) {
	my $block = 1;
	for ( my $j = 0; $j < $blockSize; $j++ ) {
	  $block &= substr( $str, $i*$blockSize+$j, 1 );
	}
	( $fitness += $blockSize ) if $block;
  }
  return $fitness;
};

#Define variation operators
my $m = new Mutation  0.1 ; # 10% of the points
my $c = new Crossover 2, 4; #Classical 2-point crossover; 4 times more frequent than mutation

#Use them to define the algorithm. It's not really needed, this type
#of algorithm defines both operators by default
#Second argument is the selection rate
#my $selector = new TournamentSelect $popSize, 7;
my $selector = new RouletteWheel $popSize;
my $generation = new GeneralGeneration( $rr, $selector, [$m, $c], 0.4 );

#Define a full algorithm from this one, and a terminator;
my $term;
if ( $numGens ) {
  $term = new GenerationalTerm  $numGens ; #Run for a number of generations
} else {
  $term = new DeltaTerm  $numBits, 0 ; #Run until optimum is found
}
my $fullAlgo = new EZFullAlgo  $generation, $term, 1 ;

#Set initial time
my $t0 = [gettimeofday()];

#Go to define the initial population and evaluate it
my @pop;
for ( 0..$popSize ) {
  my $indi = new BinaryIndi $numBits ; #Creates random individual
  print "Creating $_ =>\n", $indi->asString(), "\n";
  my $fitness = $rr->( $indi );
  $indi->Fitness( $fitness );
  push( @pop, $indi );
}

#Apply the algorithm
$fullAlgo->apply( \@pop );

#Print Results
print "The best is ", $pop[0]->asString(), "\n";
print "Time elapsed ", tv_interval( $t0 );

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/03/27 19:56:45 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/benchmarks/Attic/testGeneralEA.pl,v 1.1 2009/03/27 19:56:45 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $

=cut

#!/usr/bin/perl

use warnings;
use strict;
use lib "..";

use Time::HiRes qw( gettimeofday tv_interval);

=head1 NAME

    general_ea.pl - program that tests a simple evolutionary algorithm
                       on the royal road function

=cut

=head1 SYNOPSIS

At the command line, type
  bash% ./general_EA.pl [numBits] [blockSize] [popSize]
or
  bash% perl testEA.pl [numBits] [blockSize]
Default number of bits is 128, and default block size is 4. The number of
bits should be a divisor of 128, but that is not compulsory.

=cut 


use lib qw( ../lib );

#EA-related modules
use Algorithm::Evolutionary::Op::Mutation;
use Algorithm::Evolutionary::Op::Crossover;
use Algorithm::Evolutionary::Op::GenerationalTerm;
use Algorithm::Evolutionary::Op::FullAlgorithm;
use Algorithm::Evolutionary::Individual::BitString;
use Algorithm::Evolutionary::Op::RouletteWheel;
use Algorithm::Evolutionary::Op::GeneralGeneration;
use Algorithm::Evolutionary::Fitness::Royal_Road;

=head1 DESCRIPTION

Sample evolutionary algorithm, applied to bitstrings, implementing the 
royal road function.

=cut

my $numBits = shift || 128;
my $block_size = shift || 4;
my $popSize = shift || 500;
my $num_generations = 100;
my $periods = 5;

#Define the fitness function. We will use the well known Royal Road function,
#with a predefined block size
my $rr = new Algorithm::Evolutionary::Fitness::Royal_Road( $block_size );

#Define variation operators
my $m = new Algorithm::Evolutionary::Op::Mutation  0.1 ; # 10% of the points
my $c = new Algorithm::Evolutionary::Op::Crossover 2, 4; #Classical 2-point crossover; 4 times more frequent than mutation

#Use them to define the algorithm. It's not really needed, this type
#of algorithm defines both operators by default
#Second argument is the selection rate
#my $selector = new TournamentSelect $popSize, 7;
my $selector = new Algorithm::Evolutionary::Op::RouletteWheel $popSize;
my $generation = new Algorithm::Evolutionary::Op::GeneralGeneration( $rr, $selector, [$m, $c], 0.4 );

#Define a full algorithm from this one, and a terminator;
my $term = new Algorithm::Evolutionary::Op::GenerationalTerm  $num_generations ; #Run for a number of generations
my $fullAlgo = new Algorithm::Evolutionary::Op::FullAlgorithm  $generation, $term;

#Set initial time
my $t0 = [gettimeofday()];

#Go to define the initial population and evaluate it
my @pop;
print "Generating population\n";
for ( 0..$popSize ) {
  my $indi = new Algorithm::Evolutionary::Individual::BitString $numBits ; #Creates random individual
  my $fitness = $rr->apply( $indi );
  $indi->Fitness( $fitness );
  push( @pop, $indi );
}

#Apply the algorithm
print "Running algorithm\n";
for ( my $i = 0; $i < $periods; $i ++ ) {
    $fullAlgo->apply( \@pop );

#Print Results
    print "The best in period $i is ", $pop[0]->asString(), "\n";
    print "Time elapsed ", tv_interval( $t0 ), "\n";
}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/07/28 06:13:21 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/benchmarks/general_EA.pl,v 1.3 2008/07/28 06:13:21 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.3 $

=cut

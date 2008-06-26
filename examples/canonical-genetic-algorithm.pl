#!/usr/bin/perl

=head1 NAME

canonical-genetic-algorithm.pl - Canonical Genetic Algorithm on a simple fitness function

=head1 SYNOPSIS

  prompt% ./canonical-genetic-algorithm.pl <population> <number of generations>


=head1 DESCRIPTION  

A canonical GA uses mutation, crossover, binary representation, and
    roulette wheel selection. 

=cut

use warnings;
use strict;

use Time::HiRes qw( gettimeofday tv_interval);

use lib qw(lib ../lib);
use Algorithm::Evolutionary::Individual::BitString;
use Algorithm::Evolutionary::Op::Creator;
use Algorithm::Evolutionary::Op::CanonicalGA;
use Algorithm::Evolutionary::Op::Bitflip;
use Algorithm::Evolutionary::Op::Crossover;
use Algorithm::Evolutionary::Fitness::Royal_Road;
use Algorithm::Evolutionary::Utils qw(entropy consensus);

#----------------------------------------------------------#
my $bits = shift || 64;
my $block_size = shift || 4;
my $pop_size = shift || 256; #Population size
my $numGens = shift || 200; #Max number of generations
my $selection_rate = shift || 0.2;


#----------------------------------------------------------#
#Initial population
my @pop;
my $creator = new Algorithm::Evolutionary::Op::Creator( $pop_size, 'BitString', { length => $bits });
$creator->apply( \@pop ); #Generates population

#----------------------------------------------------------#
# Variation operators
my $m = Algorithm::Evolutionary::Op::Bitflip->new( 1 );
my $c = Algorithm::Evolutionary::Op::Crossover->new(2, 4);

# Fitness function: create it and evaluate
my $rr = new  Algorithm::Evolutionary::Fitness::Royal_Road( $block_size );
map( $_->evaluate( $rr ), @pop ); 

#----------------------------------------------------------#
#Usamos estos operadores para definir una generación del algoritmo. Lo cual
# no es realmente necesario ya que este algoritmo define ambos operadores por
# defecto. Los parámetros son la función de fitness, la tasa de selección y los
# operadores de variación.
my $generation = Algorithm::Evolutionary::Op::CanonicalGA->new( $rr , $selection_rate , [$m, $c] ) ;

#Time, counter and do the do
my $inicioTiempo = [gettimeofday()];
my $contador=0;
do {
  $generation->apply( \@pop );
  print "$contador : ", $pop[0]->asString(), "\n" ;
  $contador++;
} while( ($contador < $numGens) 
	 && ($pop[0]->Fitness() < $bits));


#----------------------------------------------------------#
# Show best
print "Best is:\n\t ",$pop[0]->asString()," Fitness: ",$pop[0]->Fitness(),"\n";

print "\n\n\tTime: ", tv_interval( $inicioTiempo ) , "\n";

print "\n\tEvaluations: ", $rr->evaluations(), "\n";

print "\n\tCache size ratio: ", $rr->cached_evals()/$rr->evaluations(), "\n";

=head1 AUTHOR

J. J. Merelo, C<jj (at) merelo.net>

=cut

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/06/26 11:37:43 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/examples/Attic/canonical-genetic-algorithm.pl,v 1.2 2008/06/26 11:37:43 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.2 $
  $Name $

=cut

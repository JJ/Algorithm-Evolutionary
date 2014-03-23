#!/usr/bin/perl

=head1 NAME

  trap.pl - Massively multimodal deceptive problem

=head1 SYNOPSIS

  prompt% ./trap.pl <population> <number of generations>

or

  prompt% perl trap.pl <population> <number of generations>

Shows fitness and best individual  
  

=head1 DESCRIPTION  

A simple example of how to run an Evolutionary algorithm based on
Algorithm::Evolutionary. Optimizes trap function with a noisy fitness evaluation

=cut


use warnings;
use strict;

use Time::HiRes qw( gettimeofday tv_interval);

use lib qw(lib ../lib);
use Algorithm::Evolutionary::Individual::BitString;
use Algorithm::Evolutionary::Op::Easy;
use Algorithm::Evolutionary::Op::Mutation;
use Algorithm::Evolutionary::Op::Crossover;
use Algorithm::Evolutionary::Fitness::Trap;
use Algorithm::Evolutionary::Fitness::Noisy;

#----------------------------------------------------------#
my $blocks = shift || 10;
my $length = shift || 4;
my $popSize = shift || 1024; #Population size
my $numGens = shift || 1000; #Max number of generations
my $selection_rate = shift || 0.1;

#----------------------------------------------------------#
#Initial population
my @pop;
#Creamos $popSize individuos
my $bits = $length*$blocks; 
for ( 0..$popSize ) {
  my $indi = Algorithm::Evolutionary::Individual::BitString->new( $bits );
  push( @pop, $indi );
}

#----------------------------------------------------------#
# Variation operators
my $m = Algorithm::Evolutionary::Op::Mutation->new( 0.1 );
my $c = Algorithm::Evolutionary::Op::Crossover->new(2);

# Fitness function
my $trap = new  Algorithm::Evolutionary::Fitness::Trap( $length );
my $noisy = new  Algorithm::Evolutionary::Fitness::Noisy( $trap );

#----------------------------------------------------------#
# Usamos estos operadores para definir una generación del algoritmo. Lo cual
# no es realmente necesario ya que este algoritmo define ambos operadores por
# defecto. Los parámetros son la función de fitness, la tasa de selección y los
# operadores de variación.
#my $fitness = sub { $trap->apply(@_) };

my $generation = Algorithm::Evolutionary::Op::Easy->new( $noisy, $selection_rate , [$m, $c] ) ;

#Time
my $inicioTiempo = [gettimeofday()];

#----------------------------------------------------------#

my $contador=0;
my $best = "1"x($length*$blocks);
do {
    # Must re-evaluate each iteration
    for ( @pop ) {
      $_->evaluate( $noisy );
    }
    $generation->apply( \@pop );
    
    print "$contador : ", $pop[0]->asString(), "\n" ;

    $contador++;
} while( ($contador < $numGens) 
	 && ($pop[0]->{'_str'} ne $best ));


#----------------------------------------------------------#
#leemos el mejor resultado

#Mostramos los resultados obtenidos
print "El mejor es:\n\t ",$pop[0]->asString()," Fitness: ",$pop[0]->Fitness(),"\n";

print "\n\n\tTime: ", tv_interval( $inicioTiempo ) , "\n";

print "\n\tEvaluaciones: ", $noisy->evaluations(), "\n";

=head1 AUTHOR

Contributed by Pedro Castillo Valdivieso, modified by J. J. Merelo

=cut

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/07/24 08:46:58 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/examples/mmdp.pl,v 3.0 2009/07/24 08:46:58 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 3.0 $
  $Name $

=cut

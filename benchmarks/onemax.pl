#!/usr/bin/perl

=head1 NAME

onemax.pl - Optimization of the tide function using A::E

=head1 SYNOPSIS

  prompt% ./onemax.pl [bits] [population] [number of generations] [print interval]

or

  prompt% perl onemax.pl <bits>  <population> <number of generations>  <print interval>

Default values:
bits: 128
population: 200
number of generations: 500
print interval: 1

=head1 DESCRIPTION  

Runs the onemax function for benchmarking

=cut

use warnings;
use strict;

use Time::HiRes qw( gettimeofday tv_interval);

use lib qw(lib ../lib);
use Algorithm::Evolutionary::Individual::BitString;
use Algorithm::Evolutionary::Op::Easy;
use Algorithm::Evolutionary::Op::Bitflip;
use Algorithm::Evolutionary::Op::Crossover;
use Algorithm::Evolutionary::Fitness::ONEMAX;

#----------------------------------------------------------#
my $number_of_bits = shift || 128;
my $popSize = shift || 200; #Population size
my $num_generations = shift || 500; #Max number of generations
my $step = shift || 1; # Step for printing results

#----------------------------------------------------------#
#Initial population
my @pop;
#Creamos $popSize individuos
for ( 0..$popSize ) {
  my $indi = Algorithm::Evolutionary::Individual::BitString->new( $number_of_bits );
  push( @pop, $indi );
}

#----------------------------------------------------------#
# Variation operators
my $m = Algorithm::Evolutionary::Op::Bitflip->new( 1 );
my $c = Algorithm::Evolutionary::Op::Crossover->new(4);

#Fitness function
my $onemax = new Algorithm::Evolutionary::Fitness::ONEMAX;

#----------------------------------------------------------#
#Usamos estos operadores para definir una generación del algoritmo. Lo cual
# no es realmente necesario ya que este algoritmo define ambos operadores por
# defecto. Los parámetros son la función de fitness, la tasa de selección y los
# operadores de variación.
my $generation = Algorithm::Evolutionary::Op::Easy->new( $onemax , 0.2 , [$m, $c] ) ;

#Time
my $inicioTiempo = [gettimeofday()];

#----------------------------------------------------------#
for ( @pop ) {
  if ( !defined $_->Fitness() ) {
      $_->evaluate( $onemax );
  }
}

my $contador=0;
do {
  $generation->apply( \@pop );
  #----------------------------------------------------------#
  if ( $contador % $step == 0 ) {
#Mostramos los resultados obtenidos
      print "$contador; time: ". tv_interval( $inicioTiempo ) . "\n";
  }
} while( $contador++ < $num_generations );




=head1 AUTHOR

J. J. Merelo C<jj [at] merelo.net>

=cut

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/03/19 18:55:58 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/benchmarks/onemax.pl,v 2.2 2009/03/19 18:55:58 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 2.2 $
  $Name $

=cut

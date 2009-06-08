#!/usr/bin/perl

=head1 NAME

onemax.pl - Optimization of the tide function using A::E

=head1 SYNOPSIS

  prompt% ./onemax.pl [bits] [population] [number of generations] [print interval] [string|vector]

or

  prompt% perl onemax.pl <bits>  <population> <number of generations>  <print interval> <string|vector>

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

use lib qw(lib ../lib ../../lib);
use Algorithm::Evolutionary
  qw(Individual::BitString Individual::Bit_Vector
     Op::Easy Op::Bitflip 
     Op::Crossover Fitness::ONEMAX);

#----------------------------------------------------------#
my $number_of_bits = shift || 128;
my $popSize = shift || 200; #Population size
my $num_generations = shift || 500; #Max number of generations
my $step = shift || 1; # Step for printing results
my $data_structure = shift || 'string';

#----------------------------------------------------------#
#Initial population
my @pop;
#Creamos $popSize individuos
for ( 0..$popSize ) {
  my $indi;
  if ( $data_structure eq 'string' ) {
    $indi = Algorithm::Evolutionary::Individual::BitString->new( $number_of_bits );
  } else {
    $indi = Algorithm::Evolutionary::Individual::Bit_Vector->new( $number_of_bits );
  }
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

  CVS Info: $Date: 2009/06/08 18:41:50 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/benchmarks/onemax.pl,v 2.4 2009/06/08 18:41:50 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 2.4 $
  $Name $

=cut

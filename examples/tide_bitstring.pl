#!/usr/bin/perl

=head1 NAME

  tide_float.pl - Implementation of the Tide optimization using A::E

=head1 SYNOPSIS

  prompt% ./tide_float.pl <population> <number of generations>

or

  prompt% perl tide_float.pl <population> <number of generations>

  Shows the values of the two floating-point components of the
  chromosome and finally the best value and fitness reached, which
  should be as close to 1 as possible.
  

=head1 DESCRIPTION  

A simple example of how to run an Evolutionary algorithm based on
Algorithm::Evolutionary. Tries to find the max of the bidimensional
Tide , and outputs the x and y coordinates, along with fitness. Best
fitness is close to 1. Around 50 generations should be enough, but
default is population and number of generations equal to 100.
ti
=cut

use warnings;
use strict;

use Time::HiRes qw( gettimeofday tv_interval);

use lib qw(lib ../lib);
use Algorithm::Evolutionary::Individual::BitString;
use Algorithm::Evolutionary::Op::Easy;
use Algorithm::Evolutionary::Op::Bitflip;
use Algorithm::Evolutionary::Op::Crossover;

#----------------------------------------------------------#
my $popSize = shift || 100; #Population size
my $numGens = shift || 100; #Max number of generations
my $precision = shift || 20;

my $max = 2 << $precision -1;
#----------------------------------------------------------#
#Fitness function will be Tide
my $funcionMarea = sub {
  my $indi = shift;
  my $str = $indi->Chrom();


#extraemos los dos números reales de la cadena binaria
  my $l2=length($str)/2;  
  my $x=eval("0b".substr ($str, 0, $l2)); 
  $x = $x/$max*2 -1;
  my $y=eval("0b".substr ($str, $l2));
  $y = $y/$max*2 -1;
  my $sqrt = sqrt( $x*$x+$y*$y);

  if( !$sqrt ){ return 1; }
  return sin( $sqrt )/$sqrt;
};

#----------------------------------------------------------#
#Initial population
my @pop;
#Creamos $popSize individuos
for ( 0..$popSize ) {
  my $indi = Algorithm::Evolutionary::Individual::BitString->new( $precision*2 );
  push( @pop, $indi );
}


#----------------------------------------------------------#
# Variation operators
my $m = Algorithm::Evolutionary::Op::Bitflip->new();
my $c = Algorithm::Evolutionary::Op::Crossover->new(2);


#----------------------------------------------------------#
#Usamos estos operadores para definir una generación del algoritmo. Lo cual
# no es realmente necesario ya que este algoritmo define ambos operadores por
# defecto. Los parámetros son la función de fitness, la tasa de selección y los
# operadores de variación.
my $generation = Algorithm::Evolutionary::Op::Easy->new( $funcionMarea , 0.2 , [$m, $c] ) ;

#Time
my $inicioTiempo = [gettimeofday()];

#----------------------------------------------------------#
for ( @pop ) {
  if ( !defined $_->Fitness() ) {
    my $fitness = $funcionMarea->($_);
    $_->Fitness( $fitness );
  }
}

my $contador=0;
do {
  $generation->apply( \@pop );

  print "$contador : ", $pop[0]->asString(), "\n" ;

  $contador++;
} while( $contador < $numGens );


#----------------------------------------------------------#
#leemos el mejor resultado
my ( $x, $y ) = @{$pop[0]->{_array}};

#Mostramos los resultados obtenidos
print "El mejor es:\n\t ",$pop[0]->asString(),"\n\t x=$x \n\t y=$y \n\t Fitness: ",$pop[0]->Fitness(),"\n";

print "\n\nTime: ". tv_interval( $inicioTiempo ) . "\n";

=head1 AUTHOR

Contributed by Pedro Castillo Valdivieso, modified by J. J. Merelo

=cut

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/04/30 16:31:41 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/examples/Attic/tide_bitstring.pl,v 1.1 2008/04/30 16:31:41 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $
  $Name $

=cut

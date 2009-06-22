#!/usr/bin/perl

use strict;
use warnings;

use Algorithm::RectanglesContainingDot;

use Time::HiRes qw( gettimeofday tv_interval);

use lib qw(lib ../lib);
use Algorithm::Evolutionary qw( Individual::BitString Op::Easy 
				Op::Bitflip Op::Crossover );


my $alg = Algorithm::RectanglesContainingDot->new;

my $num_rects = shift || 25;
my $arena_side = shift || 10;
my $dot_x = shift || 5;
my $dot_y = shift || 5;

my $bits = shift || 32;
my $popSize = shift || 64; #Population size
my $numGens = shift || 50; #Max number of generations
my $selection_rate = shift || 0.2;

#Generate random rectangles
for my $i (0 .. $num_rects) {

  my $x_0 = rand( $arena_side );
  my $y_0 = rand( $arena_side);
  $alg->add_rectangle("rectangle_$i", $x_0, $y_0, 
		      rand( $arena_side - $x_0 ), rand($arena_side-$y_0));
}

my $fitness = sub {
  my $individual = shift;
  my ( $dot_x, $dot_y ) = $individual->decode($bits/2,0, $arena_side);
  my @contained_in = $alg->rectangles_containing_dot($dot_x, $dot_y);
  return scalar @contained_in;
};


#----------------------------------------------------------#
#Initial population
my @pop;
#Creamos $popSize individuos
for ( 0..$popSize ) {
  my $indi = Algorithm::Evolutionary::Individual::BitString->new( $bits );
  push( @pop, $indi );
}

#----------------------------------------------------------#
# Variation operators
my $m = Algorithm::Evolutionary::Op::Bitflip->new; # Rate = 1
my $c = Algorithm::Evolutionary::Op::Crossover->new(2, 9 ); # Rate = 4

#----------------------------------------------------------#
#Usamos estos operadores para definir una generación del algoritmo. Lo cual
# no es realmente necesario ya que este algoritmo define ambos operadores por
# defecto. Los parámetros son la función de fitness, la tasa de selección y los
# operadores de variación.
my $generation = Algorithm::Evolutionary::Op::Easy->new( $fitness , $selection_rate , [$m, $c] ) ;

#Time
my $inicioTiempo = [gettimeofday()];

#----------------------------------------------------------#
for ( @pop ) {
  if ( !defined $_->Fitness() ) {
    my $this_fitness = $fitness->($_);
    $_->Fitness( $this_fitness );
  }
}

my $contador=0;
do {
  $generation->apply( \@pop );
  
  print "$contador : ", $pop[0]->asString(), "\n" ;
  $contador++;
} while( ($contador < $numGens) 
	 && ($pop[0]->Fitness() < $num_rects));


#----------------------------------------------------------#
#leemos el mejor resultado

#Mostramos los resultados obtenidos
print "Best is:\n\t ",$pop[0]->asString()," Fitness: ",$pop[0]->Fitness(),"\n";

print "\n\n\tTime: ", tv_interval( $inicioTiempo ) , "\n";


=head1 AUTHOR

Contributed by J. J. Merelo

=cut

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/06/22 07:25:52 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/examples/find_dot_in_rectangles.pl,v 1.1 2009/06/22 07:25:52 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $
  $Name $

=cut

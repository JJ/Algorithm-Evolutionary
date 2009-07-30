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
my $number_of_pots = shift || 64; #Population size
my $number_of_cookoffs = shift || 50; #Max number of cook_offs
my $selection_rate = shift || 0.2;

#Generate random rectangles
for my $i (0 .. $num_rects) {

  my $x_0 = rand( $arena_side );
  my $y_0 = rand( $arena_side);
  my $side_x = rand( $arena_side - $x_0 );
  my $side_y = rand($arena_side-$y_0);
  $alg->add_rectangle("rectangle_$i", $x_0, $y_0, $x_0+$side_x, $y_0+$side_y );

}

#Declare fitness function
my $taste = sub {
  my $individual = shift;
  my ( $dot_x, $dot_y ) = $individual->decode($bits/2,0, $arena_side);
  my @contained_in = $alg->rectangles_containing_dot($dot_x, $dot_y);
  return scalar @contained_in;
};


#----------------------------------------------------------#
#Initial population
my @pots;
#Creamos $number_of_pots individuos
for ( 0..$number_of_pots ) {
  my $indi = Algorithm::Evolutionary::Individual::BitString->new( $bits );
  push( @pots, $indi );
}

#----------------------------------------------------------#
# Variation operators
my $m = Algorithm::Evolutionary::Op::Bitflip->new; # Rate = 1
my $c = Algorithm::Evolutionary::Op::Crossover->new(2, 9 ); # Rate = 9

#----------------------------------------------------------#
#Usamos estos operadores para definir una generación del algoritmo. Lo cual
# no es realmente necesario ya que este algoritmo define ambos operadores por
# defecto. Los parámetros son la función de fitness, la tasa de selección y los
# operadores de variación.
my $cook_off = Algorithm::Evolutionary::Op::Easy->new( $taste , $selection_rate , [$m, $c] ) ;

#Time
my $inicioTiempo = [gettimeofday()];

#----------------------------------------------------------#
for ( @pots ) {
  if ( !defined $_->Fitness() ) {
    my $this_fitness = $taste->($_);
    $_->Fitness( $this_fitness );
  }
}

# Start cooking
my $contador=0;
do {
  $cook_off->apply( \@pots );
  
  print "$contador : ", $pots[0]->asString(), "\n" ;
  $contador++;
} while( ($contador < $number_of_cookoffs) 
	 && ($pots[0]->Fitness() < $num_rects));


#----------------------------------------------------------#
#leemos el mejor resultado

#Mostramos los resultados obtenidos
print "Best is:\n\t ",$pots[0]->asString()," Fitness: ",$pots[0]->Fitness(),"\n";

print "\n\n\tTime: ", tv_interval( $inicioTiempo ) , "\n";


=head1 AUTHOR

Contributed by J. J. Merelo

=cut

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/07/30 18:56:18 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/examples/find_dot_in_rectangles_feijoadic.pl,v 1.1 2009/07/30 18:56:18 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $
  $Name $

=cut

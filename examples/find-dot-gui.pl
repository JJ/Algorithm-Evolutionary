#!/usr/bin/perl -w

use Tk;
use strict;
use warnings;

use Algorithm::RectanglesContainingDot;

use Time::HiRes qw( gettimeofday tv_interval);

use lib qw(lib ../lib);
use Algorithm::Evolutionary qw( Individual::BitString Op::Easy 
				Op::Bitflip Op::Crossover );


my $size = 600;

# Create MainWindow and configure:
my $mw = MainWindow->new;
$mw->configure( -width=>$size, -height=>$size );
$mw->resizable( 0, 0 ); # not resizable in any direction

# Create and configure the canvas:
my $canvas = $mw->Canvas( -cursor=>"crosshair", -background=>"white",
              -width=>$size, -height=>$size )->pack;
my $alg = Algorithm::RectanglesContainingDot->new;

my $num_rects = shift || 50;
my $arena_side = shift || 10;
my $dot_x = shift || 5;
my $dot_y = shift || 5;

my $bits = shift || 32;
my $popSize = shift || 64; #Population size
my $numGens = shift || 200; #Max number of generations
my $selection_rate = shift || 0.2;

my $scale = $arena_side/$size;
#Generate random rectangles
for my $i (0 .. $num_rects) {

  my $x_0 = rand( $arena_side );
  my $y_0 = rand( $arena_side);
  my $side_x = rand( $arena_side - $x_0 );
  my $side_y = rand($arena_side-$y_0);
  $alg->add_rectangle("rectangle_$i", $x_0, $y_0, 
		      $x_0+$side_x, $x_0+$side_y );
  my $val = 255*$i/$num_rects;
  my $color = sprintf( "#%02x%02x%02x", $val, $val, $val );
  $canvas->createRectangle( $x_0/$scale, $y_0/$scale, 
			    $side_x/$scale, $side_y/$scale, 
			    -outline =>$color );
}

#Declare fitness function
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
my $c = Algorithm::Evolutionary::Op::Crossover->new(2, 9 ); # Rate = 9

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

# Start Evolutionary Algorithm
my $contador=0;
do {
  $generation->apply( \@pop );
  
  my $val = 255*$contador/$numGens;
  my $color = sprintf( "#%02x%02x00", 255-$val, 255-$val );
  print "$contador : ", $pop[0]->asString(), ", Color $color\n" ;
  $contador++;
  my @point = map( $_/$scale, $pop[0]->decode($bits/2,0, $arena_side));


  $canvas->createOval($point[0]-2, $point[1]-2, 
		      $point[0]+2, $point[1]+2, 
		      -fill => $color );
} while( ($contador < $numGens) 
	 && ($pop[0]->Fitness() < $num_rects));


#----------------------------------------------------------#
#leemos el mejor resultado

#Mostramos los resultados obtenidos
print "Best is:\n\t ",$pop[0]->asString()," Fitness: ",$pop[0]->Fitness(),"\n";

print "\n\n\tTime: ", tv_interval( $inicioTiempo ) , "\n";
my @point = map( $_/$scale, $pop[0]->decode($bits/2,0, $arena_side));

$canvas->createOval($point[0]-3, $point[1]-3, 
		    $point[0]+3, $point[1]+3, 
		    -fill => 'black' );
MainLoop;

=head1 AUTHOR

Contributed by J. J. Merelo

=cut

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/07/24 08:46:58 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/examples/find-dot-gui.pl,v 3.0 2009/07/24 08:46:58 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 3.0 $
  $Name $

=cut


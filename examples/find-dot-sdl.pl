#!/usr/bin/perl -w

use strict;
use warnings;

use Algorithm::RectanglesContainingDot;

use Time::HiRes qw( gettimeofday tv_interval);

use lib qw(lib ../lib);
use Algorithm::Evolutionary qw( Individual::BitString Op::Easy 
				Op::Bitflip Op::Crossover );

use SDL::App;
use SDL::Rect;
use SDL::Color;

my ($side, $depth) = (640, 16);

# change these values as necessary
my $title                                = 'EC as SDL Animation';
my ($bg_r,       $bg_g,        $bg_b)    = ( 0x00, 0x00, 0x00 );
my ($rect_r,     $rect_g,      $rect_b)  = ( 0x00, 0x00, 0xff ); 


my $app = SDL::App->new(
	-width  => $side,
	-height => $side,
	-depth  => $depth,
);

my $color = SDL::Color->new(
	-r => $rect_r,
	-g => $rect_g,
	-b => $rect_b,
);

my $bg_color = SDL::Color->new(
	-r => $bg_r,
	-g => $bg_g,
	-b => $bg_b,
);

my $dot_color = SDL::Color->new( -r => 255,
				 -g => 255,
				 -b => 0 );

my $background = SDL::Rect->new(
	-width  => $side,
	-height => $side,
);

#my $rect = create_rect();

# your code here, perhaps
my $alg = Algorithm::RectanglesContainingDot->new;

my $num_rects = shift || 50;
my $arena_side = shift || 10;
my $dot_x = shift || 5;
my $dot_y = shift || 5;

my $bits = shift || 32;
my $popSize = shift || 64; #Population size
my $numGens = shift || 200; #Max number of generations
my $selection_rate = shift || 0.2;

my $scale = $arena_side/$side;
#Generate random rectangles
$app->fill(   $background,   $bg_color   );
for my $i (0 .. $num_rects) {
  $app->update( $background );
  my $x_0 = rand( $arena_side );
  my $y_0 = rand( $arena_side);
  my $side_x = rand( $arena_side - $x_0 );
  my $side_y = rand($arena_side-$y_0);
  $alg->add_rectangle("rectangle_$i", $x_0, $y_0, 
		      $x_0+$side_x, $x_0+$side_y );
  my $val = 255*$i/$num_rects;
  my $this_rect = SDL::Rect->new( -height => $side_y/$scale,
				  -width  => $side_x/$scale,
				  -x      => $x_0/$scale,
				  -y      => $y_0/$scale );

  my $inner_rect = SDL::Rect->new( -height => $side_y/$scale-2,
				   -width  => $side_x/$scale-2,
				   -x      => 1+$x_0/$scale,
				   -y      => 1+$y_0/$scale );
  $app->fill($this_rect, $color);
  $app->fill($inner_rect, $bg_color);
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
  $app->update( $background );
  $generation->apply( \@pop );
  
  my $val = 255*$contador/$numGens;
  my $color = sprintf( "#%02x%02x00", 255-$val, 255-$val );
  print "$contador : ", $pop[0]->asString(), ", Color $color\n" ;
  $contador++;
  my @point = map( $_/$scale, $pop[0]->decode($bits/2,0, $arena_side));
  
  my $this_rect = SDL::Rect->new( -height => 2,
				  -width  => 2,
				  -x      => $point[0]-1,
				  -y      => $point[1]+1 );
  $app->fill($this_rect, $dot_color);
  
} while( ($contador < $numGens) 
	 && ($pop[0]->Fitness() < $num_rects));


#----------------------------------------------------------#

#Show result
print "Best is:\n\t ",$pop[0]->asString()," Fitness: ",$pop[0]->Fitness(),"\n";

print "\n\n\tTime: ", tv_interval( $inicioTiempo ) , "\n";

sub draw_frame
{
	my ($app, %args) = @_;

	$app->fill(   $args{bg},   $args{bg_color}   );
	$app->fill(   $args{rect}, $args{rect_color} );
	$app->update( $args{bg} );
}

sub draw_undraw_rect
{
	my ($app, %args) = @_;

	$app->fill(   $args{old_rect}, $args{bg_color}   );
	$app->fill(   $args{rect},     $args{rect_color} );
	$app->update( $args{old_rect} );
	$app->update( $args{rect} );
}





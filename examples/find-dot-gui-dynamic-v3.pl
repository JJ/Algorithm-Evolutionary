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

my $num_rects = shift || 300;
my $arena_side = shift || 10;

my $bits = shift || 32;
my $pop_size = shift || 64; #Population size
my $number_of_generations = shift || 200; #Max number of generations
my $selection_rate = shift || 0.2;
my $scale = $arena_side/$size;

my $alg = Algorithm::RectanglesContainingDot->new;
my $fitness;
my $generation;
my @pop;
# Start Evolutionary Algorithm
my $contador=0;
my $dot_size = 6;
my $mini_dot_size = $dot_size/2;
my @dot_population;

# Create and configure the widgets
my $f = $mw->Frame(-relief => 'groove',
		   -bd => 2)->pack(-side => 'top',
				   -fill => 'x');

for my $v ( qw( num_rects arena_side bits pop_size number_of_generations selection_rate ) ){
  create_and_pack( $f, $v );
}

my $canvas = $mw->Canvas( -cursor=>"crosshair", -background=>"white",
              -width=>$size, -height=>$size )->pack;
$mw->Button( -text    => 'Start',
	     -command => \&start,
	   )->pack( -side => 'left',
		    -expand => 1);
$mw->Button( -text    => 'End',
	       -command => \&finished,
	     )->pack( -side => 'left',
		      -expand => 1 );
$mw->Button( -text    => 'Exit',
	     -command => sub { exit(0);},
	   )->pack( -side => 'left',
		    -expand => 1 );

$mw->eventAdd('<<Gen>>' => '<KeyPress>');
$mw->eventAdd('<<Fin>>' => '<Control-C>');
$mw->bind('<<Gen>>' => \&generation);
$mw->bind('<<Fin>>' => \&finished );


sub create_and_pack {
  my $frame = shift;
  my $var = shift;
  my $f = $frame->Frame();
  my $label = $f->Label(-text => $var )->pack(-side => 'left');
  my $entry = $f->Entry( -textvariable => eval '\$'.$var )->pack(-side => 'right' );
  $f->pack();
}

sub start {
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
  $fitness = sub {
    my $individual = shift;
    my ( $dot_x, $dot_y ) = $individual->decode($bits/2,0, $arena_side);
    my @contained_in = $alg->rectangles_containing_dot($dot_x, $dot_y);
    return scalar @contained_in;
  };



  #----------------------------------------------------------#
  #Initial population
  #Creamos $pop_size individuos
  for ( 0..$pop_size ) {
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
  $generation = Algorithm::Evolutionary::Op::Easy->new( $fitness , $selection_rate , [$m, $c] ) ;


#----------------------------------------------------------#
  for ( @pop ) {
    if ( !defined $_->Fitness() ) {
      my $this_fitness = $fitness->($_);
      $_->Fitness( $this_fitness );
    }
  }

  #Start the music
  $mw->eventGenerate( '<<Gen>>', -when => 'tail' );
}

sub generation {
    while (@dot_population) {
	$canvas->delete( shift @dot_population );
    }
    $generation->apply( \@pop );
    print "Pop size $#pop\n";
    
    my $val = 255*$contador/$number_of_generations;
    my $color = sprintf( "#%02x%02x00", 255-$val, 255-$val );
    my @point = map( $_/$scale, $pop[0]->decode($bits/2,0, $arena_side));
    print "$contador : ", $pop[0]->asString(), ", Color $color\n\tDecodes to $point[0], $point[1]\n" ;
    $contador++;
    
    $canvas->createOval($point[0]-$dot_size, $point[1]-$dot_size, 
			$point[0]+$dot_size, $point[1]+$dot_size, 
			-fill => $color );

    for my $p ( @pop ) {
	my @point = map( $_/$scale, $p->decode($bits/2,0, $arena_side));
	push @dot_population,$canvas->createOval($point[0]-$mini_dot_size, $point[1]-$mini_dot_size, 
						 $point[0]+$mini_dot_size, $point[1]+$mini_dot_size, 
						 -fill => "#00ff00" ); 
    }
    $canvas->update();
    if  ( ($contador < $number_of_generations) 
	  && ($pop[0]->Fitness() < $num_rects)) {
	$mw->eventGenerate( '<<Gen>>', -when => 'tail' );
    } else {
	$mw->eventGenerate( '<<Fin>>' );
    }
}


sub finished {
#----------------------------------------------------------#
#leemos el mejor resultado
    
#Mostramos los resultados obtenidos
    print "Best is:\n\t ",$pop[0]->asString()," Fitness: ",$pop[0]->Fitness(),"\n";
    my @point = map( $_/$scale, $pop[0]->decode($bits/2,0, $arena_side));
}

MainLoop;

=head1 AUTHOR

Contributed by J. J. Merelo

=cut

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/07/29 17:06:13 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/examples/find-dot-gui-dynamic-v3.pl,v 1.3 2009/07/29 17:06:13 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.3 $
  $Name $

=cut


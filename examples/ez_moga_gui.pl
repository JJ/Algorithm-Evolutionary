#!/usr/bin/perl

=head1 NAME

  ez_moga.pl - Easy implementation of a very primitive multiobjective optimization algorithm

=head1 SYNOPSIS

  prompt% ./ez_moga.pl <population> <number of generations>

or

  prompt% perl p_peaks.pl <bits> <peaks> <population> <number of generations>

  Shows the values of the two floating-point components of the
  chromosome and finally the best value and fitness reached, which
  should be as close to 1 as possible.
  

=head1 DESCRIPTION  

A simple example of how to run an Evolutionary algorithm based on
Algorithm::Evolutionary. Tries to find the max of the bidimensional
Tide , and outputs the x and y coordinates, along with fitness. Best
fitness is close to 1. Around 50 generations should be enough, but
default is population and number of generations equal to 100.

=cut

use warnings;
use strict;

use Time::HiRes qw( gettimeofday tv_interval);

use lib qw(lib ../lib);
use Algorithm::Evolutionary qw( Individual::BitString Op::Easy_MO
				Op::Mutation Op::Crossover
				Fitness::ZDT1 );

use Tk;

#----------------------------------------------------------#
my $size = 600;

# Create MainWindow and configure:
my $mw = MainWindow->new;
$mw->configure( -width=>$size, -height=>$size );
$mw->resizable( 0, 0 ); # not resizable in any direction

#----------------------------------------------------------#
my $popSize = shift || 128; #Population size
my $numGens = shift || 100; #Max number of generations
my $selection_rate = shift || 0.5;

#----------------------------------------------------------#
#Initial population
my @pop;
#Creamos $popSize individuos
my $bits_x_var = 8;
my $number_of_vars= 30;
my $bits = $bits_x_var * $number_of_vars;
my $mini_dot_size =2;

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

#Variables used throughout
my $generation;
my $fitness;
my $counter=0;
my @dot_population;

MainLoop;

sub start {

  for ( 0..$popSize ) {
    my $indi = Algorithm::Evolutionary::Individual::BitString->new( $bits );
    push( @pop, $indi );
  }
  
  #----------------------------------------------------------#
  # Variation operators
  my $m = Algorithm::Evolutionary::Op::Mutation->new( 1/$bits ); # Rate = 1
  my $c = Algorithm::Evolutionary::Op::Crossover->new(2, 4 ); # Rate = 4
  
  $fitness = new  Algorithm::Evolutionary::Fitness::ZDT1 $bits_x_var;
  
  #----------------------------------------------------------#
  #Usamos estos operadores para definir una generación del algoritmo. Lo cual
  # no es realmente necesario ya que este algoritmo define ambos operadores por
  # defecto. Los parámetros son la función de fitness, la tasa de selección y los
  # operadores de variación.
  $generation = Algorithm::Evolutionary::Op::Easy_MO->new( $fitness , $selection_rate , [$m, $c] ) ;
  
  #Start the music
  $mw->eventGenerate( '<<Gen>>', -when => 'tail' );
}
  


sub generation {

  while (@dot_population) {
    $canvas->delete( shift @dot_population );
  }
  $generation->apply( \@pop );
  
  print "$counter : ", $pop[0]->asString(), "\n" ;
  $counter++;
  
  for my $p ( @pop ) {
    my @point =  @{$fitness->apply($p)};
    if ($p->Fitness()) {
	my $fitness = 1/$p->Fitness() - 1;
	my $color = sprintf( "#%02x%02x00", $fitness*30 % 255, 255-$fitness*30 % 255 );
	print "Fitness $fitness Color $color\n";
	push @dot_population,$canvas->createOval($point[1]*200-$mini_dot_size, 
						 $size  - $point[0]*400-2*$mini_dot_size, 
						 $point[1]*200+$mini_dot_size, 
						 $size - $point[0]*400, 
						 -fill => $color ); 
    }
  }
  $canvas->update();
  if  ( $counter < $numGens ) {
	$mw->eventGenerate( '<<Gen>>', -when => 'tail' );
    } else {
	$mw->eventGenerate( '<<Fin>>' );
    }
  
}
  
  #----------------------------------------------------------#
#leemos el mejor resultado

sub finished {
  #Mostramos los resultados obtenidos
  print "Best is:\n\t ",$pop[0]->asString()," Fitness: ",$pop[0]->Fitness(),"\n";
  
  print "\n\tEvaluations: ", $fitness->evaluations(), "\n";
  
  for ( my $p = 0; $p <= $#pop; $p ++ ) {
    print join( ",", @{$fitness->apply( $pop[$p] )}), "\n";
  }
}

=head1 AUTHOR

JJ Merelo

=cut

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/07/30 11:25:18 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/examples/ez_moga_gui.pl,v 1.2 2009/07/30 11:25:18 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.2 $
  $Name $

=cut

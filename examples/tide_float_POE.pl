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

=cut

use warnings;
use strict;

use Time::HiRes qw( gettimeofday tv_interval);

use lib qw(lib ../lib);
use Algorithm::Evolutionary::Individual::Vector;
use Algorithm::Evolutionary::Op::Easy;
use Algorithm::Evolutionary::Op::GaussianMutation;
use Algorithm::Evolutionary::Op::VectorCrossover;

use POE;

POE::Session->create( inline_states => {
    _start => \&start,
    generation => \&generation } );

print "Running kernel\n";
my $numGens = 100; #Max number of generations

#Time
my $inicioTiempo = [gettimeofday()];
$poe_kernel->run();
print "Exiting\n";
exit(0);



#----------------------------------------------------------#

sub start {
  my ($kernel, $heap) = @_[KERNEL, HEAP];
  my $popSize = 100; #Population size
  
  #----------------------------------------------------------#
  #Fitness function will be Tide
  my $funcionMarea = sub {
    my $indi = shift;
    my ( $x, $y ) = @{$indi->{_array}};
    my $sqrt = sqrt( $x*$x+$y*$y);
    
    if( !$sqrt ){ return 1; }
    return sin( $sqrt )/$sqrt;
  };
  
  #----------------------------------------------------------#
  #Initial population
  my @pop;
  #Creamos $popSize individuos
  for ( 0..$popSize ) {
    my $indi = Algorithm::Evolutionary::Individual::Vector->new( 2 );
    push( @pop, $indi );
  }
    
  #----------------------------------------------------------#
  # Variation operators
  my $m = Algorithm::Evolutionary::Op::GaussianMutation->new( 0, 0.1 );
  my $c = Algorithm::Evolutionary::Op::VectorCrossover->new(2);
  
  #----------------------------------------------------------#
  #Usamos estos operadores para definir una generación del algoritmo. Lo cual
  # no es realmente necesario ya que este algoritmo define ambos operadores por
  # defecto. Los parámetros son la función de fitness, la tasa de selección y los
  # operadores de variación.
  my $generation = Algorithm::Evolutionary::Op::Easy->new( $funcionMarea , 0.2 , [$m, $c] ) ;
  
  #----------------------------------------------------------#
  $inicioTiempo = [gettimeofday()];
  for ( @pop ) {
    if ( !defined $_->Fitness() ) {
      my $fitness = $funcionMarea->($_);
      $_->Fitness( $fitness );
    }
  }
  $heap->{'contador'} = 0;
  $heap->{'population'} = \@pop;
  $heap->{'generation'} = $generation;
  $kernel->yield("generation");
}

# #------------------------------------------------------------#

sub generation {
  my ($kernel, $heap, $session ) = @_[KERNEL, HEAP, SESSION];

  my $generation = $heap->{'generation'};
  my $population = $heap->{'population'};
  $generation->apply( $population );
  print $heap->{'contador'}, " : ", $population->[0]->asString(), "\n" ;
  if ( $heap->{'contador'} < $numGens ) {
    $poe_kernel->post( $session->ID, "generation" );
    $heap->{'contador'}++;
  } else {
    #----------------------------------------------------------#
    #leemos el mejor resultado
    my ( $x, $y ) = @{$population->[0]->{_array}};
    
    #Mostramos los resultados obtenidos
    print "El mejor es:\n\t ",$population->[0]->asString(),"\n\t x=$x \n\t y=$y \n\t Fitness: ",$population->[0]->Fitness(),"\n";
    
    print "\n\nTime: ". tv_interval( $inicioTiempo ) . "\n";
    
  }
}



=head1 AUTHOR

Contributed by Pedro Castillo Valdivieso, modified by J. J. Merelo

=cut

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/02/04 20:43:13 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/examples/tide_float_POE.pl,v 2.1 2009/02/04 20:43:13 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 2.1 $
  $Name $

=cut

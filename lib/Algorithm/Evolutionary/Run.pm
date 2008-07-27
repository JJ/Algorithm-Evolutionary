use strict; #-*-cperl-*-
use warnings;

=head1 NAME

    Algorithm::Evolutionary::Run - Class for setting up an experiment with algorithms and population
                 
=head1 SYNOPSIS
  
  use Algorithm::Evolutionary::Run;

  my $algorithm = new Algorithm::Evolutionary::Run 'conf.yaml';
  #or
  my $conf = {
    'fitness' => {
      'class' => 'MMDP'
    },
    'crossover' => {
      'priority' => '3',
      'points' => '2'
     },
    'max_generations' => '1000',
    'mutation' => {
      'priority' => '2',
      'rate' => '0.1'
    },
    'length' => '120',
    'max_fitness' => '20',
    'pop_size' => '1024',
    'selection_rate' => '0.1'
  };

  my $algorithm = new Algorithm::Evolutionary::Run $conf;

  #Run it to the end
  $algorithm->run();
  
  #Print results
  $algorithm->results();
  
  #A single step
  $algorithm->step();
  
=head1 DESCRIPTION

This is a no-fuss class to have everything needed to run an algorithm
    in a single place, although for the time being it's reduced to
    fitness functions in the A::E::F namespace, and binary
    strings. Mostly for demo purposes, but can be an example of class
    for other stuff.

=cut

=head1 METHODS

=cut

package Algorithm::Evolutionary::Run;

use Algorithm::Evolutionary::Individual::BitString;
use Algorithm::Evolutionary::Op::Easy;
use Algorithm::Evolutionary::Op::Bitflip;
use Algorithm::Evolutionary::Op::Crossover;

our $VERSION = ( '$Revision: 1.7 $ ' =~ /(\d+\.\d+)/ ) ;

use Carp;
use YAML qw(LoadFile);
use Time::HiRes qw( gettimeofday tv_interval);

=head2 new( $algorithm_description )

   Creates the whole stuff needed to run an algorithm. Can be called from a hash with t 
   options, as per the example. All of them are compulsory. See also the C<examples> subdir for examples of the YAML conf file. 

=cut

sub new {
  my $class = shift;

  my $param = shift;
  my $self;
  if ( ! ref $param ) { #scalar => read yaml file
      $self = LoadFile( $param ) || carp "Can't load $param: is it a file?\n";
  } else { #It's a hashref
      $self = $param;
  }
      
  #Initial population
  my @pop;

  #Creamos $popSize individuos
  my $bits = $self->{'length'}; 
  for ( 1..$self->{'pop_size'} ) {
      my $indi = Algorithm::Evolutionary::Individual::BitString->new( $bits );
      push( @pop, $indi );
  }
  
  
#----------------------------------------------------------#
# Variation operators
  my $m =  new Algorithm::Evolutionary::Op::Bitflip( 1, $self->{'mutation'}->{'priority'}  );
  my $c = new Algorithm::Evolutionary::Op::Crossover($self->{'mutation'}->{'points'}, $self->{'crossover'}->{'priority'} );
  
# Fitness function
  my $fitness_class = "Algorithm::Evolutionary::Fitness::".$self->{'fitness'}->{'class'};
  eval  "require $fitness_class" || die "Can't load $fitness_class: $@\n";
  my @params = $self->{'fitness'}->{'params'}? @{$self->{'fitness'}->{'params'}} : ();
  my $fitness_object = eval $fitness_class."->new( \@params )" || die "Can't instantiate $fitness_class: $@\n";
  
#----------------------------------------------------------#
#Usamos estos operadores para definir una generación del algoritmo. Lo cual
# no es realmente necesario ya que este algoritmo define ambos operadores por
# defecto. Los parámetros son la función de fitness, la tasa de selección y los
# operadores de variación.
  my $fitness = sub { $fitness_object->apply(@_) };
  
  my $generation = Algorithm::Evolutionary::Op::Easy->new( $fitness , $self->{'selection_rate'} , [$m, $c] ) ;
  
#Time
  my $inicioTiempo = [gettimeofday()];
  
#----------------------------------------------------------#
  for ( @pop ) {
      if ( !defined $_->Fitness() ) {
	  my $this_fitness = $fitness->($_);
	  $_->Fitness( $this_fitness );
      }
  }

  $self->{'_population'} = \@pop;
  $self->{'_generation'} = $generation;
  $self->{'_start_time'} = $inicioTiempo;
  $self->{'_fitness'} = $fitness_object;
  bless $self, $class;
  return $self;
}

=head2 step()

Runs a single step of the algorithm, that is, a single generation 

=cut

sub step {
    my $self = shift;
    $self->{'_generation'}->apply( $self->{'_population'} );
    $self->{'_counter'}++;
}

=head2 run()

Applies the different operators in the order that they appear; returns the population
as a ref-to-array.

=cut

sub run {
  my $self = shift;
  $self->{'_counter'} = 0;
  do {
      $self->step();
      
  } while( ($self->{'_counter'} < $self->{'max_generations'}) 
	 && ($self->{'_population'}->[0]->Fitness() < $self->{'max_fitness'}));

}

=head2 random_member()

Returns a random guy from the population

=cut

sub random_member {
    my $self = shift;
    return $self->{'_population'}->[rand( @{$self->{'_population'}} )];
}

=head2 results()
 
Returns results in a hash that contains the best, total time so far
 and the number of evaluations. 

=cut

sub results {
  my $self = shift;
  my $results = { best => $self->{'_population'}->[0],
		  time =>  tv_interval( $self->{'_start_time'} ),
		  evaluations => $self->{'_fitness'}->evaluations() };

}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/07/27 16:10:53 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Run.pm,v 1.7 2008/07/27 16:10:53 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.7 $
  $Name $

=cut

"Still there?";

#!/usr/bin/perl

=head1 NAME

  run_easy_ga.pl - Run a generic "easy" genetic algorithm

=head1 SYNOPSIS

  prompt% ./run_easy_ga.pl ga.yaml

=head1 DESCRIPTION  

Takes configuration from a YAML file, include the fitness function
    object and instantiation values, runs and times the GA, and
    produces results

=cut

use warnings;
use strict;

use Time::HiRes qw( gettimeofday tv_interval);
use YAML qw(LoadFile);

use lib qw(lib ../lib);
use Algorithm::Evolutionary::Individual::BitString;
use Algorithm::Evolutionary::Op::Easy;
use Algorithm::Evolutionary::Op::Mutation;
use Algorithm::Evolutionary::Op::Crossover;


#----------------------------------------------------------#
my $conf_file = shift || die "Usage: $0 <yaml-conf-file.yaml>\n";

my $conf = LoadFile( $conf_file ) || die "Can't open configuration file $conf_file\n";

#----------------------------------------------------------#
#Initial population
my @pop;
#Creamos $popSize individuos
my $bits = $conf->{'length'}; 
for ( 0..$conf->{'pop_size'} ) {
  my $indi = Algorithm::Evolutionary::Individual::BitString->new( $bits );
  push( @pop, $indi );
}


#----------------------------------------------------------#
# Variation operators
my $m =  new Algorithm::Evolutionary::Op::Mutation( $conf->{'mutation'}->{'rate'}, $conf->{'mutation'}->{'priority'}  );
my $c = new Algorithm::Evolutionary::Op::Crossover($conf->{'mutation'}->{'points'}, $conf->{'crossover'}->{'priority'} );

# Fitness function
my $fitness_class = "Algorithm::Evolutionary::Fitness::".$conf->{'fitness'}->{'class'};
eval  "require $fitness_class" || die "Can't load $fitness_class: $@\n";
my @params = $conf->{'fitness'}->{'params'}? @{$conf->{'fitness'}->{'params'}} : ();
my $fitness_object = eval $fitness_class."->new( \@params )" || die "Can't instantiate $fitness_class: $@\n";

#----------------------------------------------------------#
#Usamos estos operadores para definir una generación del algoritmo. Lo cual
# no es realmente necesario ya que este algoritmo define ambos operadores por
# defecto. Los parámetros son la función de fitness, la tasa de selección y los
# operadores de variación.
my $fitness = sub { $fitness_object->apply(@_) };

my $generation = Algorithm::Evolutionary::Op::Easy->new( $fitness , $conf->{'selection_rate'} , [$m, $c] ) ;

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
} while( ($contador < $conf->{'max_generations'}) 
	 && ($pop[0]->Fitness() < $conf->{'max_fitness'}));


#----------------------------------------------------------#
#leemos el mejor resultado

#Mostramos los resultados obtenidos
print "El mejor es:\n\t ",$pop[0]->asString()," Fitness: ",$pop[0]->Fitness(),"\n";

print "\n\n\tTime: ", tv_interval( $inicioTiempo ) , "\n";

print "\n\tEvaluaciones: ", $fitness_object->evaluations(), "\n";

=head1 AUTHOR

J. J. Merelo, C<jj@merelo.net>

=cut

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/02/17 17:02:55 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/examples/run_easy_ga.pl,v 1.2 2008/02/17 17:02:55 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.2 $
  $Name $

=cut

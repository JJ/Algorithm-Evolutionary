#!/usr/bin/perl

=head1 NAME

  trap.pl - Massively multimodal deceptive problem

=head1 SYNOPSIS

  prompt% ./trap.pl <population> <number of generations>

or

  prompt% perl trap.pl <population> <number of generations>

Shows fitness and best individual  
  

=head1 DESCRIPTION  

A simple example of how to run an Evolutionary algorithm based on
Algorithm::Evolutionary. Optimizes trap function.

=cut

use warnings;
use strict;
use v5.14;

use Time::HiRes qw( gettimeofday tv_interval);
use YAML qw(LoadFile);
use IO::YAML;
use DateTime;
use Config;

use lib qw(lib ../lib);
use Algorithm::Evolutionary::Individual::BitString;
use Algorithm::Evolutionary::Op::Tournament_Selection;
use Algorithm::Evolutionary::Op::Replace_Worst;
use Algorithm::Evolutionary::Op::Generation_Skeleton_Ref;
use Algorithm::Evolutionary::Op::Mutation;
use Algorithm::Evolutionary::Op::Crossover;
use Algorithm::Evolutionary::Fitness::Noisy;

use Math::Random qw(random_normal);
use Statistics::Basic qw(average);

#----------------------------------------------------------#
my $conf_file = shift || die "Usage: $0 <yaml-conf-file.yaml>\n";

my $conf = LoadFile( $conf_file ) || die "Can't open configuration file $conf_file\n";


#----------------------------------------------------------#
my $chromosome_length = $conf->{'chromosome_length'} || die "Chrom length must be explicit";
my $best_fitness = $conf->{'best_fitness'} || die "Need to know the best fitness";
my $population_size = $conf->{'population_size'} || 1024; #Population size
my $max_evals = $conf->{'max_evals'}  || 100000; #Max number of generations
my $replacement_rate = $conf->{'replacement_rate'} || 0.5;
my $tournament_size =  $conf->{'tournament_size'}|| 2;
my $mutation_priority = $conf->{'mutation_priority'} || 1;
my $crossover_priority =  $conf->{'crossover_priority'}|| 4;
my $noise_sigma = $conf->{'noise_sigma'}|| 1;

# Open output stream
#----------------------------
my $io = IO::YAML->new($conf->{'ID'}."-".DateTime->now().".yaml", ">");
$conf->{'uname'} = $Config{'myuname'}; # conf stuff
$conf->{'arch'} = $Config{'myarchname'};
$io->print( $conf );

#----------------------------------------------------------#
#Initial population
my @pop;
#Creating $population_size guys
for ( 0..$population_size ) {
  my $indi = Algorithm::Evolutionary::Individual::BitString->new( $chromosome_length );
  push( @pop, $indi );
}

#----------------------------------------------------------#
# Variation operators
my $m = Algorithm::Evolutionary::Op::Mutation->new( 0.1, $mutation_priority );
my $c = Algorithm::Evolutionary::Op::Crossover->new(2, $crossover_priority);

#----------------------------------------------------------#
# Fitness function
my $fitness_class = "Algorithm::Evolutionary::Fitness::".$conf->{'fitness'}->{'class'};
eval  "require $fitness_class" || die "Can't load $fitness_class: $@\n";
my @params = $conf->{'fitness'}->{'params'}? @{$conf->{'fitness'}->{'params'}} : ();
my $fitness_object = eval $fitness_class."->new( \@params )" || die "Can't instantiate $fitness_class: $@\n";
my $noisy = new  Algorithm::Evolutionary::Fitness::Noisy( $fitness_object,  
							sub { return random_normal(1,0, $noise_sigma);});

#----------------------------------------------------------#
# Usamos estos operadores para definir una generación del algoritmo. Lo cual
# no es realmente necesario ya que este algoritmo define ambos operadores por
# defecto. Los parámetros son la función de fitness, la tasa de selección y los
# operadores de variación.
#my $fitness = sub { $trap->apply(@_) };

my $selector = new  Algorithm::Evolutionary::Op::Tournament_Selection $tournament_size;
my $replacer = new  Algorithm::Evolutionary::Op::Replace_Worst;

my $generation = Algorithm::Evolutionary::Op::Generation_Skeleton_Ref->new( $noisy, $selector, [$m, $c], $replacement_rate , $replacer ) ;

#Time
my $inicioTiempo = [gettimeofday()];

#----------------------------------------------------------#
for my $p ( @pop ) {
  push(@{$p->{'_fitness_memory'}}, $noisy->apply( $p ));
  $p->Fitness( average( $p->{'_fitness_memory'} ) );
}

do {
  $generation->apply( \@pop );
  for my $p ( @pop ) {
    if ( ! $p->{'_fitness_memory'} ) {
      push(@{$p->{'_fitness_memory'}}, $p->{'_fitness'});
    }
    push(@{$p->{'_fitness_memory'}},  $noisy->apply( $p ));
    $p->Fitness( average( $p->{'_fitness_memory'} ) );
  }
  $io->print( { evals => $noisy->evaluations(),
		best => $pop[0] } );
} while( ($noisy->evaluations() < $max_evals) 
	 && ($pop[0]->Fitness() < $best_fitness));

#----------------------------------------------------------#
#leemos el mejor resultado

#Mostramos los resultados obtenidos
$io->print( { end => { best => $pop[0],
		     time =>tv_interval( $inicioTiempo ) , 
		     evaluations => $noisy->evaluations()}} );

=head1 AUTHOR

Contributed by Pedro Castillo Valdivieso, modified by J. J. Merelo

=cut

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

=cut

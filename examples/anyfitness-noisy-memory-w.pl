#!/usr/bin/env perl

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
use Algorithm::Evolutionary::Op::Generation_Skeleton_Ref_No_Replace;
use Algorithm::Evolutionary::Op::Mutation;
use Algorithm::Evolutionary::Op::Crossover;
use Algorithm::Evolutionary::Fitness::Noisy;

use Math::Random qw(random_normal);
use Statistics::ANOVA;
use Sort::Key qw( rnkeysort);


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
my $comparisons = $conf->{'comparisons'} || 10;

# Open output stream
#----------------------------
my $ID="res-afnmw-p". $population_size."-ns". $noise_sigma."-cs".$chromosome_length."-rr".$replacement_rate;
my $io = IO::YAML->new("$ID-".DateTime->now().".yaml", ">");
$conf->{'uname'} = $Config{'myuname'}; # conf stuff
$conf->{'arch'} = $Config{'myarchname'};
$io->print( $conf );

#----------------------------------------------------------#
#Initial population
my @pop;
#Creating $population_size guys
for ( 1..$population_size ) {
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

my $generation = Algorithm::Evolutionary::Op::Generation_Skeleton_Ref_No_Replace->new( $noisy, $selector, [$m, $c], $replacement_rate , $replacer ) ;

#Time
my $inicioTiempo = [gettimeofday()];

#Initial memory assignment to feed the Wilcoxon test
for my $p ( @pop ) {
  push(@{$p->{'_fitness_memory'}},  $noisy->apply( $p ));
}
#----------------------------------------------------------#
my $best_found; #Found solution flag
my @best_guys; #Keeping them for printing
do {
  for my $p ( @pop ) {
    push(@{$p->{'_fitness_memory'}},  $noisy->apply( $p ));
    $p->Fitness($comparisons);
  }
  
  wilcoxon_compare( $comparisons, \@pop );
  @pop = rnkeysort { $_->{'_fitness'} } @pop ; 
  my $best_guy = $pop[0]; # Provisional value
  @best_guys =();
  my $i = 0;
  while ( $pop[$i]->Fitness() == $pop[0]->Fitness() && !$best_found ) {
    push @best_guys, $pop[$i];
    if (  $fitness_object->apply($pop[$i]) >= $best_fitness ) {
      say "Fitness ", $fitness_object->apply($pop[$i]);
      $best_guy = $pop[$i];
      $best_found = 1;
    } else {
      $i++;
    }
  }
  $io->print( { evals => $noisy->evaluations(),
		best => \@best_guys } );
  if ( !$best_found ) {
    # Apply the evolutionary algorithm now we've got all evaluated
    my $new_population = $generation->apply( \@pop );
    splice( @pop, - scalar( @$new_population ) ); # Incorporate always
    push @pop, @$new_population;
  }

} while( ($noisy->evaluations() < $max_evals) && !$best_found);

#----------------------------------------------------------#
#leemos el mejor resultado

#Mostramos los resultados obtenidos
$io->print( { end => { best => \@best_guys,
		     time =>tv_interval( $inicioTiempo ) , 
		     evaluations => $noisy->evaluations()}} );

#-----------------------------------------------------------
# Functions here
#----------------------------------------------------------
sub wilcoxon_compare {
  my $comparisons = shift;
  my $population = shift;
  for my $i (1..$comparisons) {
    my @copy_of_population = @$population;
    while( @copy_of_population ) {
	my $first = splice( @copy_of_population, rand( @copy_of_population ), 1 );
	my $second = splice( @copy_of_population, rand( @copy_of_population ), 1 );
	my $aov = Statistics::ANOVA->new();
#	say @{$first->{'_fitness_memory'}}, @{$second->{'_fitness_memory'} };
	$aov->load_data( { 1 => $first->{'_fitness_memory'}, 2 => $second->{'_fitness_memory'} });
	my $test_value = $aov->compare(independent => 1, parametric => 0, flag => 1, alpha => .05, dump => 0); # Wilcoxon (between-groups) sum-of-ranks (Dwass Procedure)
	if ( $test_value->{'1,2'}{'p_value'} < 0.05 ) {
	  if ( $test_value->{'1,2'}{'z_value'} < 0 ) {
	    $first->Fitness( $first->Fitness( ) + 1);
	    $second->Fitness( $second->Fitness( ) - 1);
	  } else {
	    $first->Fitness( $first->Fitness( ) - 1);
	    $second->Fitness( $second->Fitness( ) + 1);
	  }
	}
      }
  }
}


=head1 AUTHOR

Contributed initially by Pedro Castillo Valdivieso, modified by J. J. Merelo

=cut

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

=cut

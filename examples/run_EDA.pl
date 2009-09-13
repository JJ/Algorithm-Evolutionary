#!/usr/bin/perl

=head1 NAME

  run_easy_ga.pl - Run a generic "easy" genetic algorithm

=head1 SYNOPSIS

  prompt% ./run_EDA.pl eda.yaml

=head1 DESCRIPTION  

Takes configuration from a YAML file, include the fitness function
    object and instantiation values, runs and times the EDA, and
    produces results

=cut

use warnings;
use strict;

use Time::HiRes qw( gettimeofday tv_interval);
use YAML qw(LoadFile);

use lib qw(lib ../lib);
use Algorithm::Evolutionary qw( Individual::BitString
				Op::EDA_step );


#----------------------------------------------------------#
my $conf_file = shift || die "Usage: $0 <yaml-conf-file.yaml>\n";

my $conf = LoadFile( $conf_file ) || die "Can't open configuration file $conf_file\n";

#----------------------------------------------------------#
#Creation of initial population
my @pop;
my $bits = $conf->{'length'}; 
for ( 0..$conf->{'pop_size'} ) {
  my $indi = Algorithm::Evolutionary::Individual::BitString->new( $bits );
  push( @pop, $indi );
}

#----------------------------------------------------------#
# Fitness function
my $fitness_class = "Algorithm::Evolutionary::Fitness::".$conf->{'fitness'}->{'class'};
eval  "require $fitness_class" || die "Can't load $fitness_class: $@\n";
my @params = $conf->{'fitness'}->{'params'}? @{$conf->{'fitness'}->{'params'}} : ();
my $fitness_object = eval $fitness_class."->new( \@params )" || die "Can't instantiate $fitness_class: $@\n";

#----------------------------------------------------------#
#
my $fitness = sub { $fitness_object->apply(@_) };

#EDA itself
my $eda = new Algorithm::Evolutionary::Op::EDA_step( $fitness, 
						     $conf->{'replacement_rate'},
						     $conf->{'pop_size'} );
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
  $eda->apply( \@pop );

  print "$contador : ", $pop[0]->asString(), "\n" ;

  $contador++;
} while( ($contador < $conf->{'max_generations'}) 
	 && ($pop[0]->Fitness() < $conf->{'max_fitness'}));


#----------------------------------------------------------#
#Read and show the best result

print "Best is:\n\t ",$pop[0]->asString()," Fitness: ",$pop[0]->Fitness(),"\n";

print "\n\n\tTime: ", tv_interval( $inicioTiempo ) , "\n";

print "\n\tEvaluations: ", $fitness_object->evaluations(), "\n";

=head1 AUTHOR

J. J. Merelo, C<jj@merelo.net>

=cut

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/09/13 09:04:52 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/examples/run_EDA.pl,v 1.1 2009/09/13 09:04:52 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $
  $Name $

=cut

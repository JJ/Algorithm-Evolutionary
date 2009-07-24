#!/usr/bin/perl

=head1 NAME

  async.pl - Two-population fake-parallel genetic algorithm

=head1 SYNOPSIS

  prompt% ./async.pl params.yaml conf.yaml


=head1 DESCRIPTION  

A somewhat more complex  example of how to run a Evolutionary algorithm based on
Algorithm::Evolutionary. See L<Algorithm::Evolutionary::Run> for param structure. It works for the time being only on A::E::Fitness namespace fitness functions.

=cut

use warnings;
use strict;

use lib qw(lib ../lib);
use Algorithm::Evolutionary::Run;
use Algorithm::Evolutionary::Fitness::Trap;

use POE;
use YAML qw(Dump LoadFile);
use IO::YAML;
use DateTime;

my @methods= ([3,16], [3,32],  
	      [4,16], [4,32] );
	      
my $spec_file = shift || die "Usage: $0 params.yaml\n";
my %best; # Keeps the best of the target population
my $spec = LoadFile( $spec_file) || die "Can't open $spec_file: $@\n";
my ($spec_name) = ( $spec_file =~ /([^.]+)\.yaml/);
my $initial_population = $spec->{'pop_size'};
my $experiments = $spec->{'experiments'} || 3;
my $last_evals;

#Load fitness object
my $fitness_spec = $spec->{'fitness'};
my $fitness_class = "Algorithm::Evolutionary::Fitness::".$fitness_spec->{'class'};
eval  "require $fitness_class" || die "Can't load $fitness_class: $@\n";
my @nodes;

my $sessions = 2;
for my $method ( @methods ) {
  my $trap_size = $method->[0];
  my $number_of_traps = $method->[1];
  my $fitness_object = new Algorithm::Evolutionary::Fitness::Trap $trap_size;
  my $this_population = $initial_population/$sessions;
  $spec->{'length'} = $number_of_traps;
  for my $s2 ( qw( 10 20 30 40 50 60 ) ) {
    $spec->{'start_population_2'} = $s2;
    my $algorithm =  new Algorithm::Evolutionary::Run $spec, $fitness_object;
    $algorithm->population_size($this_population);
    print "Starting $trap_size $number_of_traps\n";
    my $io = IO::YAML->new("$spec_name-s$s2-$trap_size-$number_of_traps.yaml", ">");
    for my $i ( 1..$experiments ) {
      print "\t$i\n";
      #	$io->print( [ now(), 'Start' ]);
      my $data_hash = { Start => now() };
      for my $s (1..$sessions) { # Two nodes
	POE::Session->create(inline_states => { _start => \&start,
						generation => \&generation,
						finish => \&finishing},
			     args  => [$s, $io, $algorithm,
					 $data_hash]
			      );
	}
	  
	#Timer
	  
	$poe_kernel->post( "Population 1", "generation", "Population 2"); #First, function and next generation
	  
	$poe_kernel->run();
	$io->print( $data_hash ) ;
	#	$io->print( [ now(), "Exiting" ]);
	  
      }
      $io->close() || die "Can't close: $@";
    }
}
exit(0);

sub now {
  my $now = DateTime->now();
  return $now->ymd."T".$now->hms;
}
#----------------------------------------------------------#

sub start {
  my ($kernel, $heap, $session, 
      $io, $algorithm, 
      $data_hashref) = 
    @_[KERNEL, HEAP, ARG0, ARG1, ARG2, ARG3];
  $kernel->alias_set("Population $session");
  $heap->{'algorithm'} = $algorithm;
  $algorithm->reset_population; # Restarts population
  $heap->{'io'} = $io;
  $heap->{'counter'} = 0;
  $data_hashref->{'running'} = [];
  $data_hashref->{'finish'} = [];
  $heap->{'data_hashref'} = $data_hashref;
}

#------------------------------------------------------------#

sub generation {
  my ($kernel, $heap, $session, $next, $other_best ) = @_[KERNEL, HEAP, SESSION, ARG0, ARG1];
  my $alias =  $kernel->alias_list($session);
  my $algorithm = $heap->{'algorithm'};
  my @data = ( now(), $alias );
  
  if ( $other_best && $heap->{'counter'}) {
    push @data, { 'receiving' => $other_best };
    pop @{$algorithm->{'_population'}};
    push @{$algorithm->{'_population'}}, $other_best;
  }
  $algorithm->run();
  my $best = $algorithm->results()->{'best'};
  push @data, {'best' => $best };
  my $these_evals = $heap->{'algorithm'}->results()->{'evaluations'};
  if ( ( $best->Fitness() < $algorithm->{'max_fitness'} ) 
       && ( ($these_evals + $last_evals) < $spec->{'max_evals'} ) ) {
      if ( ($alias eq 'Population 1') && ( $heap->{'counter'} < $spec->{'start_pop_2'}) ) {
	  $kernel->post( $alias, 'generation', "Population 2" );
      } else {
	  $kernel->post($next, 'generation', $session->ID, $best );    
	  $last_evals = $these_evals;
      }
  } else {
    $kernel->post($session->ID, 'finish');
    $kernel->post($next, 'finish');
  }
  $heap->{'counter'}++;
  $io->print( \@data );
}

sub finishing {
  my $heap   = $_[ HEAP ];
  $io->print( [now(), { Finish => $heap->{'algorithm'}->results }] ) ;
}

=head1 AUTHOR

J. J. Merelo C<jj@merelo.net>

=cut

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/07/24 08:46:58 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/examples/async/async.pl,v 3.0 2009/07/24 08:46:58 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 3.0 $
  $Name $

=cut

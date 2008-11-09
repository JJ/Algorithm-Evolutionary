#!/usr/bin/perl

=head1 NAME

  multikulti-experiment.pl - Seudoparallel implementation of the multikulti algorithm with variants

=head1 SYNOPSIS

  prompt% ./multikulti-experiment.pl params.yaml


=head1 DESCRIPTION  

Implementation of the multikulti algorithm, submitted to PPSN (for the time being)

=cut

use warnings;
use strict;

use lib qw(../../lib ../lib  ../../../../lib );
use Algorithm::Evolutionary::Run;
use Algorithm::Evolutionary::Utils qw(entropy consensus);

use POE;
use YAML qw(Dump LoadFile);
use IO::YAML;
use DateTime;

#my @methods= ('random','best','multikulti' );
my @methods= ('multikulti' );
	      
my $spec_file = shift || die "Usage: $0 params.yaml\n";
my %last_good; #
my $spec = LoadFile( $spec_file) || die "Can't open $spec_file: $@\n";
my ($spec_name) = ( $spec_file =~ /([^.]+)\.yaml/);
my $initial_population = $spec->{'pop_size'};
my $experiments = $spec->{'experiments'} || 3;

#Load fitness object
my $fitness_spec = $spec->{'fitness'};
my $fitness_class = "Algorithm::Evolutionary::Fitness::".$fitness_spec->{'class'};
eval  "require $fitness_class" || die "Can't load $fitness_class: $@\n";
my @params = $fitness_spec->{'params'}? @{$fitness_spec->{'params'}} : ();
my $fitness_object = eval $fitness_class."->new( \@params )" || die "Can't instantiate $fitness_class: $@\n";
my @nodes;
if ( $spec->{'nodes'} ) {
  @nodes = @{$spec->{'nodes'}}
} else {
  @nodes = qw( 2 4 8 );
}
for my $migration_policy ( @methods ) {
    for my $sessions ( @nodes ) {
      my $this_population = $initial_population/$sessions;
      my $algorithm =  new Algorithm::Evolutionary::Run $spec, $fitness_object;
      $algorithm->population_size($this_population);
      print "Starting $migration_policy $sessions sessions\n";
      my $io = IO::YAML->new("$spec_name-s$sessions-$migration_policy.yaml", ">");
      for my $i ( 1..$experiments ) {
	print "\t$i\n";
	my $data_hash = { Start => now() };
	for my $s (1..$sessions) {
	  POE::Session->create(inline_states => { _start => \&start,
						  generation => \&generation,
						  finish => \&finishing},
			       args  => [$sessions, $s, $io, $algorithm,
					 $migration_policy, 
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
    
#----------------------------------------------------------#
sub now {
  my $now = DateTime->now();
  return $now->ymd."T".$now->hms;
}
#----------------------------------------------------------#

sub start {
  my ($kernel, $heap, $sessions, $session, 
      $io, $algorithm, $migration_policy, 
      $data_hashref) = 
    @_[KERNEL, HEAP, ARG0, ARG1, ARG2, ARG3, ARG4, ARG5,ARG6];
  $kernel->alias_set("Population $session");
  $heap->{'algorithm'} = $algorithm;
  $algorithm->reset_population; # Restarts population
  $heap->{'sessions'} = $sessions;
  $heap->{'io'} = $io;
  $heap->{'counter'} = 0;
  $heap->{'migration_policy'} = $migration_policy;
  $data_hashref->{'running'} = [];
  $data_hashref->{'finish'} = [];
  $heap->{'data_hashref'} = $data_hashref;
}

#------------------------------------------------------------#

sub generation {
  my ($kernel, $heap, $session, $next, $other_best ) = @_[KERNEL, HEAP, SESSION, ARG0, ARG1];
  my $alias =  $kernel->alias_list($session);
  my $algorithm = $heap->{'algorithm'};
  my $sessions = $heap->{'sessions'};
  my @data = ( now(), $alias );
  $algorithm->run();
  my $population = $heap->{'algorithm'}->{'_population'};
  my $match;
  $last_good{$alias} = $algorithm->results()->{'last_good'}; #Keep for other
  
  my $these_evals = $heap->{'algorithm'}->results()->{'evaluations'};
  my ($idx) = ($next =~ /Population (\d+)/);
  my $after_punk = "Population ".($idx+1) ;
  if ( $after_punk gt "Population $sessions" ) {
    $after_punk = "Population 1";
  }

  #Decide who to send
  my $somebody;
  my $migration_policy = $heap->{'migration_policy'};
  my $best = $algorithm->results()->{'best'};
  if (  $migration_policy eq 'random' ) {
      $somebody = [$algorithm->random_member()];
  } elsif (  $migration_policy eq 'best' ) {
      $somebody = [ $best ];
  } elsif (  $migration_policy eq 'multikulti' ) {
    if ( !$last_good{$next} ) {
      $somebody = [$algorithm->random_member()];
    } else {
      $somebody = [];
      my $counter;
      my @this_population = $algorithm->evaluated_population();
      my $loser;
      do {
	$loser = pop @this_population;
      } while ( ($loser->Fitness() < $last_good{$next}->Fitness())
		&& @this_population );

      if ( @this_population ) {
	for ( my $i = 0; $i < $spec->{'max_generations'}; $i++ ) {
	  my $offset = rand( $#this_population );
	  my $new_guy = splice( @this_population, $offset, 1 );
	  push @$somebody, $new_guy ;
	}; 
      }
    }
  }
  push @data, {'sending' => $somebody };
  push @data, {'best' => $best };
  push @data, {'entropy' => entropy( $population ) };
  if ( ( $best->Fitness() < $algorithm->{'max_fitness'} ) 
       && ( ($these_evals) < $spec->{'max_evals'} ) ) {
      $kernel->post($next, 'generation', $after_punk , $somebody );
  } else {
    for( my $s = 1; $s <= $sessions; $s ++ ) {
      $kernel->post("Population $s", 'finish');
    }
  }

  #Incorporate at the end, as if it were asynchronous
  if ( $other_best && $heap->{'counter'}) {
    pop @{$algorithm->{'_population'}};
    if ( $migration_policy eq 'best' || $migration_policy eq 'random' ) {
      push @data, { 'receiving' => $other_best->[0] };
      push @{$algorithm->{'_population'}}, $other_best->[0];
    } else {
      my $max_distance = 0;
      my $most_different;
      for my $i ( @$other_best ) {
	my $this_distance = $algorithm->compute_average_distance($i);
	if ( $this_distance > $max_distance ) {
	  $max_distance = $this_distance;
	  $most_different = $i;
	}
      }
      push @data, {'choosing' => [$most_different, $max_distance] };
      push @{$algorithm->{'_population'}}, $most_different;
    }
  }
  $heap->{'counter'}++;
  push @{$heap->{'data_hashref'}->{'running'}}, \@data;

}

sub finishing {
  my ($kernel, $heap,$session)   = @_[ KERNEL, HEAP, SESSION ];
  my $alias =  $kernel->alias_list($session);
  push @{$heap->{'data_hashref'}->{'finish'}}, [ $alias, now(),  $heap->{'algorithm'}->results ];
}

=head2 hamming

Computes the number of positions that are different among two strings

=cut

sub hamming {
    my ($string_a, $string_b) = @_;
    return ( ( $string_a ^ $string_b ) =~ tr/\1//);
}


=head2 worst_match 

Computes the worst match of the population

=cut

sub worst_match {
    my $population = shift || die "No population\n";
    my $matchee = shift || die "No matchee";
    if ( !ref $matchee ) {
      $matchee = { _str => $matchee }
    }
    my $distance = 0;
    my $vive_la;
    for my $p (@$population) {
	my $this_distance = hamming( $p->{'_str'}, $matchee->{'_str'} );
	if ($this_distance > $distance ) {
	    $vive_la = $p;
	    $distance = $this_distance;
	}
    }
    return $vive_la;
}

=head1 AUTHOR

J. J. Merelo C<jj@merelo.net>

=cut

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/11/09 08:37:59 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/examples/multikulti-2.0/multikulti-experiment-v2.pl,v 1.2 2008/11/09 08:37:59 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.2 $
  $Name $

=cut

#!/usr/bin/perl

=head1 NAME

  multikulti-experiment.pl - Seudoparallel implementation of the multikulti algorithm with variants

=head1 SYNOPSIS

  prompt% ./multikulti-experiment.pl params.yaml conf.yaml


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

my @methods= (['random','none'],['best','none'],
	      ['multikulti','best'], ['multikulti','consensus'], 
	      ['multikulti-elite','best'], ['multikulti-elite','consensus'] );
	      
my $spec_file = shift || die "Usage: $0 params.yaml\n";
my %best;
my $spec = LoadFile( $spec_file) || die "Can't open $spec_file: $@\n";
my $algorithm =  new Algorithm::Evolutionary::Run $spec;
my ($spec_name) = ( $spec_file =~ /([^.]+)\.yaml/);
my $initial_population = $spec->{'pop_size'};
for my $method ( @methods ) {
    my $migration_policy = $method->[0];
    my $match_policy = $method->[1];
    for my $sessions ( qw (2 4 8 ) ) {
      my $this_population = $initial_population/$sessions;
      $algorithm->population_size($this_population);
      print "Starting $migration_policy $match_policy $sessions sessions\n";
      my $io = IO::YAML->new("$spec_name-s$sessions-$migration_policy-$match_policy.yaml", ">");
      for my $i ( 1..5 ) {
	print "\t$i\n";
#	$io->print( [ now(), 'Start' ]);
	my %data_hash = { Start => now() };
	for my $s (1..$sessions) {
	  POE::Session->create(inline_states => { _start => \&start,
						  generation => \&generation,
						  finish => \&finishing},
			       args  => [$sessions, $s, $io, $algorithm,
					 $migration_policy, $match_policy,
					 \%data_hash]
			      );
	}
	    
	#Timer
	
	$poe_kernel->post( "Population 1", "generation", "Population 2"); #First, function and next generation
	
	$poe_kernel->run();
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
      $io, $algorithm, $migration_policy, $match_policy,
      $data_hashref) = 
    @_[KERNEL, HEAP, ARG0, ARG1, ARG2, ARG3, ARG4, ARG5];
  $kernel->alias_set("Population $session");
  $heap->{'algorithm'} = $algorithm;
  $algorithm->reset_population; # Restarts population
  $heap->{'sessions'} = $sessions;
  $heap->{'io'} = $io;
  $heap->{'counter'} = 0;
  $heap->{'migration_policy'} = $migration_policy;
  $heap->{'match_policy'} = $match_policy;
  $data_hashref->{'running'} = [];
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
  my $best = $algorithm->results()->{'best'};
  if ( $heap->{'match_policy'} eq 'consensus' ) {
      $match = consensus( $population );
  } else {
      $match = $best;
  }
  $best{$alias} = $match;
  
  my $these_evals = $heap->{'algorithm'}->results()->{'evaluations'};
  my ($idx) = ($next =~ /Population (\d+)/);
  my $after_punk = "Population ".($idx+1) ;
  if ( $after_punk gt "Population $sessions" ) {
    $after_punk = "Population 1";
  }

  #Decide who to send
  my $somebody;
  my $migration_policy = $heap->{'migration_policy'};
  if ( $migration_policy eq 'multikulti' ) {
      if ( $best{$next} ) {
	  $somebody = worst_match( $population, $best{$next});
      } else {
	  $somebody = $algorithm->random_member();
      }
  } elsif (  $migration_policy eq 'random' ) {
      $somebody = $algorithm->random_member();
  } elsif (  $migration_policy eq 'best' ) {
      $somebody = $best;
  } elsif (  $migration_policy eq 'multikulti-elite' ) {
    if ( $best{$next} ) {
      my @population = @$population;
      my @population_elite = @population[0..(@population/2)];
      $somebody = worst_match( \@population_elite, $best{$next});
    } else {
      $somebody = $algorithm->random_member();
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
      push @data, { 'receiving' => $other_best };
      pop @{$algorithm->{'_population'}};
      push @{$algorithm->{'_population'}}, $other_best;
  }
  $heap->{'counter'}++;
  push @{$heap->{'data_hashref'}->{'running'}}, \@data;
#  $heap->{'io'}->print( \@data );
}

sub finishing {
  my $heap   = $_[ HEAP ];
  $heap->{'data_hashref'}->{'finish'} = [ now(),  $heap->{'algorithm'}->results ];
  $heap->{'io'}->print( %{$heap->{'data_hashref'}} ) ;
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

  CVS Info: $Date: 2008/10/28 13:33:24 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/examples/multikulti/multikulti-experiment.pl,v 1.5 2008/10/28 13:33:24 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.5 $
  $Name $

=cut

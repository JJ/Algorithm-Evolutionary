#!/usr/bin/perl

=head1 NAME

  fake_parallel_ga.pl - Two-population fake-parallel genetic algorithm

=head1 SYNOPSIS

  prompt% ./fake_parallel_ga.pl params.yaml


=head1 DESCRIPTION  

A simple example of how to run a Evolutionary algorithm based on
Algorithm::Evolutionary. See L<Algorithm::Evolutionary::Run> for param structure. It works for the time being only on A::E::Fitness namespace fitness functions.

=cut

use warnings;
use strict;

use lib qw(lib ../lib);
use Algorithm::Evolutionary::Run;

use POE;
use YAML qw(Dump);

my $params = shift || die "Usage: $0 params.yaml\n";

for my $s (1..2) {
  POE::Session->create(inline_states => { _start => \&start,
					  generation => \&generation},
		       args  => [$s]
		       );
}

print "Running kernel\n";

#Time
$poe_kernel->post( "Population 1", "generation", "Population 2");
$poe_kernel->run();
print "Exiting\n";
exit(0);


#----------------------------------------------------------#

sub start {
  my ($kernel, $heap, $session ) = @_[KERNEL, HEAP, ARG0];
  $kernel->alias_set("Population $session");
  my $algorithm =  new Algorithm::Evolutionary::Run $params;
  $heap->{'algorithm'} = $algorithm;
  $heap->{'counter'} = 0;
}

#------------------------------------------------------------#

sub generation {
  my ($kernel, $heap, $session, $next, $other_best ) = @_[KERNEL, HEAP, SESSION, ARG0, ARG1];

  my $alias =  $kernel->alias_list($session);
  my $algorithm = $heap->{'algorithm'};
  if ( $other_best ) {
    print "\tReceiving ", $other_best->asString(), "\n";
    pop @{$algorithm->{'_population'}};
    push @{$algorithm->{'_population'}}, $other_best;
  }
  $algorithm->run();
  my $best = $algorithm->results()->{'best'};
  print $alias, " : ", $best->asString(), "\n";
  if ( ( $best->Fitness() < $algorithm->{'max_fitness'} ) 
       && ( $heap->{'counter'}++ < 60 ) ) {
    $kernel->post($next, 'generation', $session->ID, $best );
  } else {
    print "Terminamos : ", Dump( $algorithm->results );
  }
}



=head1 AUTHOR

J. J. Merelo C<jj@merelo.net>

=cut

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/02/17 18:01:48 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/examples/fake-parallel-ga.pl,v 1.1 2008/02/17 18:01:48 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $
  $Name $

=cut

use strict; #-*-cperl-*-
use warnings;

=head1 NAME

Algorithm::Evolutionary::Op::Replace_Worst - Incorporate an individual into the population replacing the worst one

=head1 SYNOPSIS

  my $op = new Algorithm::Evolutionary::Op::Novelty_Mutation $ref_to_population_hash; #The population hash can be obtained from some fitness functions

=head1 Base Class

L<Algorithm::Evolutionary::Op::Base|Algorithm::Evolutionary::Op::Base>

=head1 DESCRIPTION

Attempts all possible mutations in order, until a "novelty" individual
is found. Generated individuals are checked against the population
hash, and discarded if they are already in the population.

=head1 METHODS 

=cut

package Algorithm::Evolutionary::Op::Replace_Worst;

our ($VERSION) = ( '$Revision: 2.1 $ ' =~ /(\d+\.\d+)/ );

use Carp;

use base 'Algorithm::Evolutionary::Op::Base';

#Class-wide constants
our $ARITY = 1;

=head2 new()

Does nothing, really

=cut

sub new {
  my $class = shift;
  my $self = {}; # Create a reference
  bless $self, $class; # And bless it
  return $self;
}

=head2 apply( $population, $chromosome_list )

    Eliminates the worst individuals in the population, replacing them by the list of new chromosomes. The population must be evaluated, but there's no need to have it sorted in advance. 

=cut

sub apply ($;$){
  my $self = shift;
  my $population = shift || croak "No population here!";
  my $chromosome_list = shift || croak "No new population here!";
  
  #Sort
  my @sorted_population = sort { $b->{_fitness} <=> $a->{_fitness}; }
    @$population ;
  my $to_eliminate = scalar @$chromosome_list;
  splice ( @sorted_population, - $to_eliminate, $to_eliminate );
  push @sorted_population, @$chromosome_list;

  return \@sorted_population;
  

}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/02/09 10:05:06 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Op/Replace_Worst.pm,v 2.1 2009/02/09 10:05:06 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 2.1 $
  $Name $

=cut


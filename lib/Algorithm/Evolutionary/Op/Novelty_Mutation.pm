use strict; #-*-cperl-*-
use warnings;

=head1 NAME

  Algorithm::Evolutionary::Op::Novelty_Mutation - Mutation guaranteeing new individual is not in the population

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

package Algorithm::Evolutionary::Op::Novelty_Mutation;

our ($VERSION) = ( '$Revision: 2.1 $ ' =~ /(\d+\.\d+)/ );

use Carp;
use Clone::Fast qw(clone);

use Algorithm::Evolutionary::Op::Base;
our @ISA = qw(Algorithm::Evolutionary::Op::Base);

#Class-wide constants
our $ARITY = 1;

=head2 new( [$ref_to_population_hash] [,$priority] )

Creates a new mutation operator with an operator application rate
(general for all ops), which defaults to 1, and stores the reference
to population hash.

=cut

sub new {
  my $class = shift;
  my $ref_to_population_hash = shift || croak "No pop hash here, fella!"; 
  my $rate = shift || 1;

  my $hash = { population_hashref => $ref_to_population_hash };
  my $self = Algorithm::Evolutionary::Op::Base::new( 'Algorithm::Evolutionary::Op::Novelty_Mutation', $rate, $hash );
  return $self;
}

=head2 apply( $chromosome )

Applies mutation operator to a "Chromosome", a bitstring, really. Can be
applied only to I<victims> composed of [0,1] atoms, independently of representation; but 
it checks before application that the operand is of type
L<BitString|Algorithm::Evolutionary::Individual::BitString>.

=cut

sub apply ($;$){
  my $self = shift;
  my $arg = shift || croak "No victim here!";
#  my $victim = $arg->clone();
  my $test_clone; 
  my $size =  $arg->size();
  for ( my $i = 0; $i < $size; $i++ ) {
    if ( (ref $arg ) =~ /BitString/ ) {
      $test_clone = clone( $arg );
    } else {
      $test_clone = $arg->clone();
    }
    $test_clone->Atom( $i, $test_clone->Atom( $i )?0:1 );
    last if !$self->{'_population_hashref'}->{$test_clone->Chrom()};
  }
  if ( $test_clone->Chrom() eq $arg->Chrom() ) { # Nothing done, zap
    for ( my $i = 0; $i < $size; $i++ ) {
      $test_clone->Atom( $i, (rand(100)>50)?0:1 );
    }
  }
  $test_clone->{'_fitness'} = undef ;
  return $test_clone;
}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/02/04 20:43:14 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Op/Novelty_Mutation.pm,v 2.1 2009/02/04 20:43:14 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 2.1 $
  $Name $

=cut


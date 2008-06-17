use strict; # -*- cperl -*-
use warnings;


=head1 NAME

    Algorithm::Evolutionary::Fitness::Knapsack - Fitness function for the knapsack problem

=head1 SYNOPSIS

    my $n_max=100;  #Max. number of elements to choose
    my $capacity=286; #Max. Capacity of the knapsack
    my $rho=5.0625; #Penalty coeficient
    my @profits = qw( 1..100 );
    my @weights = qw( 2.. 101 );

    my $knapsack = Algorithm::Evolutionary::Fitness::Knapsack->new( $n_max, $capacity, $rho, \@profits, \@weights ); 

=head1 DESCRIPTION

    Knapsack function with penalties applied in a particular way.

=head1 METHODS

=cut

package Algorithm::Evolutionary::Fitness::Knapsack;

use Carp qw( croak );
use base qw(Algorithm::Evolutionary::Fitness::Base);

=head2 new

    Creates a new instance of the problem, with the said number of bits and peaks

=cut 

sub new {
  my $class = shift;
  my ( $n_max, $capacity, $rho, $profits_ref, $weights_ref ) = @_;

   if ( ((scalar @$profits_ref) != $n_max ) ||
	((scalar @$weights_ref) != $n_max ) ) {
     croak "Wrong number of profits";
   }

   if ( (scalar @$profits_ref) != ( scalar @$weights_ref ) ) {
     croak "Profits and weights differ";
   }

  #Generate peaks
  my $self = { capacity => $capacity,
	       rho => $rho,
	       profits => $profits_ref,
	       weights => $weights_ref};
  bless $self, $class;
  $self->initialize();
  return $self;
}

=head2 _apply

Applies the instantiated problem to a chromosome

=cut

sub _apply {
    my $self = shift;
    my $individual = shift;
    return  $self->knapsack( $individual->{_str});
}

=head2 knapsack

    Applies the knapsack problem to the string, using a penalty function

=cut

our %cache;

sub knapsack {
    my $self = shift;
    my $string = shift;

    if ( $cache{$string} ) {
	return $cache{$string};
    }
    my $profit=0.0;
    my $weight=0.0;
    
    my @profits = @{$self->{'profits'}};
    my @weights = @{$self->{'weights'}};

    for (my $i=0 ; $i < length($string); $i++) {   #Compute weight
      my $this_bit=substr ($string, $i, 1);
      
      if ($this_bit == 1)  {
        $profit = $profit + $profits[$i];
        $weight = $weight + $weights[$i];
      }
    }
    
    if ($weight > $self->{'capacity'}) { # Apply penalty
      my $penalty = $self->{'rho'} * ($weight - $self->{'capacity'});
      $profit = $profit - ( $penalty + log(1.0 + $penalty) / log(2.0) );
    }

    #Y devolvemos la ganancia calculada
    $cache{$string} = $profit;
    return $profit;
}

=head2 cached_evals

Returns the number of keys in the evaluation cache

=cut

sub cached_evals {
    return scalar keys %cache;
}



=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/06/17 11:38:36 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Fitness/Knapsack.pm,v 1.1 2008/06/17 11:38:36 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $
  $Name $

=cut

"What???";

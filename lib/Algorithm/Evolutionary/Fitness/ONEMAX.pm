use strict; # -*- cperl -*-
use warnings;


=head1 NAME

    Algorithm::Evolutionary::Fitness::ONEMAX - Fitness function for the knapsack problem

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

package Algorithm::Evolutionary::Fitness::ONEMAX;

our $VERSION = ( '$Revision: 1.1 $ ' =~ /(\d+\.\d+)/ ) ;

use Carp qw( croak );
use base qw(Algorithm::Evolutionary::Fitness::Base);


=head2 _apply

Applies the instantiated problem to a chromosome

=cut

sub _apply {
    my $self = shift;
    my $individual = shift;
    return  $self->onemax( $individual->{_str});
}

=head2 onemax

    Computes the number of ones

=cut

our %cache;

sub onemax {
    my $self = shift;
    my $string = shift;

    if ( $cache{$string} ) {
	return $cache{$string};
    }
    my $num_ones;
    while ( $string ) {
      $num_ones += chop( $string );
    }
    $cache{$string} = $num_ones;
    return $num_ones;
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

  CVS Info: $Date: 2008/06/21 11:15:16 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Fitness/ONEMAX.pm,v 1.1 2008/06/21 11:15:16 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $
  $Name $

=cut

"What???";

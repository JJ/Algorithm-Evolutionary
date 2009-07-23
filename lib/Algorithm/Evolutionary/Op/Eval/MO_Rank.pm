use strict;
use warnings;

=head1 NAME

Algorithm::Evolutionary::Op::Eval::MO_Rank - Multiobjective evaluator
                                             based on Pareto rank

=head1 SYNOPSIS

=head1 Base Class

L<Algorithm::Evolutionary::Op::Base>

=head1 DESCRIPTION

After evaluating the population, it's ranked according to the Pareto
fron they're in

=head1 METHODS

=cut

package Algorithm::Evolutionary::Op::Eval::MO_Rank;

use lib qw(../../../..);



use Carp;

use base 'Algorithm::Evolutionary::Op::Base';

use Algorithm::Evolutionary::Utils qw(vector_compare);

# Class-wide constants
our $APPLIESTO =  'ARRAY';
our $ARITY = 1;

=head2 new( $evaluation_function )

Creates an evaluator object

=cut

sub new {
  my $class = shift;
  my $self = {};
  $self->{'_eval'} = shift || croak "No eval function found";
  bless $self, $class;
  return $self;
}


=head2 set( $ref_to_params_hash, $ref_to_code_hash, $ref_to_operators_hash )

Sets the instance variables. Takes a ref-to-hash as input. Not
intended to be used from outside the class. This should go to base,
probably. 

=cut

sub set {
  my $self = shift;
  my $hashref = shift || croak "No params here";
  my $codehash = shift || croak "No code here";
  my $opshash = shift || croak "No ops here";

  for ( keys %$codehash ) {
	$self->{"_$_"} =  eval "sub { $codehash->{$_} } ";
  }

  $self->{_ops} =();
  for ( keys %$opshash ) {
    push @{$self->{_ops}}, 
      Algorithm::Evolutionary::Op::Base::fromXML( $_, $opshash->{$_}->[1], $opshash->{$_}->[0] ) ;
  }
}

=head2 apply( $population )

Evaluates the population, setting its fitness value

=cut

sub apply ($) {
    my $self = shift;
    my $pop = shift || croak "No population here";
    croak "Incorrect type ".(ref $pop) if  ref( $pop ) ne $APPLIESTO;

    my $eval = $self->{_eval};
    #Compute vector fitness
    my %fitness_vector_of;
    for my $p (@$pop ) {
      $fitness_vector_of{$p->as_string} = $eval->apply($p);
    }

    #Compute rank
    my @wins;
    my $i;
    for ( $i = 0; $i < @$pop; $i++ ) {
      for ( my $j = $i+1; $j < @$pop; $j++ ) {
	my $result = 
	  vector_compare( $fitness_vector_of{ $pop->[$i]->as_string },
			  $fitness_vector_of{ $pop->[$j]->as_string } );
	$wins[$i]++ if $result == 1;
	$wins[$j]++ if $result == -1;
      }
      
    }
    
    for ( $i = 0; $i < @$pop; $i++ ) {
      $wins[$i]++;
      $pop->[$i]->Fitness( $wins[$i] );
    }
    
}

=head1 SEE ALSO

=over 4

=item * 

L<Algorithm::Evolutionary::Fitness::Base>

=back

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/07/23 17:17:27 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Op/Eval/MO_Rank.pm,v 1.1 2009/07/23 17:17:27 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $

=cut

"The truth is out there";

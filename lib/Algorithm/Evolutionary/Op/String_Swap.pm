use strict;
use warnings;

=head1 NAME

Algorithm::Evolutionary::Op::String_Swap - Swaps two positions of the string.

=head1 SYNOPSIS

  use Algorithm::Evolutionary::Op::String_Swap;

  my $op = new Algorithm::Evolutionary::Op::String_Swap ; #Create from scratch
  my $string_chromosome =  new Algorithm::Evolutionary::Individual::String 10;
  $op->apply( $chromosome );

=head1 Base Class

L<Algorithm::Evolutionary::Op::Base>

=head1 DESCRIPTION

String swap operator; any individual that has the
    C<_str> instance variable (like
    L<Algorithm::Evolutionary::Individual::String> and
    L<Algorithm::Evolutionary::Individual::BitString>)  will have some
    of its elements swapped. 

This kind of operator is used extensively in combinatorial
    optimization problems. See, for instance, 
  @article{prins2004simple,
   title={{A simple and effective evolutionary algorithm for the vehicle routing problem}},
   author={Prins, C.},
   journal={Computers \& Operations Research},
   volume={31},
   number={12},
   pages={1985--2002},
   issn={0305-0548},
   year={2004},
   publisher={Elsevier}
  }

And, of course, L<Algorithm::MasterMind>, where it is used in the
    evolutionary algorithms solutions. 

=cut

package  Algorithm::Evolutionary::Op::String_Swap;

use lib qw( ../../.. );

our ($VERSION) = ( '$Revision: 3.1 $ ' =~ /(\d+\.\d+)/ );

use Carp;
use Clone qw(clone);

use base 'Algorithm::Evolutionary::Op::Base';
use Algorithm::Permute;

#Class-wide constants
our $APPLIESTO =  'Algorithm::Evolutionary::Individual::String';
our $ARITY = 1;

=head1 METHODS

=head2 new( [$rate = 1][, $max_iterations = 10] )

Creates a new swap operator; see 
    L<Algorithm::Evolutionary::Op::Base> for details common to all
    operators.

=cut

sub new {
  my $class = shift;
  my $rate = shift || 1;

  my $self = Algorithm::Evolutionary::Op::Base::new( 'Algorithm::Evolutionary::Op::String_Swap', $rate );
  $self->{'_max_iterations'} = shift || 10;
  return $self;
}

=head2 apply( $chromosome )

Applies at most C<max_iterations> permutations to a "Chromosome" that includes the C<_str>
    instance variable. The number of iterations will be random, so
    that applications of the operator on the same individual will
    create diverse offspring. 

=cut

sub apply ($;$) {
  my $self = shift;
  my $arg = shift || croak "No victim here!";
  my $victim = clone($arg);
  croak "Incorrect type ".(ref $victim) if ! $self->check( $victim );
  my $first = rand( length( $victim->{'_str'} ) );
  my $first_char = substr( $victim->{'_str'}, $first, 1 );
  my @different;
  for ( my $i = 0; $i < length( $victim->{'_str'} ); $i++ ) {
    if ( substr( $victim->{'_str'}, $i, 1 ) ne  $first_char ) {
      push @different, $i;
    }
  }
  if ( @different ) {
    my $second = rand(  @different );
    substr($victim->{'_str'},$first,1) = substr($victim->{'_str'},$different[$second],1);
    substr($victim->{'_str'},$different[$second],1) = $first_char;
  }
  return $victim
}

=head2 SEE ALSO

Uses L<Algorithm::Evolutionary::Op::Permutation>, which performs a
much more extensive permutation.

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2013/01/05 12:01:58 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Op/String_Swap.pm,v 3.1 2013/01/05 12:01:58 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 3.1 $

=cut


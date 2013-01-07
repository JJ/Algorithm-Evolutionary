use strict;
use warnings;

=head1 NAME

Algorithm::Evolutionary::Op::String_Shift - Shifts with carry the string right or left

=head1 SYNOPSIS

  use Algorithm::Evolutionary::Op::String_Shift;

  my $op = new Algorithm::Evolutionary::Op::String_Shift ; #Create from scratch
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

package  Algorithm::Evolutionary::Op::String_Shift;

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

  my $self = Algorithm::Evolutionary::Op::Base::new( 'Algorithm::Evolutionary::Op::String_Shift', $rate );
  return $self;
}

=head2 apply( $chromosome )

Shifts randomly right or left

=cut

sub apply ($;$) {
  my $self = shift;
  my $arg = shift || croak "No victim here!";
  my $victim = clone($arg);
  croak "Incorrect type ".(ref $victim) if ! $self->check( $victim );
  my $direction = rand();
  if ( $direction < 0.5 ) { #left
    my $carry = substr( $arg->{'_str'}, 0, 1);
    $victim->{'_str'} = substr(  $arg->{'_str'}, 1, length( $arg->{'_str'} ) -1 ).$carry;
  } else {
    my $carry = chop( $victim->{'_str'});
    $victim->{'_str'} = $carry. $victim->{'_str'};
  }
  return $victim
}

=head2 SEE ALSO

Uses L<Algorithm::Evolutionary::Op::Permutation>, which performs a
much more extensive permutation, and L<Algorithm::Evolutionary::Op::String_Swap>

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2013/01/07 13:54:20 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Op/String_Shift.pm,v 3.1 2013/01/07 13:54:20 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 3.1 $

=cut


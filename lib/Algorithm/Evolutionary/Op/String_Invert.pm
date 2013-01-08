use strict;
use warnings;

=head1 NAME

Algorithm::Evolutionary::Op::String_Inverts - Inverts the string.

=head1 SYNOPSIS

  use Algorithm::Evolutionary::Op::String_Invert;

  my $op = new Algorithm::Evolutionary::Op::String_Invert ; #Create from scratch
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

It's uses mainli in L<Algorithm::MasterMind>, where it is used in the
    evolutionary algorithms solutions. 

=cut

package  Algorithm::Evolutionary::Op::String_Invert;

use lib qw( ../../.. );

our ($VERSION) = ( '$Revision: 1.1 $ ' =~ /(\d+\.\d+)/ );

use Carp;
use Clone qw(clone);

use base 'Algorithm::Evolutionary::Op::Base';

#Class-wide constants
our $APPLIESTO =  'Algorithm::Evolutionary::Individual::String';
our $ARITY = 1;

=head1 METHODS

=head2 new( [$rate = 1] )

Creates a new string inversion operator; see 
    L<Algorithm::Evolutionary::Op::Base> for details common to all
    operators.

=cut

sub new {
  my $class = shift;
  my $rate = shift || 1;

  my $self = Algorithm::Evolutionary::Op::Base::new( 'Algorithm::Evolutionary::Op::String_Invert', $rate );
  return $self;
}

=head2 apply( $chromosome )

Reverses the string. 

=cut

sub apply ($;$) {
  my $self = shift;
  my $arg = shift || croak "No victim here!";
  my $victim = clone($arg);
  croak "Incorrect type ".(ref $victim) if ! $self->check( $victim );
  my $string = $arg->{'_str'};
  $victim->{'_str'} = '';
  while ( $string ) {
    my $char = chop( $string );
    $victim->{'_str'} .= $char;
  }
  return $victim
}

=head2 SEE ALSO

Uses L<Algorithm::Evolutionary::Op::Permutation>, which performs a
much more extensive permutation, and L<Algorithm::Evolutionary::Op::String_Swap>

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2013/01/08 18:25:38 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Op/String_Invert.pm,v 1.1 2013/01/08 18:25:38 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $

=cut


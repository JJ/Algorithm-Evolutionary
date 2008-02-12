use strict;
use warnings;

=head1 NAME

  Algorithm::Evolutionary::Op::Mutation - BitFlip mutation, changes several bits in a bitstring, depending on the probability

=head1 SYNOPSIS

  use Algorithm::Evolutionary::Op::Mutation;

  my $xmlStr=<<EOC;
  <op name='Mutation' type='unary' rate='2'>
    <param name='probability' value='0.5' />
  </op>
  EOC
  my $ref = XMLin($xmlStr);

  my $op = Algorithm::Evolutionary::Op::->fromXML( $ref );
  print $op->asXML(), "\n*Arity ->", $op->arity(), "\n";

  my $op = new Algorithm::Evolutionary::Op::Mutation (0.5 ); #Create from scratch

=head1 Base Class

L<Algorithm::Evolutionary::Op::Base|Algorithm::Evolutionary::Op::Base>

=head1 DESCRIPTION

Mutation operator for a GA

=cut

package  Algorithm::Evolutionary::Op::Mutation;

our ($VERSION) = ( '$Revision: 1.1 $ ' =~ /(\d+\.\d+)/ );

use Carp;

use Algorithm::Evolutionary::Op::Base;
our @ISA = qw (Algorithm::Evolutionary::Op::Base);

#Class-wide constants
our $APPLIESTO =  'Algorithm::Evolutionary::Individual::BitString';
our $ARITY = 1;

=head1 METHODS

=head2 new

Creates a new mutation operator with a bitflip application rate, which defaults to 0.5,
and an operator application rate (general for all ops), which defaults to 1.

=cut

sub new {
  my $class = shift;
  my $mutRate = shift || 0.5; 
  my $rate = shift || 1;

  my $hash = { mutRate => $mutRate };
  my $self = Algorithm::Evolutionary::Op::Base::new( 'Algorithm::Evolutionary::Op::Mutation', $rate, $hash );
  return $self;
}


=head2 create

Creates a new mutation operator with an application rate. Rate defaults to 0.5.

Called create to distinguish from the classwide ctor, new. It just
makes simpler to create a Mutation Operator

=cut

sub create {
  my $class = shift;
  my $rate = shift || 0.5; 

  my $self = {_mutRate => $rate };

  bless $self, $class;
  return $self;
}

=head2 apply

Applies mutation operator to a "Chromosome", a bitstring, really. Can be
applied only to I<victims> with the C<_str> instance variable; 
it checks before application that the operand is of type
L<Algorithm::Evolutionary::Individual::BitString|Algorithm::Evolutionary::Individual::BitString>. It returns the victim.

=cut

sub apply ($;$) {
  my $self = shift;
  my $arg = shift || croak "No victim here!";
  my $victim = $arg->clone();
  croak "Incorrect type ".(ref $victim) if ! $self->check( $victim );
  for ( my $i = 0; $i < length( $victim->{_str} ); $i ++ ) {
	if ( rand() < $self->{_mutRate} ) {
	  my $bit = $victim->Atom($i);
	  $victim->Atom($i,  $bit?0:1 );
	}
  }
  return $victim;
}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/02/12 17:49:39 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Op/Mutation.pm,v 1.1 2008/02/12 17:49:39 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $
  $Name $

=cut


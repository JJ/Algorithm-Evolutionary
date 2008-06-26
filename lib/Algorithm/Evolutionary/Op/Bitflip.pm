use strict;
use warnings;

=head1 NAME

  Algorithm::Evolutionary::Op::Bitflip - BitFlip mutation

=head1 SYNOPSIS

  my $xmlStr2=<<EOC; #howMany should be integer
  <op name='Bitflip' type='unary' rate='0.5' >
    <param name='howMany' value='2' /> 
  </op>
  EOC
  my $ref2 = XMLin($xmlStr2);

  my $op2 = Algorithm::Evolutionary::Op::Base->fromXML( $ref2 );
  print $op2->asXML(), "\n*Arity ", $op->arity(), "\n";

  my $op = new Algorithm::Evolutionary::Op::Bitflip 2; #Create from scratch with default rate

=head1 Base Class

L<Algorithm::Evolutionary::Op::Base|Algorithm::Evolutionary::Op::Base>

=head1 DESCRIPTION

Mutation operator for a GA; changes a single bit in the bitstring; 
does not need a rate

=head1 METHODS 

=cut


package Algorithm::Evolutionary::Op::Bitflip;

our ($VERSION) = ( '$Revision: 1.2 $ ' =~ /(\d+\.\d+)/ );


use Carp;
use Clone::Fast qw(clone);

use Algorithm::Evolutionary::Op::Base;
our @ISA = qw(Algorithm::Evolutionary::Op::Base);

#Class-wide constants
our $APPLIESTO =  'Algorithm::Evolutionary::Individual::BitString';
our $ARITY = 1;
=head2 new

Creates a new mutation operator with a bitflip application rate, which defaults to 0.5,
and an operator application rate (general for all ops), which defaults to 1.

=cut

sub new {
  my $class = shift;
  my $howMany = shift || 1; 
  my $rate = shift || 1;

  my $hash = { howMany => $howMany || 1};
  my $self = Algorithm::Evolutionary::Op::Base::new( 'Algorithm::Evolutionary::Op::Bitflip', $rate, $hash );
  return $self;
}

=head2 create

Creates a new mutation operator.

=cut

sub create {
  my $class = shift;
  my $self = {};
  bless $self, $class;
  return $self;
}

=head2 apply

Applies mutation operator to a "Chromosome", a bitstring, really. Can be
applied only to I<victims> with the C<_str> instance variable; but
it checks before application that both operands are of type
L<BitString|Algorithm::Evolutionary::Individual::BitString>.

=cut

sub apply ($;$){
  my $self = shift;
  my $arg = shift || croak "No victim here!";
#  my $victim = $arg->clone();
  my $victim = clone( $arg );
  croak "Incorrect type ".(ref $victim) if ! $self->check( $victim );
  for ( my $i = 0; $i < $self->{_howMany}; $i++ ) {
	my $rnd = int (rand( length( $victim->{_str} ) ));
	$victim->Atom( $rnd, $victim->Atom( $rnd )?0:1 );
  }
  $victim->Fitness(undef); #Invalidate fitness
  return $victim;
}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/06/26 11:37:43 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Op/Bitflip.pm,v 1.2 2008/06/26 11:37:43 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.2 $
  $Name $

=cut


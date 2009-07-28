use strict;
use warnings;

=head1 NAME

Algorithm::Evolutionary::Op::Permutation - Per-mutation. Got it? 

=head1 SYNOPSIS

  use Algorithm::Evolutionary::Op::Mutation;

  my $xmlStr=<<EOC;
  <op name='Permutation' type='unary' rate='2' />
  EOC
  my $ref = XMLin($xmlStr);

  my $op = Algorithm::Evolutionary::Op::->fromXML( $ref );
  print $op->asXML(), "\n*Arity ->", $op->arity(), "\n";

  my $op = new Algorithm::Evolutionary::Op::Permutation ; #Create from scratch
  my $bitChrom =  new Algorithm::Evolutionary::Individual::BitString 10;
  $op->apply( $bitChrom );

=head1 Base Class

L<Algorithm::Evolutionary::Op::Base>

=head1 DESCRIPTION

Class independent permutation operator; any individual that has the
    C<_str> instance variable (like
    L<Algorithm::Evolutionary::Individual::String> and
    L<Algorithm::Evolutionary::Individual::BitString>) of its elements swapped.

=cut

package  Algorithm::Evolutionary::Op::Permutation;

our ($VERSION) = ( '$Revision: 3.1 $ ' =~ /(\d+\.\d+)/ );

use Carp;
use Clone::Fast qw(clone);

use base 'Algorithm::Evolutionary::Op::Base';
use Algorithm::Permute;

#Class-wide constants
our $APPLIESTO =  'Algorithm::Evolutionary::Individual::String';
our $ARITY = 1;

=head1 METHODS

=head2 new

Creates a new permutation operator; see
    L<Algorithm::Evolutionary::Op::Base> for details.

=cut

sub new {
  my $class = shift;
  my $rate = shift || 1;

  my $self = Algorithm::Evolutionary::Op::Base::new( 'Algorithm::Evolutionary::Op::Permutation', $rate );
  return $self;
}


=head2 create

Creates a new mutation operator with an application rate. Rate defaults to 0.5.

Called create to distinguish from the classwide ctor, new. It just
makes simpler to create a Mutation Operator

=cut

sub create {
  my $class = shift;
  my $rate = shift || 1; 

  my $self =  { rate => $rate };

  bless $self, $class;
  return $self;
}

=head2 apply( $chromosome )

Applies mutation operator to a "Chromosome" that includes the C<_str>
    instance variable, swapping positions for two of its components.

=cut

sub apply ($;$) {
  my $self = shift;
  my $arg = shift || croak "No victim here!";
  my $victim = clone($arg);
  croak "Incorrect type ".(ref $victim) if ! $self->check( $victim );
  my @arr = split("",$victim->{_str});
  my $p = new Algorithm::Permute( \@arr );
  $victim->{_str} = join( "",$p->next );
  return $victim;
}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/07/28 11:30:56 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Op/Permutation.pm,v 3.1 2009/07/28 11:30:56 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 3.1 $

=cut


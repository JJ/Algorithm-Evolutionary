use strict;
use warnings;

=head1 NAME

Algorithm::Evolutionary::Op::GaussianMutation - Changes numeric chromosome components following the gaussian distribution

=cut

=head1 SYNOPSIS

  my $xmlStr4=<<EOC; # From XML
  <op name='GaussianMutation' type='unary' rate='1'>
    <param name='avg' value='0' />
    <param name='stddev' value='0.1' />
  </op>
  EOC
  my $ref4 = XMLin($xmlStr4);
  my $op4 = Algorithm::Evolutionary::Op::Base->fromXML( $ref4 );
  print $op4->asXML(), "\n";

  my $op = new Algorithm::Evolutionary::Op::GaussianMutation( 0, 0.05) # With average 0, and 0.05 standard deviation

=cut

=head1 Base Class

L<Algorithm::Evolutionary::Op::Base|Algorithm::Evolutionary::Op::Base>

=cut

=head1 DESCRIPTION

Mutation operator for a GA: applies gaussian mutation to a number

=cut

package Algorithm::Evolutionary::Op::GaussianMutation;

our ($VERSION) = ( '$Revision: 1.3 $ ' =~ /(\d+\.\d+)/ );

use Carp;
use Math::Random;
use Clone::Fast qw(clone);

use base 'Algorithm::Evolutionary::Op::Base';

#Class-wide constants
our $APPLIESTO =  'Algorithm::Evolutionary::Individual::Vector';
our $ARITY = 1;

=head2 new

Creates a new mutation operator with an application rate. Rate defaults to 0.1.

=cut

sub new {
  my $class = shift;
  my $avg = shift || 0; 
  my $stddev = shift || 1;
  my $rate = shift || 1;

  my $hash = {avg => $avg,
	      stddev => $stddev };
  my $self = Algorithm::Evolutionary::Op::Base::new( 'Algorithm::Evolutionary::Op::GaussianMutation', $rate, $hash );
  return $self;
}

=head2 create

Creates a new mutation operator with an application rate. Rate defaults to 0.1.

Called create to distinguish from the classwide ctor, new. It just
makes simpler to create a Mutation Operator

=cut

sub create {
  my $class = shift;
  my $avg = shift || 0; 
  my $stddev = shift || 1;
  
  my $self = {_avg => $avg,
	      _stddev => $stddev };

  bless $self, $class;
  return $self;
}

=head2 apply( $chromosome )

Applies mutation operator to a "Chromosome", a vector of stuff,
really. Can be applied only to I<victims> with the C<_array> instance
variable; but it checks before application that both operands are of
type L<Algorithm::Evolutionary::Individual::Vector|Algorithm::Evolutionary::Individual::Vector>.

=cut

sub apply ($$) {
  my $self = shift;
  my $arg = shift || croak "No victim here!";
  croak "Incorrect type".(ref $arg) if !$arg->{_array};
  my $victim = clone($arg);
#  croak "Incorrect type ".(ref $victim) if !$self->check($victim);  
  my @deltas = random_normal( @{$victim->{_array}} + 1, $self->{_avg}, $self->{_stddev} );
  for ( @{$victim->{_array}} ) {
	$_ += pop @deltas;
  }
  return $victim;
}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/07/02 16:26:02 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Op/GaussianMutation.pm,v 1.3 2008/07/02 16:26:02 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.3 $
  $Name $

=cut

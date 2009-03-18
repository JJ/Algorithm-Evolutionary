use strict;
use warnings;

=head1 NAME

Algorithm::Evolutionary::Op::Uniform_Crossover - interchanges a set of atoms from one parent to the other.

=head1 SYNOPSIS

  #Create from XML description using EvoSpec
  my $xmlStr3=<<EOC;
  <op name='Uniform_Crossover' type='binary' rate='1'>
    <param name='numPoints' value='3' /> #Max is 2, anyways
  </op>
  EOC
  my $op3 = Algorithm::Evolutionary::Op::Base->fromXML( $xmlStr3 );
  print $op3->asXML(), "\n";

  #Apply to 2 Individuals of the String class
  my $indi = new Algorithm::Evolutionary::Individual::BitString 10;
  my $indi2 = $indi->clone();
  my $indi3 = $indi->clone();
  my $offspring = $op3->apply( $indi2, $indi3 ); #$indi2 == $offspring

  #Initialize using OO interface
  my $op4 = new Algorithm::Evolutionary::Op::Uniform_Crossover 0.5; # Crossover rate

=head1 Base Class

L<Algorithm::Evolutionary::Op::Base|Algorithm::Evolutionary::Op::Base>

=head1 DESCRIPTION

General purpose uniform crossover operator

=head1 METHODS

=cut

package Algorithm::Evolutionary::Op::Uniform_Crossover;

use lib qw(../../..);

our ($VERSION) = ( '$Revision: 2.1 $ ' =~ /(\d+\.\d+)/ );

use Clone::Fast qw(clone);
use Carp;

use base 'Algorithm::Evolutionary::Op::Base';

#Class-wide constants
our $APPLIESTO =  'Algorithm::Evolutionary::Individual::String';
our $ARITY = 2;

=head2 new( [$options_hash] [, $operation_priority] )

Creates a new n-point crossover operator, with 2 as the default number
of points, that is, the default would be
    my $options_hash = { crossover_rate => 0.5 };
    my $priority = 1;

=cut

sub new {
  my $class = shift;
  my $hash = { crossover_rate => shift || 2 };
  my $priority = shift || 1;
  my $self = Algorithm::Evolutionary::Op::Base::new( $class, $priority, $hash );
  return $self;
}

=head2 create( [$num_points] )

Creates a new 1 or 2 point crossover operator. But this is just to have a non-empty chromosome
Defaults to 2 point

=cut

sub create {
  my $class = shift;
  my $self;
  $self->{_crossover_rate} = shift || 0.5;
  bless $self, $class;
  return $self;
}

=head2 apply( $chromsosome_1, $chromosome_2 )

Applies xover operator to a "Chromosome", a string, really. Can be
applied only to I<victims> with the C<_str> instance variable; but
it checks before application that both operands are of type
L<BitString|Algorithm::Evolutionary::Individual::String>.

Changes the first parent, and returns it. If you want to change both
parents at the same time, check L<QuadXOver|Algorithm::Evolutionary::Op:QuadXOver>

=cut

sub  apply ($$$){
  my $self = shift;
  my $arg = shift || croak "No victim here!";
  my $victim = clone( $arg );
  my $victim2 = shift || croak "No victim here!";
  my $min_length = (  $victim->size() >  $victim2->size() )?
      $victim2->size():$victim->size();
  for ( my $i = 0; $i < $min_length; $i++ ) {
      if ( rand(100)>50) {
	  $victim->Atom($i, $victim2->Atom($i));
      }
  }
  $victim->{'_fitness'} = undef;
  return $victim; 
}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/03/18 20:41:22 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Op/Uniform_Crossover.pm,v 2.1 2009/03/18 20:41:22 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 2.1 $
  $Name $

=cut

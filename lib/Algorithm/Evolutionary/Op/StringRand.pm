use strict;
use warnings;

=head1 NAME

  Algorithm::Evolutionary::Op::StringRand - randomly change random  chars in a string

=cut

=head1 SYNOPSIS

  my $xmlStr2=<<EOC;
    <op name='StringRand' type='unary' rate='0.5' />
      <param name='numchars' value='1' />
    </op>
  EOC
  my $ref2 = XMLin($xmlStr2);

  my $op2 = Algorithm::Evolutionary::Op::Base->fromXML( $ref2 );
  print $op2->asXML(), "\n*Arity ", $op->arity(), "\n";

  my $op = new Algorithm::Evolutionary::Op::StringRand 3; #Change 3 characters

=head1 Base Class

L<Algorithm::Evolutionary::Op::Base|Algorithm::Evolutionary::Op::Base>


=head1 DESCRIPTION

  Mutation operator for a GA; changes a single element in a string by
  changing it to the next in the sequence deducted from the chromosome
  itself.

=cut

package Algorithm::Evolutionary::Op::StringRand;

our ($VERSION) = ( '$Revision: 2.2 $ ' =~ /(\d+\.\d+)/ );

use Carp;

use base 'Algorithm::Evolutionary::Op::Base';

#Class-wide constants
our $APPLIESTO =  'Algorithm::Evolutionary::Individual::String';
our $ARITY = 1;

=head2 create()

Creates a new mutation operator.

=cut

sub create {
  my $class = shift;
  my $self = {};
  bless $self, $class;
  return $self;
}

=head2 apply( $victim )

Applies mutation operator to a "Chromosome", a string, really. Can be
applied only to I<victims> with the C<_str> instance variable; but
it checks before application that both operands are of the required
type. The chosen character is changed to the next or previous in
the array of chars used for coding the the string
    my $strChrom = new Algorithm::Evolutionary::Individual::String ['a','c','g','t'] 10;
    my $xmen = new Algorithm::Evolutionary::Op::IncMutation;
    $xmen->apply( $strChrom ) # will change 'acgt' into 'aagt' or
			      # 'aggt', for instance

=cut

sub apply ($;$){
  my $self = shift;
  my $arg = shift || croak "No victim here!";
  my $victim = $arg->clone();
  croak "Incorrect type ".(ref $victim) if ! $self->check( $victim );
  my $rnd = int (rand( length( $victim->{_str} ) ));
  my $char = $victim->Atom( $rnd );
  #Compute its place in the array
  my $i = 0;
  #Compute order in the array
  while (  ($victim->{_chars}[$i] ne $char ) 
		   && ($i < @{$victim->{_chars}}) ) { $i++;};
  #Generate next or previous
  my $newpos = ( rand() > 0.5)?$i-1:$i+1;
  $newpos = @{$victim->{_chars}}-1 if !$newpos;
  $newpos = 0 if $newpos >= @{$victim->{_chars}};
  substr( $victim->{_str}, $rnd, 1 ) =  $victim->{_chars}[$newpos];
  $victim->Fitness(undef);
  return $victim;
}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/02/06 16:03:04 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Op/StringRand.pm,v 2.2 2009/02/06 16:03:04 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 2.2 $
  $Name $

=cut


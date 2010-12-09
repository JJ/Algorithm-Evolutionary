use strict; #-*-cperl-*-
use warnings;

use lib qw( ../../lib ../../../lib ../../../../lib);

=head1 NAME

Algorithm::Evolutionary::Op::String_Mutation - Bit-flip mutation

=head1 SYNOPSIS

  my $xmlStr2=<<EOC; #howMany should be integer
  <op name='String_Mutation' type='unary' rate='0.5' >
    <param name='howMany' value='2' /> 
  </op>
  EOC
  my $ref2 = XMLin($xmlStr2);

  my $op2 = Algorithm::Evolutionary::Op::Base->fromXML( $ref2 );
  print $op2->asXML(), "\n*Arity ", $op->arity(), "\n";

  my $op = new Algorithm::Evolutionary::Op::String_Mutation 2; #Create from scratch with default rate

=head1 Base Class

L<Algorithm::Evolutionary::Op::Base|Algorithm::Evolutionary::Op::Base>

=head1 DESCRIPTION

Mutation operator for a GA; changes a single bit in the string; 
does not need a rate

=head1 METHODS 

=cut

package Algorithm::Evolutionary::Op::String_Mutation;

our $VERSION =   sprintf "%d.%03d", q$Revision: 3.4 $ =~ /(\d+)\.(\d+)/g; 

use Carp;
use Clone::Fast qw(clone);

use base 'Algorithm::Evolutionary::Op::Base';

#Class-wide constants
our $ARITY = 1;

=head2 new( [$how_many] [,$priority] )

Creates a new mutation operator with a bitflip application rate, which defaults to 0.5,
and an operator application rate (general for all ops), which defaults to 1.

=cut

sub new {
  my $class = shift;
  my $howMany = shift || 1; 
  my $rate = shift || 1;

  my $hash = { howMany => $howMany || 1};
  my $self = Algorithm::Evolutionary::Op::Base::new( 'Algorithm::Evolutionary::Op::String_Mutation', 
						     $rate, $hash );
  return $self;
}

=head2 create()

Creates a new mutation operator.

=cut

sub create {
  my $class = shift;
  my $self = {};
  bless $self, $class;
  return $self;
}

=head2 apply( $chromosome )

Applies mutation operator to a "Chromosome", a string, really.

=cut

sub apply ($;$){
  my $self = shift;
  my $arg = shift || croak "No victim here!";
#  my $victim = clone($arg);
  my $victim = $arg->clone();
  my $size =  length($victim->{'_str'});

  croak "Too many changes" if $self->{'_howMany'} >= $size;
  my @char_array = 0..($size-1); # Avoids double mutation in a single place
  for ( my $i = 0; $i < $self->{'_howMany'}; $i++ ) {
      my $rnd = int (rand( @char_array ));
      my $who = splice(@char_array, $rnd, 1 );
      my $what = $victim->Atom( $who );
      my @these_chars = @{ $victim->{'_chars'}};
      for ( my $c = 0; $c < @{ $victim->{'_chars'}}; $c++ ) { #Exclude this character
	if ( $victim->{'_chars'}[$c] eq $what ) {
	  splice( @these_chars, $c, 1 );
	  last;
	}
      }
      $victim->Atom( $who, $these_chars[rand(@these_chars)] );
  }
  $victim->{'_fitness'} = undef ;
  return $victim;
}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2010/12/09 06:53:02 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Op/String_Mutation.pm,v 3.4 2010/12/09 06:53:02 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 3.4 $
  $Name $

=cut


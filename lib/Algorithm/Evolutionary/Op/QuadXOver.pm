use strict;
use warnings;

=head1 NAME

    Algorithm::Evolutionary::Op::QuadXOver - n-point crossover operator; puts a part of the second operand
                into the first operand; can be 1 or 2 points.

                 

=head1 SYNOPSIS

  my $xmlStr3=<<EOC;
  <op name='QuadXOver' type='binary' rate='1'>
    <param name='numPoints' value='3' /> #Max is 2, anyways
  </op>
  EOC
  my $ref3 = XMLin($xmlStr3);

  my $op3 = Algorithm::Evolutionary::Op::Base->fromXML( $ref3 );
  print $op3->asXML(), "\n";

  my $indi = new Algorithm::Evolutionary::Individual::BitString 10;
  my $indi2 = $indi->clone();
  my $indi3 = $indi->clone();
  $op3->apply( $indi2, $indi3 );

  my $op4 = new Algorithm::Evolutionary::Op::QuadXOver 3; #QuadXOver with 3 crossover points

=head1 Base Class

L<Algorithm::Evolutionary::Op::Base|Algorithm::Evolutionary::Op::Base>

=head1 DESCRIPTION

Crossover operator for a GA, takes args by reference and issues two
children from two parents

=head1 METHODS

=cut

package Algorithm::Evolutionary::Op::QuadXOver;

our ($VERSION) = ( '$Revision: 1.1 $ ' =~ /(\d+\.\d+)/ );

use Carp;

use Algorithm::Evolutionary::Op::Crossover;
our @ISA = ('Algorithm::Evolutionary::Op::Crossover');

#Class-wide constants
our $APPLIESTO =  'Algorithm::Evolutionary::Individual::String';
our $ARITY = 2;

=head2 apply

Same as L<Algorithm::Evolutionary::Op::Crossover>, but changes
parents, does not return anything

=cut

sub  apply ($$){
  my $self = shift;
  my $victim = shift || croak "No victim here!";
  my $victim2 = shift || croak "No victim here!";
  croak "Incorrect type ".(ref $victim) if !$self->check($victim);
  croak "Incorrect type ".(ref $victim2) if !$self->check($victim2);
  my $minlen = (  length( $victim->{_str} ) >  length( $victim2->{_str} ) )?
	 length( $victim2->{_str} ): length( $victim->{_str} );
  my $pt1 = int( rand( $minlen ) );
  my $range = 1 + int( rand( $minlen  - $pt1 ) );
#  print "Puntos: $pt1, $range \n";
  if ( $self->{_numPoints} > 1 ) {
	$range =  int ( rand( length( $victim->{_str} ) - $pt1 ) );
  }
  my $str = $victim->{_str};
  substr( $victim->{_str}, $pt1, $range ) = substr( $victim2->{_str}, $pt1, $range );
  substr( $victim2->{_str}, $pt1, $range ) = substr( $str, $pt1, $range );
  $victim->Fitness( undef );
  $victim->Fitness( undef );
  return undef; #As a warning that you should not expect anything
}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/02/12 17:49:39 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Op/QuadXOver.pm,v 1.1 2008/02/12 17:49:39 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $
  $Name $

=cut

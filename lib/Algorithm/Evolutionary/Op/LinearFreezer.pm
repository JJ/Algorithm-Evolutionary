use strict;
use warnings;

=head1 NAME

Algorithm::Evolutionary::Op::LinearFreezer - used by Simulated Annealing algorithms, reduces temperature lineally. 

=head1 SYNOPSIS

    my $freezer = new  Algorithm::Evolutionary::Op::LinearFreezer( $minTemp );

=head1 Base Class

L<Algorithm::Evolutionary::Op::Base|Algorithm::Evolutionary::Op::Base>

=head1 METHODS

=cut

package  Algorithm::Evolutionary::Op::LinearFreezer;

our ($VERSION) = ( '$Revision: 2.2 $ ' =~ / (\d+\.\d+)/ );

use Carp;
use base 'Algorithm::Evolutionary::Op::Base';

=head2 new ($initial_temperature)

Creates a new linear freezer

=cut

sub new {
  my $class = shift;
  my $self  = {};
  $self->{_initTemp} = shift || 0.2 ;
  $self->{_n} = 0 ;

  bless $self, $class;
  return $self;
}

=head2 apply( $temperature )

Applies freezing schedule to the temperature; returns new temperature

=cut

sub apply ($$) {
  my $self = shift;
  my $t = shift;

  $t = ($self->{_initTemp}) / ( 1 + $self->{_n} ) ;
  $self->{_n}++ ;

  return $t;
}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/03/24 17:36:00 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Op/LinearFreezer.pm,v 2.2 2009/03/24 17:36:00 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 2.2 $
  $Name $

=cut

use strict;
use warnings;

=head1 NAME

    Algorithm::Evolutionary::Op::NoChangeTerm - Checks for termination of an algorithm; terminates
                   when several generations transcur without change

=head1 SYNOPSIS

    my $nct = new Algorithm::Evolutionary::Op::NoChangeTerm 10; 
    #nct->apply( \@pop ) will return false after 10 generations w/o change

=head1 Base Class

L<Algorithm::Evolutionary::Op::Base|Algorithm::Evolutionary::Op::Base>

=head1 DESCRIPTION

Algorithm::Evolutionary::Op::NoChangeTerm is used when we want an
algorithm to finish when the population has stagnated, or the global
optimum is found. It counts how many generations the population has
not changed, and returns false after that limit is reached. 

It is useful if you want to run an algorithm for a certain time, or if
you want to apply some fancy diversity operator

=head1 METHODS

=cut

package Algorithm::Evolutionary::Op::NoChangeTerm;

our $VERSION = ( '$Revision: 2.1 $ ' =~ /(\d+\.\d+)/ ) ;

use base 'Algorithm::Evolutionary::Op::Base';

=head2 new

Creates a new terminator. Takes as an argument the number of
generations after which it will return false, which defaults to 10. 

=cut

sub new {
  my $class = shift;
  my $hash = { noChangeCounterMax => shift || 10,
	       noChangeCounter => 0,
	       lastBestFitness => rand()}; # A random value, unlikely
                                            # to be matched
  my $self = Algorithm::Evolutionary::Op::Base::new( __PACKAGE__, 1, $hash );
  return $self;
}


=head2 apply( $population )

Checks if the first member of the population has the same fitness as before,
and increments counter. The population I<should be ordered>

=cut

sub apply ($) {
  my $self = shift;
  my $pop = shift;

  if ( $pop->[0]->Fitness() == $self->{_lastBestFitness} ) { 
	$self->{_noChangeCounter}++;
#	print "NCT => ", $self->{_noChangeCounter}++, "\n";
  } else {
	$self->{_lastBestFitness}= $pop->[0]->Fitness();
	$self->{_noChangeCounter} = 0;
  }
  return $self->{_noChangeCounter} < $self->{_noChangeCounterMax};
  
}
  
=head1 See Also

L<Algorithm::Evolutionary::Op::FullAlgorithm> needs an object of this class to check
for the termination condition. It's normally used alongside "generation-type"
objects such as L<Algorithm::Evolutionary::Op::Easy>.

There are other options for termination conditions: L<Algorithm::Evolutionary::Op::DeltaTerm> and  
L<Algorithm::Evolutionary::Op::GenerationalTerm>.


=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/02/04 20:43:14 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Op/NoChangeTerm.pm,v 2.1 2009/02/04 20:43:14 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 2.1 $
  $Name $
 
=cut

"The truth is out there";

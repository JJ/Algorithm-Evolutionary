use strict; #-*-cperl-*-
use warnings;

=head1 NAME

    Algorithm::Evolutionary::Op::GenerationalTerm  - Checks for termination of an algorithm.
                 
=head1 SYNOPSIS

  my $gt = new Algorithm::Evolutionary::Op::GenerationalTerm 100; #apply will return false after 100 generations

=head1 Base Class

L<Algorithm::Evolutionary::Op::Base|Algorithm::Evolutionary::Op::Base>

=head1 DESCRIPTION

Base class for terminators, that is, checks performed at the
end of the evolutionary algorithm loop to see if it should continue
or not

=head1 METHODS

=cut

package Algorithm::Evolutionary::Op::GenerationalTerm;

our $VERSION = ( '$Revision: 2.1 $ ' =~ / (\d+\.\d+)/ ) ;

use base 'Algorithm::Evolutionary::Op::Base';

=head2 new

Creates a new generational terminator:
  my $gt = new Algorithm::Evolutionary::Op::GenerationalTerm 100; #apply will return false after 100 generations
will make the C<apply> method return false after 100 calls

=cut

sub new {
  my $class = shift;
  my $hash = { generations => shift || 100,
	       counter => 0 };
  my $self = Algorithm::Evolutionary::Op::Base::new( __PACKAGE__, 1, $hash );
  return $self;
}


=head2 apply()

Checks if the counter has arrived to the allotted number of generations,
returns false when it has. 
  $gt->apply(); 
will return C<false> when it has been run for the number of times it has
been initialized to

=cut

sub apply ($) {
  my $self = shift;
  $self->{_counter}++;
  return $self->{_counter} <= $self->{_generations};
  
}
  
=head1 See Also

L<Algorithm::Evolutionary::Op::FullAlgorithm> needs an object of this class to check
for the termination condition. It's normally used alongside "generation-type"
objects such as L<Algorithm::Evolutionary::Op::Easy>

There are other options for termination conditions: L<Algorithm::Evolutionary::Op::NoChangeTerm|Algorithm::Evolutionary::Op::NoChangeTerm> and  
L<Algorithm::Evolutionary::Op::DeltaTerm>.


=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/02/04 20:43:14 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Op/GenerationalTerm.pm,v 2.1 2009/02/04 20:43:14 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 2.1 $
  $Name $

=cut

"The truth is out there";

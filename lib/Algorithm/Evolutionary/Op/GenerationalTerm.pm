use strict;
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

our $VERSION = ( '$Revision: 1.1 $ ' =~ /(\d+\.\d+)/ ) ;

use Algorithm::Evolutionary::Op::Base;
our @ISA = qw(Algorithm::Evolutionary::Op::Base);

# Class-wide constants
our $APPLIESTO =  'ARRAY';
our $ARITY = 1;

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


=head2 apply

Checks if the counter has arrived to the allotted number of generations,
returns false when it has. 
  $gt->apply(); 
will return C<false> when it has been run for the number of times it has
been initialized to

=cut

sub apply ($) {
  my $self = shift;
  my $pop = shift;

  $self->{_counter}++;
  return $self->{_counter} <= $self->{_generations};
  
}
  


=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/02/12 17:49:38 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Op/GenerationalTerm.pm,v 1.1 2008/02/12 17:49:38 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $
  $Name $

=cut

"The truth is out there";

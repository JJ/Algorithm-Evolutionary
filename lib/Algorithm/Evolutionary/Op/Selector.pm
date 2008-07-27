use strict; #-*-cperl-*-
use warnings;

=head1 NAME

    Algorithm::Evolutionary::Op::Selector - Abstract base class for population selectors

=head1 SYNOPSIS

    package My::Selector;
    use base ' Algorithm::Evolutionary::Op::Selector';

=head1 Base Class

L<Algorithm::Evolutionary::Op::Base|Algorithm::Evolutionary::Op::Base>

=head1 DESCRIPTION

Abstract base class for population selectors; defines a few instance
    variables and interface elements

=head1 METHODS

=cut

package Algorithm::Evolutionary::Op::Selector;
use Carp;

our $VERSION = ( '$Revision: 1.1 $ ' =~ / (\d+\.\d+)/ ) ;

use base 'Algorithm::Evolutionary::Op::Base';

=head2 new( $output_population_size )

Creates a new selector; all selectors must know in advance how many
    they need

=cut

sub new {
 my $class = shift;
 carp "Should be called from subclasses" if ( $class eq  __PACKAGE__ );
 my $self = {};
 $self->{_outputSize} = shift || croak "I need an output population size";
 bless $self, $class;
 return $self;
}

=head2 apply

Applies the tournament selection to a population, returning
another of the said size

=cut

sub apply (@) {
    croak "To be redefined by siblings";
}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/07/27 08:31:11 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Op/Selector.pm,v 1.1 2008/07/27 08:31:11 jmerelo Exp $ 
  $Author: jmerelo $ 

=cut

"C'mon Eileen";

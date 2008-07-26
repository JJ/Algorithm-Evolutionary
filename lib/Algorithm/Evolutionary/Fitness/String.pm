use strict; # -*- cperl -*-
use warnings;


=head1 NAME

Algorithm::Evolutionary::Fitness::String - Base class for string-based fitness functors

=head1 SYNOPSIS

    package My::Own::Fitness;
    use base 'Algorithm::Evolutionary::Fitness::String'; #Mainly for deriving
    
    my $evaluator = new My::Own::Fitness;
    my $cache_hits = $evaluator->cached_evals();

=head1 DESCRIPTION

Base class for fitness functions applied to string-based chromosomes; extracts common code, and saves time. Provides a hash called C<%cache> to be used as a, well, cache for evaluations.

=head1 METHODS

=cut

package Algorithm::Evolutionary::Fitness::String;

our $VERSION = ( '$Revision: 1.2 $ ' =~ /(\d+\.\d+)/ ) ;

use Carp qw( croak );
use base qw(Algorithm::Evolutionary::Fitness::Base);


=head2 new()

Initializes the cache

=cut 

sub new {
  my $class = shift;
  my $self = { _cache => {} };
  bless $self, $class;
  return $self;
}

=head2 _apply( $individual )

Applies the instantiated problem to a chromosome, delegating to a specific function

=cut

sub _apply {
    my $self = shift;
    my $individual = shift;
    return  $self->_really_apply( $individual->{_str});
}

=head2 _really_apply( $string )

This one applies the function to the string. Should be overloaded

=cut

sub _really_apply {
  croak "This should be overriden";
}

=head2 cached_evals()

Returns the number of keys in the evaluation cache, which can be
compared to the total number of evaluations to find the cache hit
rate. 

=cut

sub cached_evals {
  my $self = shift;
  return scalar keys %{$self->{'_cache'}};
}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/07/26 15:27:44 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Fitness/String.pm,v 1.2 2008/07/26 15:27:44 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.2 $
  $Name $

=cut

"Where???";

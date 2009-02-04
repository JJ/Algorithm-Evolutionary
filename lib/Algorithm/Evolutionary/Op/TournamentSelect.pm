use strict; #-*-cperl-*-
use warnings;

=head1 NAME

    Algorithm::Evolutionary::Op::TournamentSelect - Tournament selector, takes individuals from one population
                       and puts them into another

=head1 SYNOPSIS

  my $popSize = 100;
  my $tournamentSize = 7;
  my $selector = new Algorithm::Evolutionary::Op::TournamentSelect $popSize, $tournamentSize;
  my @newPop = $selector->apply( @pop ); #Creates a new population from old

=head1 Base Class

L<Algorithm::Evolutionary::Op::Base|Algorithm::Evolutionary::Op::Selector>

=head1 DESCRIPTION

One of the possible selectors used for selecting the pool of individuals
that are going to be the parents of the following generation. Takes a
set of individuals randomly out of the population, and select a few of 
the best.

=head1 METHODS

=cut


package Algorithm::Evolutionary::Op::TournamentSelect;
use Carp;

our $VERSION = ( '$Revision: 2.1 $ ' =~ / (\d+\.\d+)/ ) ;

use base 'Algorithm::Evolutionary::Op::Base';

# Class-wide constants
#our $APPLIESTO =  'ARRAY';
#our $ARITY = 2; #Needs an array for input, a reference for output

=head2 new( $output_population_size, $tournament_size )

Creates a new tournament selector

=cut

sub new {
  my $class = shift;
  my $self = Algorithm::Evolutionary::Op::Selector::new($class, shift );
  $self->{_tournamentSize} = shift || 2;
  bless $self, $class;
  return $self;
}

=head2 apply

Applies the tournament selection to a population, returning
another of the said size

=cut

sub apply (@) {
  my $self = shift;
  my @pop = @_;
  croak "Small population size" if !@_;
  my @output;
  for ( my $i = 0; $i < $self->{_outputSize}; $i++ ) {
    #Randomly select a few guys
    my @tournament;
    for ( my $j = 0; $j < $self->{_tournamentSize}; $j++ ) {
      push( @tournament, @pop[ rand( @pop ) ]);
    }
    #Sort by fitness
    my @sortedT = sort { $b->{_fitness} <=> $a->{_fitness}; } @tournament;
    push @output, $sortedT[0];
  }
  return @output;
}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/02/04 20:43:15 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Op/TournamentSelect.pm,v 2.1 2009/02/04 20:43:15 jmerelo Exp $ 
  $Author: jmerelo $ 

=cut

"The truth is in here";

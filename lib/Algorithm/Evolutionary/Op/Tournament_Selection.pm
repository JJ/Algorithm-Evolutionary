use strict; #-*-cperl-*-
use warnings;

use lib qw( ../../../../lib );

=head1 NAME

Algorithm::Evolutionary::Op::Tournament_Selection - Tournament selector, takes individuals from one population and puts them into another

=head1 SYNOPSIS

  my $popSize = 100;
  my $tournamentSize = 7;
  my $selector = new Algorithm::Evolutionary::Op::Tournament_Selection $tournamentSize;
  my @newPop = $selector->apply( @pop ); #Creates a new population from old

=head1 Base Class

L<Algorithm::Evolutionary::Op::Selector>

=head1 DESCRIPTION

One of the possible selectors used for selecting the pool of individuals
that are going to be the parents of the following generation. Takes a
set of individuals randomly out of the population, and select a few of 
the best.

=head1 METHODS

=cut


package Algorithm::Evolutionary::Op::Tournament_Selection;
use Carp;

our ($VERSION) = ( '$Revision: 1.2 $ ' =~ / (\d+\.\d+)/ ) ;

use base 'Algorithm::Evolutionary::Op::Base';

=head2 new( $output_population_size, $tournament_size )

Creates a new tournament selector

=cut

sub new {
  my $class = shift;
  my $self = Algorithm::Evolutionary::Op::Base::new($class );
  $self->{'_tournament_size'} = shift || 2;
  bless $self, $class;
  return $self;
}

=head2 apply( $ref_to_population[, $output_size || @$ref_to_population] )

Applies the tournament selection to a population, returning
another of the same size by default or whatever size is selected

=cut

sub apply ($$) {
  my $self = shift;
  my $pop = shift || croak "No pop";
  my $output_size = shift || @$pop;
  my @output;
  for ( my $i = 0; $i < $output_size; $i++ ) {
    #Randomly select a few guys
    my @tournament;
    for ( my $j = 0; $j < $self->{'_tournament_size'}; $j++ ) {
      push( @tournament, $pop->[ rand( @$pop ) ]);
    }
    #Sort by fitness
    my @sortedT = sort { $b->Fitness() <=> $a->Fitness(); } @tournament;
    push @output, $sortedT[0];
  }
  return @output;
}

=head1 See Also

L<Algorithm::Evolutionary::Op::RouleteWheel> is another option for
selecting a pool of individuals

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2011/02/22 06:58:15 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Op/Tournament_Selection.pm,v 1.2 2011/02/22 06:58:15 jmerelo Exp $ 
  $Author: jmerelo $ 

=cut

"The truth is in here";

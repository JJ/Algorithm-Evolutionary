use strict;
use warnings;

=head1 NAME

Algorithm::Evolutionary::Op::Breeder_Diverser - Even more customizable single generation for an evolutionary algorithm.
                 
=head1 SYNOPSIS

    use Algorithm::Evolutionary qw( Individual::BitString 
    Op::Mutation Op::Crossover
    Op::RouletteWheel
    Op::Breeder_Diverser);

    use Algorithm::Evolutionary::Utils qw(average);

    my @pop;
    my $number_of_bits = 20;
    my $population_size = 20;
    my $replacement_rate = 0.5;
    for ( 1..$population_size ) {
      my $indi = new Algorithm::Evolutionary::Individual::BitString $number_of_bits ; #Creates random individual
      $indi->evaluate( $onemax );
      push( @pop, $indi );
    }

    my $m =  new Algorithm::Evolutionary::Op::Mutation 0.5;
    my $c = new Algorithm::Evolutionary::Op::Crossover; #Classical 2-point crossover

    my $selector = new Algorithm::Evolutionary::Op::RouletteWheel $population_size; #One of the possible selectors

    my $generation = 
      new Algorithm::Evolutionary::Op::Breeder_Diverser( $selector, [$m, $c] );

    my @sortPop = sort { $b->Fitness() <=> $a->Fitness() } @pop;
    my $bestIndi = $sortPop[0];
    my $previous_average = average( \@sortPop );
    $generation->apply( \@sortPop );

=head1 Base Class

L<Algorithm::Evolutionary::Op::Base>

=head1 DESCRIPTION

Breeder part of the evolutionary algorithm; takes a population and
returns another created from the first. Different from
L<Algorithm::Evolutionary::Op::Breeder>: tries to avoid crossover
among the same individuals. 

=head1 METHODS

=cut

package Algorithm::Evolutionary::Op::Breeder_Diverser;

use lib qw(../../..);

our ($VERSION) = ( '$Revision: 1.1 $ ' =~ / (\d+\.\d+)/ ) ;

use Carp;

use base 'Algorithm::Evolutionary::Op::Base';

use Algorithm::Evolutionary qw(Wheel
			       Op::Tournament_Selection);

# Class-wide constants
our $APPLIESTO =  'ARRAY';
our $ARITY = 1;

=head2 new( $ref_to_operator_array[, $selector = new Algorithm::Evolutionary::Op::Tournament_Selection 2 ] )

Creates a breeder, with a selector and array of operators

=cut

sub new {
  my $class = shift;
  my $self = {};
  $self->{_ops} = shift || croak "No operators found";
  $self->{_selector} = shift 
    || new Algorithm::Evolutionary::Op::Tournament_Selection 2;
  bless $self, $class;
  return $self;
}

=head2 apply( $population[, $how_many || $population_size] )

Applies the algorithm to the population, which should have
been evaluated first; checks that it receives a
ref-to-array as input, croaks if it does not. Returns a sorted,
culled, evaluated population for next generation.

=cut

sub apply ($) {
    my $self = shift;
    my $pop = shift || croak "No population here";
    my $output_size = shift || @$pop; # Defaults to pop size
    my @ops = @{$self->{_ops}};

    #Select for breeding
    my $selector = $self->{_selector};
    my @genitors = $selector->apply( $pop );

    #Reproduce
    my $totRate = 0;
    my @rates;
    for ( @ops ) {
	push( @rates, $_->{rate});
    }
    my $opWheel = new Algorithm::Evolutionary::Wheel @rates;

    my @new_population;
    for ( my $i = 0; $i < $output_size; $i++ ) {
	my @offspring;
	my $selectedOp = $ops[ $opWheel->spin()];
#	  print $selectedOp->asXML;
	if ( $selectedOp->arity() == 1 ) {
	  my $chosen = $genitors[ rand( @genitors )];
	  push( @offspring, $chosen->clone() );
	} elsif( $selectedOp->arity() == 2 ) {
	  my $chosen = $genitors[ rand( @genitors )];
	  push( @offspring, $chosen->clone() );
	  my $another_one;
	  do {
	    $another_one = $genitors[ rand( @genitors )];
	  } until ( $another_one->{'_str'} ne  $chosen->{'_str'} );
	  push( @offspring, $another_one );
	} else {
	  for ( my $j = 0; $j < $selectedOp->arity(); $j ++ ) {
	    my $chosen = $genitors[ rand( @genitors )];
	    push( @offspring, $chosen->clone() );
	  }
	}
	my $mutante = $selectedOp->apply( @offspring );
#	print join(" - ", map( $_->{'_str'}, @offspring ) ), "=> ", $mutante->{'_str'}, "\n";
	push( @new_population, $mutante );
      }
    return \@new_population;
}

=head1 SEE ALSO

More or less in the same ballpark, alternatives to this one

=over 4

=item * 

L<Algorithm::Evolutionary::Op::GeneralGeneration>

=back

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2010/12/22 14:23:18 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Op/Breeder_Diverser.pm,v 1.1 2010/12/22 14:23:18 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $

=cut

"The truth is out there";

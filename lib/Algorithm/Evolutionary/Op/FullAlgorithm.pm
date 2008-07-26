use strict; #-*-cperl-*-
use warnings;

=head1 NAME

    Algorithm::Evolutionary::Op::FullAlgorithm - Skeleton class for a fully-featured evolutionary algorithm
                 

=head1 SYNOPSIS

  my $easyEA = Algorithm::Evolutionary::Op::Base->fromXML( $ref->{$xml} );
  $easyEA->apply(\@pop ); 

  #Or using the constructor
   use Algorithm::Evolutionary::Op::Bitflip;
  my $m = new Algorithm::Evolutionary::Op::Bitflip; #Changes a single bit
  my $c = new Algorithm::Evolutionary::Op::Crossover; #Classical 2-point crossover
  my $replacementRate = 0.3; #Replacement rate
  use Algorithm::Evolutionary::Op::RouletteWheel;
  my $popSize = 20;
  my $selector = new Algorithm::Evolutionary::Op::RouletteWheel $popSize; #One of the possible selectors
  use Algorithm::Evolutionary::Op::GeneralGeneration;
  my $onemax = sub { 
    my $indi = shift;
    my $total = 0;
    my $len = $indi->length();
    my $i = 0;
    while ($i < $len ) {
      $total += substr($indi->{'_str'}, $i, 1);
      $i++;
    }
    return $total;
  };
  my $generation = 
    new Algorithm::Evolutionary::Op::GeneralGeneration( $onemax, $selector, [$m, $c], $replacementRate );
  use Algorithm::Evolutionary::Op::GenerationalTerm;
  my $g100 = new Algorithm::Evolutionary::Op::GenerationalTerm 10;
  use Algorithm::Evolutionary::Op::FullAlgorithm;
  my $f = new Algorithm::Evolutionary::Op::FullAlgorithm $generation, $g100;
  print $f->asXML();


=head1 Base Class

L<Algorithm::Evolutionary::Op::Base>

=head1 DESCRIPTION

Class Easy-to-use full evolutionary algoritm.It takes a
single-generarion algorithm, and mixes it with a termination condition
to create a full algorithm. Includes a sensible default
(100-generation generational algorithm) if it is issued only an object
of class L<Algorithm::Evolutionary::Op::GeneralGeneration>.

=cut

package Algorithm::Evolutionary::Op::FullAlgorithm;

our $VERSION = ( '$Revision: 1.3 $ ' =~ / (\d+\.\d+)/ ) ;

use Carp;

use Algorithm::Evolutionary::Op::Base;
our @ISA = qw(Algorithm::Evolutionary::Op::Base);

#  Class-wide constants
our $APPLIESTO =  'ARRAY';
our $ARITY = 1;

=head2 new( $single_generation[, $termination_test] [, $verboseness] )

Takes an already created algorithm and a terminator, and creates an object

=cut

sub new {
  my $class = shift;
  my $algo = shift|| croak "No single generation algorithm found";
  my $term = shift ||  new  Algorithm::Evolutionary::Op::GenerationalTerm 100;
  my $verbose = shift || 0;
  my $hash = { algo => $algo,
			   terminator => $term,
			   verbose => $verbose };
  my $self = Algorithm::Evolutionary::Op::Base::new( __PACKAGE__, 1, $hash );
  return $self;
}

=head2 set( $hashref, $codehash, $opshash )

Sets the instance variables. Takes hashes to the different options of
    the algorithm: parameters, fitness functions and operators

=cut

sub set {
  my $self = shift;
  my $hashref = shift || croak "No params here";
  my $codehash = shift;
  my $opshash = shift;

  $self->SUPER::set( $hashref );
  #Now reconstruct operators
  for ( keys %$opshash ) {
	$self->{$opshash->{$_}[2]} = 
	  Algorithm::Evolutionary::Op::Base::fromXML( $_, $opshash->{$_}->[1], $opshash->{$_}->[0] ); 
  }

}

=head2 apply( $reference_to_population_array )

Applies the algorithm to the population; checks that it receives a
ref-to-array as input, croaks if it does not. Returns a sorted,
culled, evaluated population for next generation.

=cut

sub apply ($) {
  my $self = shift;
  my $pop = shift || croak "No population here";
  croak "Incorrect type ".(ref $pop) if  ref( $pop ) ne $APPLIESTO;

  my $term = $self->{_terminator};
  my $algo = $self->{_algo};
  #Evaluate population, just in case
  my $eval = $algo->{_eval};
  for ( @$pop ) {
    if ( !defined $_->Fitness() ) {
      my $fitness = $eval->($_);
      $_->Fitness( $fitness );
    }
  }
  #Run the algorithm
  do {
	$algo->apply( $pop );
	if  ($self->{_verbose}) {
	  print "Best ", $pop->[0]->asString(), "\n" ;
	  print "Median ", $pop->[@$pop/2]->asString(), "\n";
	  print "Worst ", $pop->[@$pop-1]->asString(), "\n\n";
	}
  } while( $term->apply( $pop ) );
  
}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/07/26 15:27:45 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Op/FullAlgorithm.pm,v 1.3 2008/07/26 15:27:45 jmerelo Exp $ 
  $Author: jmerelo $ 

=cut

"The truth is out there";

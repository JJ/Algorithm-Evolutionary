use strict; #-*-cperl-*-
use warnings;

=head1 NAME

     Algorithm::Evolutionary::Op::RouletteWheel - Fitness-proportional selection, using a roulette wheel

=head1 SYNOPSIS

    use  Algorithm::Evolutionary::Op::RouletteWheel;
    my $popSize = 100;
    my $selector = new  Algorithm::Evolutionary::Op::RouletteWheel $popSize;

=head1 Base Class

L<Algorithm::Evolutionary::Op::Selector>

=head1 DESCRIPTION

Roulette wheel selection tries to select as many copies of the
individual as it corresponds to its fitness. It is used in the
canonical GA. Some information on this method of selection can be
found in
L<http://www.geatbx.com/docu/algselct.html#nameselectionrws|this GA tutorial>

=head1 METHODS

=cut

package  Algorithm::Evolutionary::Op::RouletteWheel;
use Carp;

our $VERSION = ( '$Revision: 1.2 $ ' =~ / (\d+\.\d+)/ ) ;

use base 'Algorithm::Evolutionary::Op::Selector';

use Algorithm::Evolutionary::Wheel;

# Class-wide constants
#our $APPLIESTO =  'ARRAY';
#our $ARITY = 2; #Needs an array for input, a reference for output

=head2 new( $output_population_size )

Creates a new roulette wheel selector

=cut

sub new {
 my $class = shift;
 my $self = Algorithm::Evolutionary::Op::Selector::new($class,shift );
 return $self;
}

=head2 apply

Applies the tournament selection to a population, returning
another of the said size

=cut

sub apply (@) {
  my $self = shift;
  my @pop = @_;
  croak "Small population size" if ! @_;
  my @output;
  #Create the value array
  my $sum = 0;
  my @rates;
  for ( @pop ) {
	$sum .= $_->Fitness() if defined $_->Fitness();
	push @rates, $_->Fitness();
  }
  my $popWheel=new Algorithm::Evolutionary::Wheel @rates;

  #Select
  for ( my $i = 0; $i < $self->{_outputSize}; $i++ ) {
    #Randomly select a few guys
	push @output, $pop[$popWheel->spin()];
  }
  return @output;
}


=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/07/27 08:31:11 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Op/RouletteWheel.pm,v 1.2 2008/07/27 08:31:11 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.2 $
  $Name $

=cut

"The truth is in there";

use strict;
use warnings;

=head1 NAME

Algorithm::Evolutionary::Wheel - Random selector of things depending on probabilities

=head1 SYNOPSIS

    my $wheel = new Algorithm::Evolutionary::Wheel( @probs );
    print $wheel->spin(); #Returns an element according to probabilities;

=head1 DESCRIPTION

Creates a "roulette wheel" for spinning and selecting stuff. It will
be used in several places; mainly in the
L<Algorithm::Evolutionary::Op::CanonicalGA>.  Take care that fitness
must be non-zero positives; since if they aren't, roulette wheel won't
work at all

=head1 METHODS

=cut

package Algorithm::Evolutionary::Wheel;
use Carp;

our ($VERSION) = ( '$Revision: 3.2 $ ' =~ / (\d+\.\d+)/ ) ;

=head2 new( @probabilites )

Creates a new roulette wheel. Takes an array of numbers, which need not be
normalized

=cut

sub new {
  my $class = shift;
  my @probs = @_;
  
  my $self;
  $self->{'_accProbs'} = [ 0 ];
  
  my $acc = 0;
  for ( @probs ) { $acc += $_;}
  croak "The sum of fitness is 0, can't use roulette wheel\n" if ! $acc;
  for ( @probs ) { $_ /= $acc;} #Normalizes array
  
  #Now creates the accumulated array
  my $aux = 0;  
  for ( @probs ) {
	push @{$self->{'_accProbs'}}, $_ + $aux;
	$aux += $_;
  }
  bless $self, $class;
  return $self;
}

=head2 spin( [$number_of_individuals = 1])

Returns an individual whose probability is related to its fitness

=cut

sub spin {
  my $self = shift;
  my $number_of_individuals = shift || 1;
  my $i = 0;
  my @rand;
  for my $n ( 1..$number_of_individuals ) {
    push @rand, rand();
  }
  my @individuals;
  for ( my $i = 0; $i < @{$self->{'_accProbs'}}-1; $i ++ ) {
    for my  $r ( @rand ) {
#      print $self->{'_accProbs'}[$i], " ", $r, " ", $self->{'_accProbs'}[$i+1], "\n";
      push(@individuals, $i) if (( $self->{'_accProbs'}[$i] < $r ) &&
				 ( $self->{_accProbs}[$i+1] > $r ) )
    }
  }
  if ( $number_of_individuals > 1 ) {
    return @individuals;
  } else {
    return $individuals[0];
  }
  
}
=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2010/01/17 17:49:50 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Wheel.pm,v 3.2 2010/01/17 17:49:50 jmerelo Exp $ 
  $Author: jmerelo $ 

=cut

"The truth is by here";

#Test code
#my @array = qw( 5 4 3 2 1 );
#my $wheel = new Wheel @array;

#my @histo;
#for ( 0..100 ){
#  my $s = $wheel->spin();
#  print "$s\n";
#  $histo[$s]++;
#}

#for ( 0..(@histo - 1)){
#  print $_, " => $histo[$_] \n";
#}

#my @array2 = qw( 1 3 7 4 2 1 );
#my $wheel2 = new Wheel @array2;

#my @histo2;
#for ( 0..100 ){
#  my $s = $wheel2->spin();
#  print "$s\n";
#  $histo2[$s]++;
#}

#for ( 0..(@histo2 - 1)){
#  print $_, " => $histo2[$_] \n";
#}

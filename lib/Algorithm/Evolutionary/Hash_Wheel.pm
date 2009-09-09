use strict;
use warnings;

=head1 NAME

Algorithm::Evolutionary::Hash_Wheel - Random selector of things depending on probabilities

=head1 SYNOPSIS

    my $wheel = new Algorithm::Evolutionary::Hash_Wheel( \%probs );
    print $wheel->spin(); #Returns an element according to probabilities;

=head1 DESCRIPTION

Creates a "roulette wheel" for spinning and selecting stuff. It will
be used in several places; mainly in the
L<Algorithm::Evolutionary::Op::CanonicalGA>. It's similar to
L<Algorithm::Evolutionary::Wheel>, but with a hash instead of an
array. Probably should unify both..

=head1 METHODS

=cut

package Algorithm::Evolutionary::Hash_Wheel;
use Carp;

our ($VERSION) = ( '$Revision: 1.1 $ ' =~ / (\d+\.\d+)/ ) ;

=head2 new( @probabilites )

Creates a new roulette wheel. Takes an array of numbers, which need not be
normalized

=cut

sub new {
  my $class = shift;
  my $probs_hashref = shift || die "No probabilities hash";

  my %probs = %$probs_hashref;
  my $self = { _accProbs => [] };
  
  my $acc = 0;
  for ( sort keys %probs ) { $acc += $probs{$_};}
  for ( sort keys %probs ) { $probs{$_} /= $acc;} #Normalizes array

  #Now creates the accumulated array
  my $aux = 0;  
  for ( sort keys %probs ) {
	push @{$self->{_accProbs}}, [$probs{$_} + $aux,$_ ];
	$aux += $probs{$_};
  }

  bless $self, $class;
  return $self;
}

=head2 spin()

Returns an individual whose probability is related to its fitness

=cut

sub spin {
  my $self = shift;
  my $i = 0;
  my $rand = rand();
  while ( $self->{_accProbs}[$i]->[0] < $rand ) { $i++ };
  return $self->{_accProbs}[$i]->[1];
  
}
=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/09/09 09:02:38 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Hash_Wheel.pm,v 1.1 2009/09/09 09:02:38 jmerelo Exp $ 
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

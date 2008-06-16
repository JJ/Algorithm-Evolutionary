use strict;
use warnings;

=head1 NAME

    Algorithm::Evolutionary::Fitness::wP_Peaks - wP Peaks problem generator - weighted version of P_Peaks

=head1 SYNOPSIS

    my $number_of_bits = 32;
    my @weights = (1);
    for (my $i = 0; $i < 99; $i ++ ) {
       push @weights, 0.99;
    }
    my $p_peaks = Algorithm::Evolutionary::Fitness::P_Peaks->new( $number_of_bits, @weights ); #Number of peaks = scalar  @weights

=head1 DESCRIPTION

    wP-Peaks fitness function, weighted version of the P-Peaks fitness function, which has now a single peak

=head1 METHODS

=cut

package Algorithm::Evolutionary::Fitness::wP_Peaks;

use String::Random;
use Algorithm::Evolutionary::Utils qw(hamming);

use base qw(Algorithm::Evolutionary::Fitness::Base);

=head2 new

    Creates a new instance of the problem, with the said number of bits and peaks

=cut 

sub new {
  my $class = shift;
  my ( $bits, @weights ) = @_;

  #Generate peaks
  my $generator = new String::Random;
  my @peaks;
  my $regex = "\[01\]{$bits}";
  my $self = { bits => $bits,
	       generator => $generator,
	       regex => $regex };
  while ( @weights ) {
      my $this_w = shift @weights;
      push( @peaks, [$this_w, $generator->randregex($regex)]);
  }
  $self->{'peaks'} = \@peaks;
  bless $self, $class;
  $self->initialize();
  return $self;
}

=head2 random_string

Returns random string in the same style than the peaks. Useful for testing

=cut

sub random_string {
    my $self = shift;
    return $self->{'generator'}->randregex($self->{'regex'});
}

=head2 _apply

Applies the instantiated problem to a chromosome

=cut

sub _apply {
    my $self = shift;
    my $individual = shift;
    return  $self->p_peaks( $individual->{_str})/$self->{'bits'};
}

=head2 p_peaks

Applies the instantiated problem to a string

=cut

our %cache;

sub p_peaks {
    my $self = shift;
    my @peaks = @{$self->{'peaks'}};
    my $string = shift;
    if ( $cache{$string} ) {
	return $cache{$string};
    }
    my $bits = $self->{'bits'};
    my @distances = sort {$b <=> $a} map($bits*$_->[0]- hamming( $string, $_->[1]), @peaks);
    $cache{$string} = $distances[0];
    return $cache{$string};

}

=head2 cached_evals

Returns the number of keys in the evaluation cache

=cut

sub cached_evals {
    return scalar keys %cache;
}



=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/06/16 16:31:28 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Fitness/wP_Peaks.pm,v 1.1 2008/06/16 16:31:28 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $
  $Name $

=cut

"What???";

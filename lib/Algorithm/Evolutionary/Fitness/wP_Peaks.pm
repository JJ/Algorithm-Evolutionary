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

our $VERSION = ( '$Revision: 1.3 $ ' =~ /(\d+\.\d+)/ ) ;

use String::Random;
use Algorithm::Evolutionary::Utils qw(hamming);

use base qw(Algorithm::Evolutionary::Fitness::String);

=head2 new( $number_of_bits, $ref_to_weights_hash )

Creates a new instance of the problem, with the said number of bits and peaks

=cut 

sub new {
  my $class = shift;
  my ( $bits, @weights ) = @_;
  my $self = $class->SUPER::new();

  #Generate peaks
  my $generator = new String::Random;
  my @peaks;
  my $regex = "\[01\]{$bits}";
  for my $s qw( bits generator regex ) {
      eval "\$self->{'$s'} = \$$s";
  }
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

sub _really_apply {
    my $self = shift;
    return  $self->p_peaks( @_ )/$self->{'bits'};
}

=head2 p_peaks

Applies the instantiated problem to a string

=cut

sub p_peaks {
    my $self = shift;
    my @peaks = @{$self->{'peaks'}};
    my $string = shift;
    my $cache = $self->{'_cache'};
    
    if ( $cache->{$string} ) {
	return $cache->{$string};
    }
    my $bits = $self->{'bits'};
    my @distances = sort {$b <=> $a} map($bits*$_->[0]- hamming( $string, $_->[1]), @peaks);
    $cache->{$string} = $distances[0];
    return $cache->{$string};

}


=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/06/23 11:27:10 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Fitness/wP_Peaks.pm,v 1.3 2008/06/23 11:27:10 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.3 $
  $Name $

=cut

"What???";
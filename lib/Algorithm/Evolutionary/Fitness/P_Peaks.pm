use strict; # -*- cperl -*-
use warnings;

use lib qw( ../../../../lib );

=head1 NAME

Algorithm::Evolutionary::Fitness::P_Peaks - P Peaks problem generator

=head1 SYNOPSIS

    my $number_of_peaks = 100;
    my $number_of_bits = 32;
    my $p_peaks = Algorithm::Evolutionary::Fitness::P_Peaks->new( $number_of_peaks, $number_of_bits );

=head1 DESCRIPTION

P_Peaks fitness function; optimizes the distance to the closest in a series of peaks

=head1 METHODS

=cut

package Algorithm::Evolutionary::Fitness::P_Peaks;

our ($VERSION) = ( '$Revision: 2.2 $ ' =~ / (\d+\.\d+)/ ) ;

use String::Random;
use Carp;

use lib qw(../../.. ../.. ..);

use base qw(Algorithm::Evolutionary::Fitness::String);
use Algorithm::Evolutionary::Utils qw(hamming);

=head2 new( $peaks, $bits )

    Creates a new instance of the problem, with the said number of bits and peaks

=cut 

sub new {
  my $class = shift;
  my ($peaks, $bits ) = @_;
  croak "No peaks"  if !$peaks;
  croak "Too few bits" if !$bits;
  my $self = $class->SUPER::new();
  #Generate peaks
  my $generator = new String::Random;
  my @peaks;
  my $regex = "\[01\]{$bits}";
  for my $s qw( bits generator regex ) {
      eval "\$self->{'$s'} = \$$s";
  }
  for my $p ( 1..$peaks ) {
    push( @peaks, $generator->randregex($regex));
  }
  $self->{'peaks'} = \@peaks;
  bless $self, $class;
  $self->initialize();
  return $self;
}

=head2 random_string()

Returns random string in the same style than the peaks. Useful for testing

=cut

sub random_string {
    my $self = shift;
    return $self->{'generator'}->randregex($self->{'regex'});
}

=head2 _really_apply( $string )

Applies the instantiated problem to a chromosome. Intended for internal use.

=cut

sub _really_apply {
  my $self = shift;
  return $self->p_peaks( @_ )/$self->{'bits'} ;
}

=head2 p_peaks( $string )

Applies the instantiated problem to a string

=cut

sub p_peaks {
    my $self = shift;
    my @peaks = @{$self->{'peaks'}};
    my $string = shift || croak "No string!";
    my $cache = $self->{'_cache'};
    if ( $cache->{$string} ) {
	return $cache->{$string};
    }
    my $bits = $self->{'bits'};
    my @distances = sort {$b <=> $a}  map($bits - hamming( $string, $_), @peaks);
    $cache->{$string} = $distances[0];
    return $cache->{$string};

}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/02/05 07:10:35 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Fitness/P_Peaks.pm,v 2.2 2009/02/05 07:10:35 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 2.2 $
  $Name $

=cut

"What???";

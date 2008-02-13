use strict;
use warnings;

=head1 NAME

    Algorithm::Evolutionary::Fitness::P_Peaks - P Peaks problem generator

=head1 SYNOPSIS

    my $number_of_peaks = 100;
    my $number_of_bits = 32;
    my $p_peaks = Algorithm::Evolutionary::Fitness::P_Peaks->new( $number_of_peaks, $number_of_bits );

=head1 DESCRIPTION

Just a fitness function, it just seemed nice to encapsulate everything here.

=head1 METHODS

=cut

package Algorithm::Evolutionary::Fitness::P_Peaks;


use String::Random;

=head2 new

    Creates a new instance of the problem, with the said number of bits and peaks

=cut 

sub new {
  my $class = shift;
  my ($peaks, $bits ) = @_;

  #Generate peaks
  my $generator = new String::Random;
  my @peaks;
  my $regex = "\[01\]{$bits}";
  my $self = { bits => $bits,
	       generator => $generator,
	       regex => $regex };
  for my $p ( 1..$peaks ) {
    push( @peaks, $generator->randregex($regex));
  }
  $self->{'peaks'} = \@peaks;
  bless $self, $class;
  return $self;
}

=head2 random_string

Returns random string in the same style than the peaks. Useful for testing

=cut

sub random_string {
    my $self = shift;
    return $self->{'generator'}->randregex($self->{'regex'});
}

=head2 apply

Applies the instantiated problem to a chromosome

=cut

sub apply {
    my $self = shift;
    my $individual = shift;
    return $self->p_peaks( $individual->{_str} );
}

=head2 p_peaks

Applies the instantiated problem to a string

=cut

sub p_peaks {
    my $self = shift;
    my @peaks = @{$self->{'peaks'}};
    my $string = shift;
    my @distances = sort {$a <=> $b}  map( hamming( $string, $_), @peaks);

    return $distances[0];

} 

=head2 hamming

Computes the number of positions that are different among two strings

=cut

sub hamming {
    my ($string_a, $string_b) = @_;
    return ( ( $string_a ^ $string_b ) =~ tr/\1//);
}

=head1 Author

JJ Merelo.

=cut 
=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/02/13 17:03:11 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/Attic/P_Peaks.pm,v 1.1 2008/02/13 17:03:11 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $
  $Name $

=cut

"What???";

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

  my $self = { bits => $bits };

  #Generate peaks
  my $generator = new String::Random;
  my @peaks;
  my $regex = "\[01\]{$bits}";
  for my $p ( 1..$peaks ) {
    push( @peaks, $generator->randregex($regex));
  }
  $self->{'peaks'} = \@peaks;
  bless $class, $self;
  return $self;
}


=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/02/13 13:41:22 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Fitness/P_Peaks.pm,v 1.1 2008/02/13 13:41:22 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $
  $Name $

=cut

"What???";

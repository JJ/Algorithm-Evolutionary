use strict;
use warnings;

=head1 NAME

    Algorithm::Evolutionary::Fitness::MMDP - Massively Multimodal Deceptive Problem

=head1 SYNOPSIS

    my $fitness = Algorithm::Evolutionary::Fitness::MMDP::apply;

=head1 DESCRIPTION

Just a fitness function, it just seemed nice to encapsulate everything here.

=head1 METHODS

=cut

package Algorithm::Evolutionary::Fitness::MMDP;

use base qw(Algorithm::Evolutionary::Fitness::Base);

our @unitation = qw( 1 0 0.360384 0.640576 0.360384 0 1);
use constant BLOCK_SIZE => 6;

=head2 _apply

Applies the MMDP function to a chromosome

=cut

sub _apply {
  my $class = shift;
  my $dude = shift;
  return mmdp( $dude->{_str} );

}

sub mmdp {
  my $str = shift;
  my $fitness = 0;
  for ( my $i = 0; $i < length($str); $i+= BLOCK_SIZE ) {
    my $block = substr( $str, $i, BLOCK_SIZE );
    my $ones = grep ( /1/, split(//,$block));
    $fitness += $unitation[$ones];
  }
  return $fitness;
}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/02/17 13:34:54 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Fitness/MMDP.pm,v 1.3 2008/02/17 13:34:54 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.3 $
  $Name $

=cut

"What???";

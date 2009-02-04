use strict;
use warnings;

=head1 NAME

Algorithm::Evolutionary::Fitness::MMDP - Massively Multimodal Deceptive Problem

=head1 SYNOPSIS

    my $fitness = Algorithm::Evolutionary::Fitness::MMDP::apply;

=head1 DESCRIPTION

Massively Multimodal Deceptive Problem, tough for evolutionary algorithms.

=head1 METHODS

=cut

package Algorithm::Evolutionary::Fitness::MMDP;

our $VERSION = ( '$Revision: 2.1 $ ' =~ /(\d+\.\d+)/ ) ;

use base qw(Algorithm::Evolutionary::Fitness::String);

our @unitation = qw( 1 0 0.360384 0.640576 0.360384 0 1);

use constant BLOCK_SIZE => 6;

sub _really_apply {
  my $self = shift;
  return $self->mmdp( @_ );
}

=head2 mmdp( $string )

Computes the MMDP value for a binary string, storing it in a cache

=cut 

sub mmdp {
    my $self = shift;
    my $string = shift;
    my $cache = $self->{'_cache'};
    if ( $cache->{$string} ) {
	return $cache->{$string};
    }
    my $fitness = 0;
    for ( my $i = 0; $i < length($string); $i+= BLOCK_SIZE ) {
	my $block = substr( $string, $i, BLOCK_SIZE );
	my $ones = grep ( /1/, split(//,$block));
	$fitness += $unitation[$ones];
    }
    $cache->{$string} = $fitness;
    return $fitness;
}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/02/04 20:43:14 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Fitness/MMDP.pm,v 2.1 2009/02/04 20:43:14 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 2.1 $
  $Name $

=cut

"What???";

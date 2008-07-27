use strict; #-*-CPerl-*-
use warnings;

=head1 NAME

    Algorithm::Evolutionary::Utils - Container module with a hodgepodge of functions
                 
=head1 SYNOPSIS
  
  use Algorithm::Evolutionary::Utils qw(entropy);

  my $this_entropy = entropy( $population );

  #Computes consensus sequence (for binary chromosomes
  my $this_consensus = consensus( $population); 

=head1 DESCRIPTION

Miscellaneous class that contains functions that might be useful
    somewhere else, especially when computing EA statistics.  

=cut


=head1 METHODS

=cut

package Algorithm::Evolutionary::Utils;

use Exporter;
our @ISA = qw(Exporter);
our $VERSION = ( '$Revision: 1.5 $ ' =~ /(\d+\.\d+)/ ) ;
our @EXPORT_OK = qw( entropy consensus hamming);

use Carp;

=head2 entropy( $population)

Computes the entropy using the well known Shannon's formula: L<http://en.wikipedia.org/wiki/Information_entropy>
'to avoid botching highlighting

=cut

sub entropy {
  my $population = shift;
  my %frequencies;
  map( (defined $_->Fitness())?$frequencies{$_->Fitness()}++:1, @$population );
  my $entropy = 0;
  my $gente = scalar(@$population); # Population size
  for my $f ( keys %frequencies ) {
    my $this_freq = $frequencies{$f}/$gente;
    $entropy -= $this_freq*log( $this_freq );
  }
  return $entropy;
}


=head2 hamming( $string_a, $string_b )

Computes the number of positions that are different among two strings

=cut

sub hamming {
    my ($string_a, $string_b) = @_;
    return ( ( $string_a ^ $string_b ) =~ tr/\1//);
}

=head2 consensus( $population )

Consensus sequence representing the majoritary value for each bit;
returns the consensus string. 

=cut

sub consensus {
  my $population = shift;
  my @frequencies;
  for ( @$population ) {
      for ( my $i = 0; $i < $_->size(); $i ++ ) {
	  if ( !$frequencies[$i] ) {
	      $frequencies[$i]={ 0 => 0,
			     1 => 0};
	  }
	  $frequencies[$i]->{substr($_->{'_str'}, $i, 1)}++;
      }
  }
  my $consensus;
  for my $f ( @frequencies ) {
      if ( $f->{'0'} > $f->{'1'} ) {
	  $consensus.='0';
      } else {
	  $consensus.='1';
      }
  }
  return $consensus;
}


=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/07/27 16:10:53 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Utils.pm,v 1.5 2008/07/27 16:10:53 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.5 $
  $Name $

=cut

"Still there?";

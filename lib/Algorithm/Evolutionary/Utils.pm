use strict;
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
our $VERSION = ( '$Revision: 1.2 $ ' =~ /(\d+\.\d+)/ ) ;
our @EXPORT_OK = qw( entropy consensus);

use Carp;

=head2 entropy

Computes the entropy using the well known Shannon's formula: L<http://en.wikipedia.org/wiki/Information_entropy>
'to avoid botching highlighting

=cut

sub entropy {
  my $population = shift;
  my %frequencies;
  map( $frequencies{$_->Fitness()}++, @$population );
  my $entropy = 0;
  my $gente = scalar(@$population); # Population size
  for my $f ( keys %frequencies ) {
    my $this_freq = $frequencies{$f}/$gente;
    $entropy -= $this_freq*log( $this_freq );
  }
  return $entropy;
}

=head2 consensus

Consensus sequence representing the majoritary value for each bit

=cut

sub consensus {
  my $population = shift;
  my @frequencies;
  for ( @$population ) {
      for ( my $i = 0; $i < $_->length(); $i ++ ) {
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

  CVS Info: $Date: 2008/04/20 11:03:12 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Utils.pm,v 1.2 2008/04/20 11:03:12 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.2 $
  $Name $

=cut

"Still there?";

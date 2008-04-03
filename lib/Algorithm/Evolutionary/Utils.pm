use strict;
use warnings;

=head1 NAME

    Algorithm::Evolutionary::Utils - Container module with a hodgepodge of functions
                 
=head1 SYNOPSIS
  
  use Algorithm::Evolutionary::Utils qw(entropy);

  my $this_entropy = entropy( $population );

  
=head1 DESCRIPTION

Miscellaneous class that contains functions that might be useful
    somewhere else, especially when computing EA statistics.  

=cut


=head1 METHODS

=cut

package Algorithm::Evolutionary::Utils;

use Exporter;
our @ISA = qw(Exporter);
our $VERSION = ( '$Revision: 1.1 $ ' =~ /(\d+\.\d+)/ ) ;
our @EXPORT_OK = qw( entropy );

use Carp;

=head2 entropy

Computes the entropy using the well known Shannon's formula: L<http://en.wikipedia.org/wiki/Information_entropy>

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

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/04/03 18:37:18 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Utils.pm,v 1.1 2008/04/03 18:37:18 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $
  $Name $

=cut

"Still there?";

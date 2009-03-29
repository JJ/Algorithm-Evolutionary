use strict; #-*-CPerl-*-
use warnings;

use lib qw( ../../../lib );

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
our ($VERSION) = ( '$Revision: 2.6 $ ' =~ /(\d+\.\d+)/ ) ;
our @EXPORT_OK = qw( entropy consensus hamming random_bitstring average parse_xml);

use Carp;
use String::Random;
use XML::Parser;
use Statistics::Basic qw(mean);

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

=head2 consensus( $population, $rough = 0 )

Consensus sequence representing the majoritary value for each bit;
returns the consensus string. If "rough", then the bit is set only if the difference is bigger than 0.4 (70/30 proportion)

=cut

sub consensus {
  my $population = shift;
  my $rough = shift;
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
    if ( !$rough ) {
      if ( $f->{'0'} > $f->{'1'} ) {
	$consensus.='0';
      } else {
	$consensus.='1';
      }
    } else {
      my $difference = abs( $f->{'0'} - $f->{'1'} );
      if ( $difference < 0.4 ) {
	$consensus .= '-';
      } else {
	if ( $f->{'0'} > $f->{'1'} ) {
	  $consensus.='0';
	} else {
	  $consensus.='1';
	}
      }
    }
  }
  return $consensus;
}

=head2 average( $population )

Computes an average of population fitness

=cut

sub average {
  my $population = shift;
  my @frequencies;
  my @fitnesses = map( $_->Fitness(), @$population );
  return mean( @fitnesses );

}

=head2 random_bitstring( $bits )

Returns a random bitstring with the stated number of bits. Useful for testing,mainly

=cut

sub random_bitstring {
  my $bits = shift || croak "No bits!";
  my $generator = new String::Random;
  my $regex = "\[01\]{$bits}";
  return $generator->randregex($regex);
}

=head2 parse_xml( $string ) 

Parses the string and returns an XML tree

=cut

sub parse_xml {
  my $string = shift || croak "No string to parse!\n";
  my $p=new XML::Parser(Style=>'EasyTree');
  $XML::Parser::EasyTree::Noempty=1;
  my $xml_dom = $p->parse($string) || croak "Problems parsing $string: $!\n";
  return $xml_dom;
}


=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/03/29 09:42:41 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Utils.pm,v 2.6 2009/03/29 09:42:41 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 2.6 $
  $Name $

=cut

"Still there?";

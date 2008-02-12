#!/usr/bin/perl

use Test;
BEGIN { plan tests => 5 };

use XML::LibXML;
my $parser = XML::LibXML->new();


use lib qw( ../.. ../../.. .. ); #Just in case we are testing it in-place

my @filesGood = qw( marea.xml royalroad.xml onemax.xml experiment.xml );
my @filesBad = qw( marea-fails.xml );

for ( @filesGood ) {
  skip ( !$parser, validate ( "xml/$_", $parser ) =~ /Validated/, 1 );
}

for ( @filesBad ) {
  skip ( !$parser,  validate ( "xml/$_", $parser ) =~ /error/, 1 );
}

########################################################################

sub validate {
  my $fn = shift;
  my $parser = shift;
  my $doc = $parser->parse_file( $fn );
  eval {
    $doc->validate();
  };
  if ( $@ ) {
    return "Validation error: $@ \n";
  } else {
    return "Validated: ". $doc->toString(). "\n";
  }
}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/02/12 17:49:38 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/t/validate.t,v 1.1 2008/02/12 17:49:38 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $
  $Name $

=cut

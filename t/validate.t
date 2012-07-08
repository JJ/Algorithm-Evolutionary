#!/usr/bin/perl

use Test::More;

eval { require XML::LibXML };

if ($@ ) {
  skip "XML::LibXML not installed";
} else {

    my $parser = XML::LibXML->new();    
    
    use lib qw( ../.. ../../.. .. ); #Just in case we are testing it in-place
    
    my @filesGood = qw( marea.xml royalroad.xml onemax.xml experiment.xml );
    my @filesBad = qw( marea-fails.xml );
    
    for ( @filesGood ) {
	ok ( validate ( "xml/$_", $parser ) =~ /Validated/, "Checks" );
    }
    
    for ( @filesBad ) {
	ok ( validate ( "xml/$_", $parser ) =~ /error/, "Fails" );
    }
    done_testing();
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

  CVS Info: $Date: 2012/07/08 16:27:21 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/t/validate.t,v 3.1 2012/07/08 16:27:21 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 3.1 $
  $Name $

=cut

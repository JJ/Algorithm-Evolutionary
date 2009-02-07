#!/usr/bin/perl

use strict;
use warnings;

#########################
use lib qw( lib ../lib ../../lib  ); #Just in case we are testing it in-place
use Algorithm::Evolutionary::Experiment;


use Test::More tests => 4;
#########################


my @files = qw( marea.xml royalroad.xml onemax.xml experiment.xml );

for ( @files ) {	
  local( $/, *X);
  my $filename = -e "xml/$_"? "xml/$_": "../xml/$_";
  open (X, "<$filename" ) || die "Problems opening $filename: $@\n";
  my $xml = <X>;
  close X;
  my $xp = Algorithm::Evolutionary::Experiment->fromXML( $xml );
  my $popRef = $xp->go();	
  ok ( $popRef->[0]->Fitness() > 0, "XML from $filename" );
}


########################################################################

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/02/07 18:31:28 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/t/run.t,v 2.2 2009/02/07 18:31:28 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 2.2 $
  $Name $

=cut

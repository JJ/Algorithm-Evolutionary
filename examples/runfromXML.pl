#!/usr/bin/perl

use strict;
use warnings;

use Algorithm::Evolutionary::Experiment;
use Algorithm::Evolutionary::Op::Easy;

my $file = shift || die "No XML file\n";
local( $/, *X);
open (X, "<$file" ) || die "Problems opening $file: $@\n";
my $xml = <X>;
close X;
my $xp = Algorithm::Evolutionary::Experiment->fromXML( $xml );
my $popRef;
my $gen=0;
do {
    $popRef = $xp->go();	
    print $gen++, " Best= ", $popRef->[0]->Fitness(), "\n";
} until $popRef->[0]->Fitness() == 64 || $gen == 100;



########################################################################

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/02/12 17:49:38 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/examples/runfromXML.pl,v 1.1 2008/02/12 17:49:38 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $
  $Name $

=cut

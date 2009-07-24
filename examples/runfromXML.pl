#!/usr/bin/perl

use strict;
use warnings;

use lib qw( ../lib lib );
use Algorithm::Evolutionary::Experiment;
use Algorithm::Evolutionary::Op::Easy;
use File::Slurp;

my $xml_file = shift || die "No XML file\n";
my $xml = read_file( $xml_file ) || die "Can't open $xml_file\n";
my $max_fitness = shift || 100;
my $max_generation = shift || 100;

#Create experiment
my $xp = Algorithm::Evolutionary::Experiment->fromXML( $xml );
my $popRef;
my $gen=0;
do {
    $popRef = $xp->go();	
    print $gen++, " Best= ", $popRef->[0]->Fitness(), "\n";
} until $popRef->[0]->Fitness() >= $max_fitness || $gen >= $max_generation;



########################################################################

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/07/24 08:46:58 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/examples/runfromXML.pl,v 3.0 2009/07/24 08:46:58 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 3.0 $
  $Name $

=cut

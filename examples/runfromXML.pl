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

  CVS Info: $Date: 2009/02/04 20:43:13 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/examples/runfromXML.pl,v 2.1 2009/02/04 20:43:13 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 2.1 $
  $Name $

=cut

#!/usr/bin/perl

use strict;
use warnings;
use File::Slurp;

#Check if the fitness in an XML file is correct

my $xml_file = shift || die "No XML\n";
my $xml = read_file( $xml_file) || die "Can't read XML file\n";
my $xp;
eval {
  $xp = Algorithm::Evolutionary::Experiment->fromXML( $xml );
}

  if ( $! ) {
    "Something is wrong with $xml_file: $@\n";
  }

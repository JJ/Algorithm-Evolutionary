#!/usr/bin/perl

=head1 NAME

  process_experiment.pl - processes experiment data created by run_experiment.pl

=head1 SYNOPSIS

  prompt% ./process_experiments.pl ID-DATE.yaml


=head1 DESCRIPTION  

Processes and gets stuff from experiments

=cut

use warnings;
use strict;

use lib qw(lib ../lib);
use YAML qw(LoadFile);
use File::Slurp qw( write_file );
use IO::YAML;

my $yaml_file = shift || die "I need an experiment file, no defaults\n";

my @times;
my @evaluations;
my $results_io = IO::YAML->new($yaml_file, '<') || die "Can't open $yaml_file: $@\n";
my $conf_yaml = <$results_io>; #First is conf
my $conf = YAML::Load($conf_yaml); #Don't use it now, but...
my @generations;
my $counter=0;
while(defined(my $yaml = <$results_io>)) {
  my $these_results = YAML::Load($yaml);
  for my $r ( @$these_results ) {
    push(@{$generations[$counter]->{$r->[1]}}, $r->[2]);
  }
  $counter++;
}
$counter = 0;
for my $g ( @generations ) {
  if ($g->{'Population 1'}) {
    print "* Experiment $counter:\n",
      "\t * Steps Population 1: ", 
	scalar(@{$g->{'Population 1'}}), "\n";
  }
  if ( $g->{'Population 2'}) {
    print "\t * Steps Population 2: ", scalar(@{$g->{'Population 2'}}), "\n";
  }
  $counter++;
}


=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/02/04 20:43:13 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/examples/process_generations.pl,v 2.1 2009/02/04 20:43:13 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 2.1 $
  $Name $

=cut

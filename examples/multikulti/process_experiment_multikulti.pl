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
use IO::YAML;
use Data::Dumper qw(Dumper);

my $yaml_file = shift || die "I need an experiment file, no defaults\n";

my $results_io = IO::YAML->new($yaml_file, '<') || die "Can't open $yaml_file: $@\n";
while(defined(my $yaml = <$results_io>)) {
  print Dumper( $yaml );
}


=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/10/28 13:16:58 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/examples/multikulti/process_experiment_multikulti.pl,v 1.1 2008/10/28 13:16:58 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $
  $Name $

=cut

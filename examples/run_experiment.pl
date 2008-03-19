#!/usr/bin/perl

=head1 NAME

  run_experiments.pl - runs fake_parallel_ga.pl with arguments, and keeps results

=head1 SYNOPSIS

  prompt% ./run_experiments.pl experiment.yaml


=head1 DESCRIPTION  

Runs an experiment a certain number of times, and collates results into a single YAML file, which can be used for analysis

=cut

use warnings;
use strict;

use lib qw(lib ../lib);

use constant PROGRAM_NAME => './fake-parallel-ga.pl';

use YAML qw(LoadFile);
use IO::YAML;
use DateTime;
use Config;

my $params_file = shift || 'experiment.yaml';

my $params = LoadFile( $params_file) || die "Can't load $params_file: $@\n";

my $program_params_file = $params->{'params_file'}.".yaml";
my $program_params =  LoadFile( $program_params_file) || die "Can't load $program_params_file: $@\n";

my $ec_file = $params->{'ec_file'}.".yaml";
my $ec = LoadFile( $ec_file ) || die "Can't load $ec_file: $@\n";
my $result_file = $program_params->{'ID'}.".yaml";
my $io = IO::YAML->new($params->{'ID'}."-".DateTime->now().".yaml", ">");
$ec->{'uname'} = $Config{'myuname'}; # conf stuff
$ec->{'arch'} = $Config{'myarchname'};
print $io $ec;
my $run_string = PROGRAM_NAME." $ec_file $program_params_file";
for my $e ( 1..$params->{'number_of_runs'}) {
  print "Run $e\n";
 
  `$run_string`;
  my @results;
  my $results_io = IO::YAML->new($result_file, '<')  or die "Can't open $result_file: $@\n";  # Open a stream for reading
  while(defined(my $yaml = <$results_io>)) {
    my @these_results = YAML::Load($yaml);
    push @results, @these_results;
  }

  $io->print( \@results  );
}
$io->close();
	    

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/03/19 18:25:48 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/examples/run_experiment.pl,v 1.2 2008/03/19 18:25:48 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.2 $
  $Name $

=cut



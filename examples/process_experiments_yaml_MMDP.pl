#!/usr/bin/perl

=head1 NAME

  process_experiments_text.pl - processes experiment data created by run_experiment.pl

=head1 SYNOPSIS

  prompt% ./process_experiments.pl ID-DATE.yaml


=head1 DESCRIPTION  

Processes and gets stuff from experiments

=cut

use warnings;
use strict;

use lib qw(lib ../lib);
use File::Slurp qw( read_file write_file );
use IO::YAML;
use v5.14;

use Algorithm::Evolutionary::Fitness::MMDP;

my $mmdp = new Algorithm::Evolutionary::Fitness::MMDP;

my $preffix = shift || die "I need an experiment file, no defaults\n";
my $best = shift || die "I need the best result for comparison";

my @times;
my @evaluations;

my @files = glob ( "$preffix*.yaml");
my $successful = 0;

for my $f (@files ) {
  my $results_io = IO::YAML->new($f, '<') || die "Can't open $f: $@\n";
  my $yaml = <$results_io>; #First is conf
  my $res;
  do  {
    $yaml = <$results_io>;
    last if !$yaml;
    $res = YAML::Load($yaml); #Don't use it now, but...
  } until ( $res->{'end'} );
  if ( ref $res->{'end'}{'best'} ne 'ARRAY' ) {
    if ( $mmdp->apply($res->{'end'}{'best'}) eq $best ) {
      $successful++;
      push @times, $res->{'end'}{'time'};
      push @evaluations, $res->{'end'}{'evaluations'};
    }
  } else {
    for my $b ( @{$res->{'end'}{'best'}} ) {
       if ( $mmdp->apply($res->{'end'}{'best'}) eq $best ) {
	 $successful++;
	 push @times, $res->{'end'}{'time'};
	 push @evaluations, $res->{'end'}{'evaluations'};
	 last;
       }
    }
  }
}
print "Success rate ", $successful/ @files;

write_file( "$preffix.times.dat", map("$_\n", @times ));
my $R_var = $preffix;
$R_var  =~ s/-/./g;
write_file( "$preffix.evaluations.dat",map("$_\n", @evaluations ));
write_file( "$preffix.R", "$R_var.evals <- c("
	    .join(",",map("$_", @evaluations )).")\n$R_var.times <- c("
	    .join(",",map("$_", @times )).")\n");

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt


=cut

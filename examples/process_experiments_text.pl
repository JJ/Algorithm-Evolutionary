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

my $preffix = shift || die "I need an experiment file, no defaults\n";
my $best = shift || die "I need the best result for comparison";

my @times;
my @evaluations;

my @files = glob ( "$preffix*.dat");
my $successful = 0;

for my $f (@files ) {
  my $file_content = read_file( $f );
  my ($this_best) =  ($file_content =~ /mejor es:\s+(\w+)/gs);
  $successful += ( $best eq $this_best);
  if ( $best eq $this_best ) {
    my ($time, $evaluations) =  ($file_content =~ /Time:\s+(\S+)\s+Evaluaciones: (\d+)/g);
    push @times, $time;
    push @evaluations, $evaluations;
  }
}
print "Success rate ", $successful/ @files;

write_file( "$preffix.times.dat", map("$_\n", @times ));
write_file( "$preffix.evaluations.dat",map("$_\n", @evaluations ));


=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt


=cut

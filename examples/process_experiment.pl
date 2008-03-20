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
while(defined(my $yaml = <$results_io>)) {
  my $these_results = YAML::Load($yaml);
  my $size = scalar @$these_results;
  my $finish_1 = $these_results->[$size-3]->[1];
  my $finish_2 = $these_results->[$size-2]->[1]; #Yep, it's weird
  push @times, $finish_2->{'Finish'}->{'time'};
  push @evaluations, 
    $finish_2->{'Finish'}->{'evaluations'} +
      $finish_1->{'Finish'}->{'evaluations'};
}
my ($fn, $foo ) = split( /\./, $yaml_file );


write_file( "$fn.times.dat", map("$_\n", @times ));
write_file( "$fn.evaluations.dat",map("$_\n", @evaluations ));

#Extracts array from single key hash
sub extract_content {
  my $hash_ref = shift;
  my @keys = keys %$hash_ref;
  return $hash_ref->{$keys[0]};
}
=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/03/20 10:19:09 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/examples/process_experiment.pl,v 1.3 2008/03/20 10:19:09 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.3 $
  $Name $

=cut

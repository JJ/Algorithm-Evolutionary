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
use YAML;
use Data::Dumper qw(Dumper);

my $files = shift || die "Need a file preffix to glob";

my %results;
while( my $yaml_file = <$files*> ) {
#  print "$yaml_file\n";
  my ( $params ) = ($yaml_file =~ /$files-(\S+)\.yaml/ );
  next if !$params; #this is the params file
  $params =~ s/\-elite\-/_elite_/g;
  $params =~ s/multikulti\-/multikulti_/g;
  $params =~ s/\-none/_none/g;
  my $results_io = IO::YAML->new($yaml_file, '<') || die "Can't open $yaml_file: $@\n";
#  print "Procesando $params\n";
  $results{$params} = [];
  while(defined(my $yaml_str = <$results_io>)) {
    my $this_yaml = Load( $yaml_str ) || die "$yaml_str chungo: $@";
    push @{$results{$params}}, $this_yaml->{'finish'}->[0]->[2]->{'evaluations'};
  }
}

print("nodes;migration;evaluations\n");
for my $r ( keys %results ) {
  my $legend =  $r;
  $legend =~ s/-/;/g;
  print map( "$legend;$_\n", @{$results{$r}} );
  
}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/07/24 08:46:58 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/examples/multikulti/process_experiment_multikulti.pl,v 3.0 2009/07/24 08:46:58 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 3.0 $
  $Name $

=cut

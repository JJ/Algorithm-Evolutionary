#!/usr/bin/perl

use strict;
use warnings;

use IO::YAML;
use YAML;
use Chart::Graph::Gnuplot qw(gnuplot);

my $exp_file = shift || die "No defaults: $0 <file>\n";

my $results_io = IO::YAML->new($exp_file, '<') || die "Can't open $exp_file: $@\n";

my %data;

while(defined(my $yaml = <$results_io>)) {
  my $these_results = Load($yaml);
  if ( $these_results->[1] =~ /Population/ ) {
    my $population = $these_results->[1];
    if ( $these_results->[3]->{'best'} ) {
      push @{$data{$population}}, $these_results->[3]->{'best'}->{'_fitness'};
    } else {
      push @{$data{$population}}, $these_results->[4]->{'best'}->{'_fitness'};
    }
  }
}

my @data_for_gnuplot;
for my $p ( keys %data ) {
    my $i = 0;
    my @indexed_data = map( [$i++, $_], @{$data{$p}});
    push @data_for_gnuplot, [ {'title' => $p,
			       'type' => 'matrix'}, \@indexed_data ]; 
}

gnuplot({'title' => 'foo',
	 'x2-axis label' => 'bar',
	'output type' => 'png',
	'output file' => "$exp_file.png"},
	 @data_for_gnuplot );

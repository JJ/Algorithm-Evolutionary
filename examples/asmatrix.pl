#!/usr/bin/env perl

use strict;
use warnings;
use v5.14;

use File::Slurp qw(read_file write_file);

my $file_name = shift || 'gud-noisy-trap-memory-wilcoxon-history.dat';
my $file = read_file( $file_name );

my @rows = split( /\n/, $file );
my %matrix;
my %keys_x;
my %keys_z;
for my $r ( @rows ) {
  my ($x, $y, $z) = split(/,\s*/, $r );
  $matrix{$x}{$z}++;
  $keys_x{$x}=1;
  $keys_z{$z}=1;
}

say " ,", join(",", sort { $a <=> $b } keys %keys_z );
for my $x ( sort { $a <=> $b } keys %keys_x ) {
  print $x;
  for my $z ( sort { $a <=> $b }  keys %keys_z ) {
    print ",",$matrix{$x}{$z}||0;
  }
  print "\n";
}

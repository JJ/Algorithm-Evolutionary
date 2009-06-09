#!/usr/bin/perl

use strict;
use warnings;
use File::Slurp qw(read_file );

my $filename = shift || die "No file\n";

my $file = read_file ( $filename ) || die "Can't read $filename: $@\n";

my @results = ($file =~ /user\s+0m(\d\.\d+)s/gs);

print join("\n", @results);


#!/usr/bin/perl

use strict;
use warnings;

my $individual = new Algorithm::Evolutionary::Individual::Data_Structure;
for (my $i = 0; $i < $individual->size(); $i ++ ) {
  do_stuff($individual->Atom($i));
}

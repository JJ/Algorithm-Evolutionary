#!/usr/bin/env perl

=head1 NAME

  bitflip.pl - Benchmark for different representations for binary strings

=head1 SYNOPSIS

  prompt% ./bitflip.pl 

or

  prompt% perl bitflip.pl 


=head1 DESCRIPTION  

Does a lot of evaluations, to see if a string or a bit_vector
    based representation is better 

=cut

use lib qw( lib ../lib ../../lib  ); 
use strict;
use warnings;

use v5.14;

use Algorithm::Evolutionary 
  qw(Individual::BitString Op::Bitflip Fitness::ONEMAX);

use Time::HiRes qw( gettimeofday tv_interval );

my $length = 16;
my $iterations = 100000;
my $top_length = 2**16;
my $onemax = new Algorithm::Evolutionary::Fitness::ONEMAX;
do {
    print_format("perl", "BitString", $length, time_onemax( $iterations ));
    $length *= 2;
} while $length <= $top_length;

#--------------------------------------------------------------------
sub time_onemax {
    my $number = shift;
    my $indi = shift;
    my $bitflip = new Algorithm::Evolutionary::Op::Bitflip;
    my $inicioTiempo = [gettimeofday()];
    for (1..$number) {
	my $indi = new Algorithm::Evolutionary::Individual::BitString($length);
	my $fitness = $onemax->apply( $indi );
    }
    return tv_interval( $inicioTiempo ) 
}

sub print_format {
  say "$_[0]-$_[1], ",join(", ", @_[2..3] );
}

#!/usr/bin/env perl

=head1 NAME

  bitflip.pl - Benchmark for different representations for binary strings

=head1 SYNOPSIS

  prompt% ./bitflip.pl 

or

  prompt% perl bitflip.pl 


=head1 DESCRIPTION  

Does a lot of mutations, to see if a string or a bit_vector
    based representation is better 

=cut

use lib qw( lib ../lib ../../lib  ); 
use strict;
use warnings;

use v5.14;

use Algorithm::Evolutionary::Individual::BitString;
use Algorithm::Evolutionary::Individual::Bit_Vector;
use Algorithm::Evolutionary::Op::Bitflip;
use Time::HiRes qw( gettimeofday tv_interval );

my $length = 16;
my $iterations = 100000;
my $top_length = 2**15;
do {
    my $indi = new Algorithm::Evolutionary::Individual::BitString($length);
    print_format("perl", "BitString", $length, time_mutations( $iterations, $indi ));
    $length *= 2;
} while $length <= $top_length;

$length = 16;
do {
    my $indi = Algorithm::Evolutionary::Individual::Bit_Vector->new( {
	length => $length } );
    print_format("perl", "Bit_Vector", $length, time_mutations( $iterations, $indi ));
    $length *= 2;
} while $length <= $top_length;


#--------------------------------------------------------------------
sub time_mutations {
    my $number = shift;
    my $indi = shift;
    my $bitflip = new Algorithm::Evolutionary::Op::Bitflip;
    my $inicioTiempo = [gettimeofday()];
    for (1..$number) {
	$bitflip->apply( $indi );
    }
    return tv_interval( $inicioTiempo ) 
}

sub print_format {
  say join(", ", @_ );
}

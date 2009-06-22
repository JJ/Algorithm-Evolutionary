#!/usr/bin/perl

=head1 NAME

  mamoize.pl - Benchmark for different representations for binary strings

=head1 SYNOPSIS

  prompt% ./memoize.pl 

or

  prompt% perl memoize.pl 


=head1 DESCRIPTION  

Does a lot of mutations, to see if a string based or a bit_vector
    based representation is better 

=cut

use lib qw( lib ../lib ../../lib  ); 

use Algorithm::Evolutionary::Individual::BitString;
use Algorithm::Evolutionary::Op::Bitflip;
use Time::HiRes qw( gettimeofday tv_interval );

my $length = 16;
my $iterations = 1000000;
my $indi = new Algorithm::Evolutionary::Individual::BitString($length);
print "\t $length => ", time_mutations( $iterations, $indi ), "\n";

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

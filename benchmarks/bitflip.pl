#!/usr/bin/perl

=head1 NAME

  bitflip.pl - Benchmark for different representations for binary strings

=head1 SYNOPSIS

  prompt% ./bitflip.pl 

or

  prompt% perl bitflip.pl 


=head1 DESCRIPTION  

Does a lot of mutations, to see if a string based or a bit_vector
    based representation is better 

=cut

use lib qw( lib ../lib ../../lib  ); 

use Algorithm::Evolutionary::Individual::BitString;
use Algorithm::Evolutionary::Individual::Bit_Vector;
use Algorithm::Evolutionary::Op::Bitflip;
use Time::HiRes qw( gettimeofday tv_interval );

my $length = 16;
my $iterations = 1000000;
my $top_length = 16384;
print "Bitsstring\n";
do {
    my $indi = new Algorithm::Evolutionary::Individual::BitString($length);
    print "\t $length => ", time_mutations( $length, $indi ), "\n";
    $length *= 2;
} while $length <= $top_length;

print "Bit_Vector\n";
$length = 16;
do {
    my $indi = Algorithm::Evolutionary::Individual::Bit_Vector->new( {
	length => $length } );
    print "\t $length => ", time_mutations( $length, $indi ), "\n";
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

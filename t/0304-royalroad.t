#-*-cperl-*-
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

#########################

use Test::More tests => 7;

use warnings;
use strict;

use lib qw( ../../lib ../lib lib ); #Just in case we are testing it in-place
use Algorithm::Evolutionary::Individual::BitString;

use_ok( "Algorithm::Evolutionary::Fitness::Royal_Road", "using A::E::Fitness::ONEMAX OK" );

my $block_size=4;
my $rr = new Algorithm::Evolutionary::Fitness::Royal_Road( $block_size );
isa_ok( $rr,  "Algorithm::Evolutionary::Fitness::Royal_Road" );

my $num_bits = 32;
my $indi = new Algorithm::Evolutionary::Individual::BitString $num_bits ; # Build random bitstring with length 10
$indi->{'_str'} .= "1111"; # makes sure it's not 0
ok( $rr->apply( $indi ) > 0, "Works on indis" );
ok( $rr->royal_road( $indi->Chrom())  > 0, "Works on strings" );
ok( $rr->cached_evals() == 1, "Cached evals OK");
my $string = "111101111100";
ok( $rr->royal_road( $string) == 4, "OK count 1" );
$string = "1111011111111";
ok( $rr->royal_road( $string ) == 8, "OK count 2" );


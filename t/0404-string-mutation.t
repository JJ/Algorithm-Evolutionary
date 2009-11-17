#-*-cperl-*-
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

#########################

use warnings;
use strict;

use lib qw( ../../lib ../lib lib ); #Just in case we are testing it in-place

use Test::More tests => 5;

BEGIN { 
  use_ok( 'Algorithm::Evolutionary::Op::String_Mutation' );
};

use Algorithm::Evolutionary::Individual::String;

my $number_of_chars = 32;
my $indi = new Algorithm::Evolutionary::Individual::String [ qw( A B C D E F) ],
  $number_of_chars;

my $sm = new Algorithm::Evolutionary::Op::String_Mutation;
isa_ok( $sm, 'Algorithm::Evolutionary::Op::String_Mutation' );

my $result = $sm->apply( $indi );
isnt( $result, $indi, "Differs from 1");

$sm = new Algorithm::Evolutionary::Op::String_Mutation $number_of_chars / 4;
isa_ok( $sm, 'Algorithm::Evolutionary::Op::String_Mutation' );

$result = $sm->apply( $indi );
isnt( $result, $indi, "Differs from 1");

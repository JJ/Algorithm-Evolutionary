#-*-cperl-*-
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

#########################

use warnings;
use strict;

use lib qw( ../../lib ../lib lib ); #Just in case we are testing it in-place

use Test::More;

BEGIN { 
  use_ok( 'Algorithm::Evolutionary::Op::Shuffle' );
};

use Algorithm::Evolutionary::Individual::String;

my $number_of_chars = 8;
my $sm = new Algorithm::Evolutionary::Op::Shuffle;

isa_ok( $sm, 'Algorithm::Evolutionary::Op::Shuffle' );

my @strings = qw( ABCD EFGHIJ BCDAEFGH ACEF ABCDEF FEDCBA ABCDEFGHIJKLM );
my  $indi;
my  $result;
for my $s (@strings ) {
  $indi = Algorithm::Evolutionary::Individual::String->fromString( $s );

  my $pass = 0;
  for ( 1..100 ) {
    $result = $sm->apply( $indi );
    $pass +=  $result->{'_str'} ne $indi->{'_str'};
  }
  cmp_ok( $pass, ">", 90, "Changes $s almost always");
}

$indi = Algorithm::Evolutionary::Individual::String->fromString( "AAAA" );
$result = $sm->apply( $indi );
is( $result->{'_str'}, $indi->{'_str'}, 
    "What else?");
done_testing();

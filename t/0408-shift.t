#-*-cperl-*-
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

#########################

use warnings;
use strict;

use lib qw( ../../lib ../lib lib ); #Just in case we are testing it in-place

use Test::More;

BEGIN { 
  use_ok( 'Algorithm::Evolutionary::Op::String_Shift' );
};

use Algorithm::Evolutionary::Individual::String;

my $number_of_chars = 8;
my $indi = new Algorithm::Evolutionary::Individual::String [ qw( A B C D E F) ],
  $number_of_chars;

my $sm = new Algorithm::Evolutionary::Op::String_Shift;
isa_ok( $sm, 'Algorithm::Evolutionary::Op::String_Shift' );

my $result;
for ( 1..100 ) {
  $result = $sm->apply( $indi );
  isnt( $result->{'_str'}, $indi->{'_str'}, 
	$result->{'_str'}." differs from ". $indi->{'_str'});

}

$sm = new Algorithm::Evolutionary::Op::String_Shift $number_of_chars * $number_of_chars;
isa_ok( $sm, 'Algorithm::Evolutionary::Op::String_Shift' );

for ( 1..100 ) {
  $result = $sm->apply( $indi );
  isnt( $result->{'_str'}, $indi->{'_str'}, 
	$result->{'_str'}." differs from ". $indi->{'_str'});

}

$sm = new Algorithm::Evolutionary::Op::String_Shift 23;
my @strings = qw( AABA AAHA AABB AABC AABBA );

for my $s (@strings ) {
  $indi = Algorithm::Evolutionary::Individual::String->fromString( $s );

  for ( 1..100 ) {
    $result = $sm->apply( $indi );
    isnt( $result->{'_str'}, $indi->{'_str'}, 
	  $result->{'_str'}." differs from ". $indi->{'_str'});
    
  }
}

$indi = Algorithm::Evolutionary::Individual::String->fromString( "AAAA" );
$result = $sm->apply( $indi );
is( $result->{'_str'}, $indi->{'_str'}, 
    "What else?");
done_testing();

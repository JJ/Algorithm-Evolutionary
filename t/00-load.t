#!perl -T

use Test::More tests => 1;
use lib qw( lib ../lib ../../lib  ); #Just in case we are testing it in-place

BEGIN {
	use_ok( 'Algorithm::Evolutionary' );
}

diag( "Testing Algorithm::Evolutionary $Algorithm::Evolutionary::VERSION, Perl $], $^X" );

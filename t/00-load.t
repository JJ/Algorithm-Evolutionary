#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Algorithm::Evolutionary' );
}

diag( "Testing Algorithm::Evolutionary $Algorithm::Evolutionary::VERSION, Perl $], $^X" );

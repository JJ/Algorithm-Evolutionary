#-*-Perl-*-
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More;
use warnings;
use strict;

BEGIN { plan tests => 8 };
use lib qw( ../../.. ../.. .. ); #Just in case we are testing it in-place

#Use: module name, args to ctor. 
my $primitives = { sum => [2, -1, 1],
		   multiply => [2, -1, 1],
		   substract => [2, -1, 1],
		   divide => [2, -1, 1],
		   x => [0, -10, 10],
		   y => [0, -10, 10] };

my %modulesToTest = ( String => [['a'..'z'],10 ],
		      BitString => [10],
		      Vector => [10],
		      Tree => [$primitives, 3] );

####################################################################
#Subroutine that tests and creates an op. Takes as argument
#the name of the op and a ref-to-array with the arguments to new
####################################################################

sub createAndTest ($$;$) {
  my $module = shift || die "No module name";
  my $newArgs = shift || die "No args";
  
  my $class = "Algorithm::Evolutionary::Individual::$module";
  #require module
  eval " require  $class" || die "Can't load module $class: $@";
  my $nct = new $class @$newArgs; 
  print "Testing $module\n";
  isa_ok( $nct, $class );
  
  my $xml = $nct->asXML();
  my $newnct =  Algorithm::Evolutionary::Individual::Base->fromXML( $xml );
  
  ok( $xml, $newnct->asXML() );
  
  return $nct;
}

###########################################################################

my %indis;
for ( keys %modulesToTest ) {
  my $indi = createAndTest( $_, $modulesToTest{$_});
  $indis{ ref $_ } = $indi;
}

  
=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/02/12 17:49:38 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/t/individuals.t,v 1.1 2008/02/12 17:49:38 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $
  $Name $

=cut

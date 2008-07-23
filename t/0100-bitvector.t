#-*-cperl-*-
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More;
use warnings;
use strict;

use lib qw( lib ../lib ../../lib  ); #Just in case we are testing it in-place

BEGIN { plan tests => 6;
    use_ok('Algorithm::Evolutionary::Individual::Bit_Vector');
};

#Object methods
my $length = 16;
my $indi = new Algorithm::Evolutionary::Individual::Bit_Vector, { length => $length }; # Build random bitstring with length 10
isa_ok( $indi, "Algorithm::Evolutionary::Individual::Bit_Vector" );
ok( $indi->size() == $length, 'Created with length' );
#Class methods
#my @ops = $indi->my_operators;
#is( $ops[0], 'Algorithm::Evolutionary::Op::Crossover', 'Allowed operators' ); 

like( $indi->Atom( 7 ), qr/^\d$/, 'Bits set');       #Returns the value of the 7th character
$indi->Atom( 3, '1' );       #Sets the value
is( $indi->Atom(3), '1', "Value setting" );

my $indi4 = new Algorithm::Evolutionary::Individual::Bit_Vector 
  { string => "0101001100110011010" };

my @array = qw( 0 1 0 1 1 0 1 0 1 0 1 0); #Tie a String individual
tie my @vector, 'Algorithm::Evolutionary::Individual::Bit_Vector', @array;
is( tied( @vector )->Atom(3), '1', 'Tieing');

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/07/23 18:55:08 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/t/0100-bitvector.t,v 1.1 2008/07/23 18:55:08 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $
  $Name $

=cut

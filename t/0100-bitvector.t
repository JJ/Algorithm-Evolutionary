#-*-cperl-*-
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More;
use warnings;
use strict;

use lib qw( lib ../lib ../../lib  ); #Just in case we are testing it in-place

BEGIN { plan tests => 12;
    use_ok('Algorithm::Evolutionary::Individual::Bit_Vector');
};

#Object methods
my $length = 16;
my $indi = Algorithm::Evolutionary::Individual::Bit_Vector->new({ length => $length }); # Build random bitstring with length 10
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

my @array = qw( 0 1 0 1 1 0 1 0 1 0 1 ); #Tie a String individual
tie my @vector, 'Algorithm::Evolutionary::Individual::Bit_Vector', @array;
is( tied( @vector )->Atom(3), '1', 'Tieing '.tied(@vector)->as_string());
is( pop( @vector ), '1', 'Pop '.tied(@vector)->as_string() );
is( shift( @vector), '0', 'Shift '.tied(@vector)->as_string() );
push( @vector, '1' );
is( tied( @vector )->as_string(), '1011010101', 'Push' );
unshift( @vector, '1' );
is( tied( @vector )->as_string(), '11011010101', 'Unshift '.tied(@vector)->as_string() );
$vector[3] = '0';
is( $vector[3], '0', 'Store + fetch '.tied(@vector)->as_string()  );

my @mini_vector = splice( @vector, 2, 3 );
is( join("",@mini_vector), '100', 'Splice '.tied(@vector)->as_string()  );

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/02/04 20:43:15 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/t/0100-bitvector.t,v 2.1 2009/02/04 20:43:15 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 2.1 $
  $Name $

=cut

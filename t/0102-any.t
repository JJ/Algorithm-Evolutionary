#-*-cperl-*-

use Test::More;
use warnings;
use strict;

use lib qw( lib ../lib ../../lib  ); #Just in case we are testing it in-place

BEGIN { plan tests => 2;
    use_ok('Algorithm::Evolutionary::Individual::Any');
};

#Object methods
my @array = qw (1 2 3);
push @array, ['5','6'];
my $indi = new Algorithm::Evolutionary::Individual::Any 'Object::Array', \@array;
isa_ok( $indi, "Algorithm::Evolutionary::Individual::Any" );

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/07/25 11:26:17 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/t/0102-any.t,v 1.1 2008/07/25 11:26:17 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $
  $Name $

=cut

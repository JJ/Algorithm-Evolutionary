#-*-CPerl-*-

#########################
use strict;
use warnings;

use Test::More tests => 2;

use lib qw( lib ../lib ../../lib ); #Just in case we are testing it in-place

use Algorithm::Evolutionary::Individual::BitString;
use Algorithm::Evolutionary::Op::Bitflip;
use Algorithm::Evolutionary::Op::Crossover;
use Algorithm::Evolutionary::Op::Storing;


#########################

# Insert your test code below, the Test module is use()ed here so read
# its man page ( perldoc Test ) for help writing this test script.

my $bs = Algorithm::Evolutionary::Individual::BitString->new(10);

my $bf = new Algorithm::Evolutionary::Op::Bitflip;
my $cs = new Algorithm::Evolutionary::Op::Crossover;

my %population;
$population{ $bs->as_string() } = $bs; #Creates hash

my $storing_bf = new Algorithm::Evolutionary::Op::Storing $bf, \%population;

ok( ref $storing_bf, "Algorithm::Evolutionary::Op::Storing" );

my $result = $storing_bf->apply( $bs );
is( $result->as_string() ne $bs->as_string(), 1, "Results OK" );
  
=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/02/04 20:43:15 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/t/0444-stored.t,v 2.1 2009/02/04 20:43:15 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 2.1 $
  $Name $

=cut

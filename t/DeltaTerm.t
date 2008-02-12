#-*-Perl-*-

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test;
BEGIN { plan tests => 4 };
use lib qw( ../../.. ../.. .. ); #Just in case we are testing it in-place

use Algorithm::Evolutionary::Op::DeltaTerm;
use Algorithm::Evolutionary::Individual::String;

#########################

my $target = 1;
my $delta = 0.1;
my $nct = new Algorithm::Evolutionary::Op::DeltaTerm $target, $delta; 
ok( ref $nct, "Algorithm::Evolutionary::Op::DeltaTerm" );

my $indi= new Algorithm::Evolutionary::Individual::String [0,1], 2;
$indi->Fitness(1);
ok( $nct->apply([$indi]), '' ); #Should return 0
$indi->Fitness(0);
ok( $nct->apply([$indi]), 1 ); #Should return 0

my $xml = $nct->asXML();
my $newnct =  Algorithm::Evolutionary::Op::Base->fromXML( $xml );

ok( $xml, $newnct->asXML() );
  
=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/02/12 17:49:38 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/t/DeltaTerm.t,v 1.1 2008/02/12 17:49:38 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $
  $Name $

=cut

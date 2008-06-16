#-*-Perl-*-

use Test;
BEGIN { plan tests => 3 };
use lib qw( lib ../lib ../../lib  ); #Just in case we are testing it in-place

use Algorithm::Evolutionary::Op::NoChangeTerm;
use Algorithm::Evolutionary::Individual::String;

#########################

my $times = 10;
my $nct = new Algorithm::Evolutionary::Op::NoChangeTerm $times; 
ok( ref $nct, "Algorithm::Evolutionary::Op::NoChangeTerm" );

my $indi= new Algorithm::Evolutionary::Individual::String [0,1], 2;
$indi->Fitness(10);
for ( my $i = 0; $i < $times; $i++ ) {
  $nct->apply([$indi]);
}
ok( $nct->apply([$indi]), '' ); #Should return 0

my $xml = $nct->asXML();
my $newnct =  Algorithm::Evolutionary::Op::Base->fromXML( $xml );

ok( $xml, $newnct->asXML() );
  
=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/06/16 18:43:20 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/t/NoChangeTerm.t,v 1.2 2008/06/16 18:43:20 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.2 $
  $Name $

=cut

#-*-CPerl-*-

use Test::More tests => 4;
use lib qw( lib ../lib ../../lib  ); #Just in case we are testing it in-place

use Algorithm::Evolutionary::Op::Convergence_Terminator;
use Algorithm::Evolutionary::Individual::String;
use Clone::Fast qw( clone );

#########################

my $nct = new Algorithm::Evolutionary::Op::Convergence_Terminator 0.5; 
ok( ref $nct, "Algorithm::Evolutionary::Op::Convergence_Terminator" );

my @pop;
for ( 1..4 ) {
    my $indi= new Algorithm::Evolutionary::Individual::String [0,1], 8;
    push @pop, $indi;
}

is( $nct->apply(\@pop ), 0, 'Not yet' ); #Should return 0

for ( 1..4 ) {
    my $indi = clone( $pop[0]);
    push @pop, $indi;
}

is( $nct->apply(\@pop ), 1, 'Now' ); #Should return 0
my $xml = $nct->asXML();
my $newnct =  Algorithm::Evolutionary::Op::Base->fromXML( $xml );

ok( $xml, $newnct->asXML() );
  
=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/03/29 17:32:11 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/t/0501-convergence-term.t,v 1.1 2009/03/29 17:32:11 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $
  $Name $

=cut

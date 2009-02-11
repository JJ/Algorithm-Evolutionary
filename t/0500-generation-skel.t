#-*-CPerl-*-

#########################
use strict;
use warnings;

use Test;
BEGIN { plan tests => 3 };
use lib qw( lib ../lib ../../lib ); #Just in case we are testing it in-place

use Algorithm::Evolutionary qw( Individual::BitString 
				Op::Mutation Op::Crossover
				Op::RouletteWheel
				Fitness::ONEMAX Op::Generation_Skeleton
				Op::Replace_Worst);

use Algorithm::Evolutionary::Utils qw(average);

#########################

my $onemax = new Algorithm::Evolutionary::Fitness::ONEMAX;

my @pop;
my $number_of_bits = 20;
my $population_size = 20;
my $replacement_rate = 0.5;
for ( 1..$population_size ) {
  my $indi = new Algorithm::Evolutionary::Individual::BitString $number_of_bits ; #Creates random individual
  $indi->evaluate( $onemax );
  push( @pop, $indi );
}

my $m =  new Algorithm::Evolutionary::Op::Mutation 0.5;
my $c = new Algorithm::Evolutionary::Op::Crossover; #Classical 2-point crossover

my $selector = new Algorithm::Evolutionary::Op::RouletteWheel $population_size; #One of the possible selectors

my $generation = 
  new Algorithm::Evolutionary::Op::Generation_Skeleton( $onemax, $selector, [$m, $c], $replacement_rate );

my @sortPop = sort { $b->Fitness() <=> $a->Fitness() } @pop;
my $bestIndi = $sortPop[0];
my $previous_average = average( \@sortPop );
$generation->apply( \@sortPop );
ok( $bestIndi->Fitness() <= $sortPop[0]->Fitness(), 1 ); #fitness
                                                         #improves,
                                                         #but not
                                                         #always 
#This should have improved...
my $this_average = average( \@sortPop );
ok( $previous_average < $this_average , 1 );

my $replacer = new Algorithm::Evolutionary::Op::Replace_Worst; 

my $new_generation = 
  new Algorithm::Evolutionary::Op::Generation_Skeleton( $onemax, $selector, [$m, $c], $replacement_rate, $replacer );

$new_generation->apply( \@sortPop );
ok( $this_average < average( \@sortPop) , 1 );

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/02/11 12:38:14 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/t/0500-generation-skel.t,v 2.4 2009/02/11 12:38:14 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 2.4 $
  $Name $

=cut

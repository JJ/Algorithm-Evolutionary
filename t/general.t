#-*-CPerl-*-

#########################
use strict;
use warnings;

use Test;
BEGIN { plan tests => 43 };
use lib qw( lib ../lib ../../lib ); #Just in case we are testing it in-place

use Algorithm::Evolutionary::Individual::String;
use Algorithm::Evolutionary::Individual::BitString;
use Algorithm::Evolutionary::Individual::Vector;
use Algorithm::Evolutionary::Individual::Tree;
use Algorithm::Evolutionary::Fitness::ONEMAX;

#########################

# Insert your test code below, the Test module is use()ed here so read
# its man page ( perldoc Test ) for help writing this test script.

#String
print "Testing Individual objects...String \n";
ok( ref Algorithm::Evolutionary::Individual::String->new(['a'..'z'],10), "Algorithm::Evolutionary::Individual::String" );
ok( ref Algorithm::Evolutionary::Individual::Base::create( 'String', { chars => ['a'..'e'], length => 10 }), "Algorithm::Evolutionary::Individual::String" );

#Bitstring - 3 & 4
print "BitString...\n";
ok( ref Algorithm::Evolutionary::Individual::BitString->new(10), "Algorithm::Evolutionary::Individual::BitString" );
ok( ref Algorithm::Evolutionary::Individual::Base::create( 'BitString', { length => 10 }), "Algorithm::Evolutionary::Individual::BitString" );

#Vector - 5..7
print "Vector...\n";
ok( ref Algorithm::Evolutionary::Individual::Vector->new(10), "Algorithm::Evolutionary::Individual::Vector" );
ok( ref Algorithm::Evolutionary::Individual::Base::create( 'Vector', 
							   { length => 20,
							     rangestart => -5,
							     rangeend => 5 }), "Algorithm::Evolutionary::Individual::Vector" );

my $primitives = { sum => [2, -1, 1],
		   multiply => [2, -1, 1],
		   substract => [2, -1, 1],
		   divide => [2, -1, 1],
		   x => [0, -10, 10],
		   y => [0, -10, 10] };

ok( ref Algorithm::Evolutionary::Individual::Tree->new( $primitives, 3 ), "Algorithm::Evolutionary::Individual::Tree" );

##############################
print "Individual XML tests\n"; # 8..10
use XML::Parser;
use XML::Parser::EasyTree;
my $p=new XML::Parser(Style=>'EasyTree');
$XML::Parser::EasyTree::Noempty=1;

my $xml =<<EOC;
<indi type='String'>
    <atom>a</atom><atom>z</atom><atom>q</atom><atom>t</atom><atom>L</atom><atom>i</atom><atom>h</atom>
</indi>
EOC
my $ref = $p->parse($xml); #This is an XML::Parser::EasyTree class

ok( ref Algorithm::Evolutionary::Individual::Base->fromXML( $ref  ), "Algorithm::Evolutionary::Individual::String" );
$xml =<<EOC;
<indi type='Vector'>
    <atom>1</atom><atom>2</atom><atom>3</atom><atom>4</atom><atom>5</atom>
</indi>
EOC
$ref = $p->parse($xml); #This is an XML::Parser::EasyTree class
ok( Algorithm::Evolutionary::Individual::Base->fromXML( $ref  )->{_array}[4], 5 );

$xml=<<EOC;
<section name='indi'> 
   <param name='type' value='BitString' /> 
   <param name='length' value='64' />
</section>
EOC
$ref = $p->parse($xml);
my $bs = Algorithm::Evolutionary::Individual::Base->fromParam( $ref->[0]{content}  );
ok( ref $bs, "Algorithm::Evolutionary::Individual::BitString" );

my $fitness = sub {
  my $indi = shift;
  return unpack("N", pack("B32", substr("0" x 32 . $indi->{'_str'}, -32)));
};

ok( $bs->evaluate( $fitness ) > 0, 1, "Evaluation correct");
my $fitness_obj = new Algorithm::Evolutionary::Fitness::ONEMAX;
ok( $bs->evaluate( $fitness_obj ) > 0, 1,  "Evaluation object correct" );

#Test operators - 11 and following

print "Op tests\n";
use Algorithm::Evolutionary::Op::Mutation;
my $m =  new Algorithm::Evolutionary::Op::Mutation 0.5;
ok( ref $m, "Algorithm::Evolutionary::Op::Mutation" );
ok( $bs->{_str} ne $m->apply($bs)->{_str}, 1); 

use Algorithm::Evolutionary::Op::Bitflip;
my $bf =  new Algorithm::Evolutionary::Op::Bitflip 10;
ok( ref $bf, "Algorithm::Evolutionary::Op::Bitflip" );

ok( $bs->{_str} ne $bf->apply($bs)->{_str}, 1); 

use Algorithm::Evolutionary::Op::Crossover;
my $x =  new Algorithm::Evolutionary::Op::Crossover 2;
ok( ref $x, "Algorithm::Evolutionary::Op::Crossover" );

my $bprime = new Algorithm::Evolutionary::Individual::String ['a'..'z'], 64;
skip( $x->apply( $bs, $bprime )->{_str} ne $bs->{_str}, 1 );

use Algorithm::Evolutionary::Op::GaussianMutation;
my $g =  new Algorithm::Evolutionary::Op::GaussianMutation;
ok( ref $g, "Algorithm::Evolutionary::Op::GaussianMutation" );

my $v = new Algorithm::Evolutionary::Individual::Vector 10, -5, 5;;
ok( $v->Atom(3) != $g->apply( $v )->Atom(3), 1);

use Algorithm::Evolutionary::Op::TreeMutation;
my $t =  new Algorithm::Evolutionary::Op::TreeMutation 0.5;
ok( ref $t, "Algorithm::Evolutionary::Op::TreeMutation" );

my $tv = Algorithm::Evolutionary::Individual::Tree->new($primitives, 4);
skip( $tv->asString() ne $t->apply( $tv )->asString(), 1);

use Algorithm::Evolutionary::Op::VectorCrossover;
my $vx =  new Algorithm::Evolutionary::Op::VectorCrossover 2;
ok( ref $vx, "Algorithm::Evolutionary::Op::VectorCrossover" );

my $v2 = new Algorithm::Evolutionary::Individual::Vector 10, -5, 5;
my $ok = 1;
for ( my $i = 0; $i < 10; $i++ ) {
  my $vclone = $v->clone();
  $ok &&= ( $v2->asString()  ne $vx->apply( $vclone, $v2 )->asString() );
}
skip( $ok, 1); #might happen, if the two points span the whole chrom

use Algorithm::Evolutionary::Op::CX;
my $cx =  new Algorithm::Evolutionary::Op::CX;
ok( ref $cx, "Algorithm::Evolutionary::Op::CX" );

my $i1 = Algorithm::Evolutionary::Individual::Vector->fromString( "1,2,3,4,5");
my $i2 = Algorithm::Evolutionary::Individual::Vector->fromString( "5,4,3,2,1");
ok( $i2->asString()  ne $cx->apply( $i1, $i2 )->asString(), 1);

use Algorithm::Evolutionary::Op::ChangeLengthMutation;
my $clm =  new Algorithm::Evolutionary::Op::ChangeLengthMutation;
ok( ref $clm, "Algorithm::Evolutionary::Op::ChangeLengthMutation" );
ok( $bs->asString()  ne $clm->apply( $bs )->asString(), 1);

use Algorithm::Evolutionary::Op::ArithCrossover;
my $ax =  new Algorithm::Evolutionary::Op::ArithCrossover;
ok( ref $ax, "Algorithm::Evolutionary::Op::ArithCrossover" );

ok( $v2->asString()  ne $ax->apply( $v, $v2 )->asString(), 1);

use Algorithm::Evolutionary::Op::Inverover;
my $ix =  new Algorithm::Evolutionary::Op::Inverover;
ok( ref $ix, "Algorithm::Evolutionary::Op::Inverover" );
ok( $i2->asString()  ne $ix->apply( $i1, $i2 )->asString(), 1);

use Algorithm::Evolutionary::Op::IncMutation;
my $im =  new Algorithm::Evolutionary::Op::IncMutation;
ok( ref $im, "Algorithm::Evolutionary::Op::IncMutation" );
skip( $bs->asString()  ne $im->apply( $bs )->asString(), 1); # Might fail

print "Testing algorithms\n";

#test 33
use Algorithm::Evolutionary::Op::LinearFreezer;
use Algorithm::Evolutionary::Op::SimulatedAnnealing;

$m  = new Algorithm::Evolutionary::Op::Bitflip; #Changes a single bit
my $initTemp = 2;
my $minTemp = 0.1;
my $freezer = new Algorithm::Evolutionary::Op::LinearFreezer( $initTemp );
my $numChanges = 7;
my $eval =  
  sub {
    my $indi = shift;
    my ( $x, $y ) = @{$indi->{_array}};
    my $sqrt = sqrt( $x*$x+$y*$y);
    return sin( $sqrt )/$sqrt;
  };
my $sa = new Algorithm::Evolutionary::Op::SimulatedAnnealing( $eval, $m, $freezer, $initTemp, $minTemp,  );
ok( ref $sa, 'Algorithm::Evolutionary::Op::SimulatedAnnealing' );

#test 34
my $c = new Algorithm::Evolutionary::Op::Crossover; #Classical 2-point crossover
my $replacementRate = 0.3;	#Replacement rate
use Algorithm::Evolutionary::Op::RouletteWheel;
my $popSize = 20;
my $selector = new Algorithm::Evolutionary::Op::RouletteWheel $popSize; #One of the possible selectors
use Algorithm::Evolutionary::Op::GeneralGeneration;
my $onemax = sub { 
  my $indi = shift;
  my $total = 0;
  my $len = $indi->size();
  my $i = 0;
  while ($i < $len ) {
    $total += substr($indi->{'_str'}, $i, 1);
    $i++;
  }
  return $total;
};
my @pop;
my $numBits = 20;
for ( 0..$popSize ) {
  my $indi = new Algorithm::Evolutionary::Individual::BitString $numBits ; #Creates random individual
  my $fitness = $onemax->( $indi );
  $indi->Fitness( $fitness );
  push( @pop, $indi );
}

#test utils
use Algorithm::Evolutionary::Utils qw(entropy consensus);
ok( entropy( \@pop ) > 0, 1 );
ok( length(consensus( \@pop )) > 1, 1 );

#fitness
my $generation = 
  new Algorithm::Evolutionary::Op::GeneralGeneration( $onemax, $selector, [$m, $c], $replacementRate );
my @sortPop = sort { $b->Fitness() <=> $a->Fitness() } @pop;
my $bestIndi = $sortPop[0];
$generation->apply( \@sortPop );
ok( $bestIndi->Fitness() <= $sortPop[0]->Fitness(), 1 ); #fitness improves, but not always

my $ggxml = $generation->asXML();
my $gprime =  Algorithm::Evolutionary::Op::Base->fromXML( $ggxml );
ok( $gprime->{_eval}( $pop[0] ) eq $generation->{_eval}( $pop[0] ) , 1 ); #Code snippets will never be exactly the same.

#Test 33 & 34
use Algorithm::Evolutionary::Op::Easy;
my $ez = new Algorithm::Evolutionary::Op::Easy $onemax;
  
my $ezxml = $ez->asXML();
my $ezprime = Algorithm::Evolutionary::Op::Base->fromXML( $ezxml );
ok( $ezprime->{_eval}( $pop[0] ) eq $ez->{_eval}( $pop[0] ) , 1 ); #Code snippets will never be exactly the same.
my $oldBestFitness = $bestIndi->Fitness();
$ez->apply( \@sortPop );
ok( $sortPop[0]->Fitness() >= $oldBestFitness, 1);
  
#Test 35 & 36
use Algorithm::Evolutionary::Op::GenerationalTerm;
my $g100 = new Algorithm::Evolutionary::Op::GenerationalTerm 10;
use Algorithm::Evolutionary::Op::FullAlgorithm;
my $f = new Algorithm::Evolutionary::Op::FullAlgorithm $generation, $g100;
  
my $fxml = $f->asXML();
my $txml = $f->{_terminator}->asXML();
my $fprime = Algorithm::Evolutionary::Op::Base->fromXML( $fxml );
ok( $txml eq $fprime->{_terminator}->asXML() , 1 ); #Code snippets will never be exactly the same.
$oldBestFitness = $bestIndi->Fitness();
for ( @sortPop ) {
  if ( !defined $_->Fitness() ) {
    my $fitness = $onemax->( $_ );
    $_->Fitness( $fitness );
  }
}
$f->apply( \@sortPop );
ok( $sortPop[0]->Fitness() >= $oldBestFitness, 1);
  
=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/07/24 18:57:36 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/t/general.t,v 1.9 2008/07/24 18:57:36 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.9 $
  $Name $

=cut

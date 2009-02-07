#-*-CPerl-*-

use Test::More;
BEGIN { plan tests => 10 };
use lib qw( lib ../lib ../../lib  ); #Just in case we are testing it in-place

use Algorithm::Evolutionary::Experiment;
use Algorithm::Evolutionary::Op::Easy;

#########################
my $onemax = sub { 
  my $indi = shift;
  my $total = 0;
  my $len = $indi->length();
  my $i;
  while ($i < $len ) {
	$total += substr($indi->{'_str'}, $i, 1);
	$i++;
  }
  return $total;
};

my $ez = new Algorithm::Evolutionary::Op::Easy $onemax;
my $popSize = 20;
my $indiType = 'BitString';
my $indiSize = 64;

my $e = new Algorithm::Evolutionary::Experiment $popSize, $indiType, $indiSize, $ez;
isa_ok ( $e, 'Algorithm::Evolutionary::Experiment' ); # test 1

my $xml=<<'EOC';
<ea version='0.4'>

  <initial>
    <op name='Creator'>
       <param name='number' value='20' />
       <param name='class' value='BitString' /> 
       <param name='options'>
          <param name='length' value='64' />
       </param>
    </op>

    <op name='Easy'  type='unary'>
        <param name='selrate' value='0.4' />
        <param name='maxgen' value='1' />
        <code type='eval' language='perl'>
    	  <src><![CDATA[ my $chrom = shift;
                my $str = $chrom->Chrom();
                my $fitness = 0;
                my $blockSize = 4;
                for ( my $i = 0; $i < length( $str ) / $blockSize; $i++ ) {
	              my $block = 1;
	              for ( my $j = 0; $j < $blockSize; $j++ ) {
	                $block &= substr( $str, $i*$blockSize+$j, 1 );
	              }
	              ( $fitness += $blockSize ) if $block;
                }
                return $fitness;
          ]]></src>
        </code>
        <op name='Bitflip' type='unary' rate='1'>
            <param name='probability' value='0.5' />
            <param name='howMany' value='1' />
      	</op>
      	<op name='Crossover' type='binary' rate='5'>
        	<param name='numPoints' value='2' />
      	</op>
    </op>
    
    
  </initial>

</ea>
EOC
  my $e2 = Algorithm::Evolutionary::Experiment->fromXML( $xml );
  isa_ok( $e2, 'Algorithm::Evolutionary::Experiment' ); # Test 2
  isa_ok( $e2->{_algo}[1], 'Algorithm::Evolutionary::Op::Easy' ); # Test 3 
  my $popRef = $e2->go();
  ok( scalar @{$popRef} == 20 ); # Test 4

  my $xpxml = $e2->asXML();
  my $bke2 = Algorithm::Evolutionary::Experiment->fromXML( $xpxml );
  ok ( scalar @{$bke2->{_pop}} == 20 ); # Test 5

  my $testfile = (-e "xml/marea.xml")?"xml/marea.xml":"../xml/marea.xml"; # Test in-place
  open( I, "<$testfile" ) || die "Can't open $testfile";
  my $xml2 = join( "", <I> );
  close I;
  my $mxp =  Algorithm::Evolutionary::Experiment->fromXML( $xml2 );
  isa_ok( $mxp, 'Algorithm::Evolutionary::Experiment' ); # Test 6
  isa_ok( $mxp->{_algo}[1], 'Algorithm::Evolutionary::Op::Easy' ); # Test 7
  $popRef = $mxp->go();
  ok( scalar  @{$popRef} == 20 );# Test 8

  #Check with an initial population
  $testfile = (-e "xml/onemax.xml")?"xml/onemax.xml":"../xml/onemax.xml"; # Test in-place
  open( I, "<$testfile" ) || die "Can't open $testfile";
  my $xml3 = join( "", <I> );
  close I;
  my $oxp =  Algorithm::Evolutionary::Experiment->fromXML( $xml3 );
  isa_ok( $oxp, 'Algorithm::Evolutionary::Experiment' ); # Test 9
  isa_ok( $oxp->{_algo}[1], 'Algorithm::Evolutionary::Op::Easy' ); # Test 10

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/02/07 18:31:28 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/t/experiment.t,v 2.2 2009/02/07 18:31:28 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 2.2 $
  $Name $

=cut

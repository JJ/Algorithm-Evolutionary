use strict; #-*-CPerl-*- -*- hi-lock -*- 
use warnings;

use lib qw( ../../../lib );

=head1 NAME

Algorithm::Evolutionary::Experiment - Class for setting up an
experiment with algorithms and population 

=head1 SYNOPSIS
  
  use Algorithm::Evolutionary::Experiment;
  my $popSize = 20;
  my $indiType = 'BitString';
  my $indiSize = 64;
  
  #Algorithm might be anything of type Op
  my $ex = new Algorithm::Evolutionary::Experiment $popSize, $indiType, $indiSize, $algorithm; 


=head1 DESCRIPTION

Experiment contains an algorithm and a population, and applies one to
the other. Contains both as instance variables. Can be serialized
using XML, and can read an XML description of the experiment. 

=head1 METHODS

=cut

package Algorithm::Evolutionary::Experiment;

use Algorithm::Evolutionary::Utils qw(parse_xml);
use Algorithm::Evolutionary::Individual::Base;
use Algorithm::Evolutionary::Op::Base;
use Algorithm::Evolutionary::Op::Creator;

our ($VERSION) = ( '$Revision: 3.0 $ ' =~ / (\d+\.\d+)/ ) ;

use Carp;

=head2 new( $pop_size, $type_of_individual, $individual_size )

Creates a new experiment. An C<Experiment> has two parts: the
   population and the algorithm. The population is created from a set
   of parameters: popSize, indiType and indiSize, and an array of
   algorithms that will be applied sequentially. Alternatively, if
   only operators are passed as an argument, it is understood as an
   array of algorithms (including, probably, initialization of the
   population).

=cut

sub new ($$$$;$) {
  my $class = shift;
  my $self = { _pop => [] };
  if ( index ( ref $_[0], 'Algorithm::Evolutionary') == -1 )   {  
    #If the first arg is not an algorithm, create one
    my $popSize = shift || carp "Pop size = 0, can't create\n";
    my $indiType = shift || carp "Empty individual class, can't create\n";
    my $indiSize = shift || carp "Empty individual size, no reasonable default, can't create\n";
    for ( my $i = 0; $i < $popSize; $i ++ ) {
      my $indi = Algorithm::Evolutionary::Individual::Base::new( $indiType, 
								 { length => $indiSize } );
      $indi->randomize();
      push @{$self->{_pop}}, $indi;
    }
  };
  @_ || croak "Can't find an algorithm";
  push @{$self->{_algo}}, @_;
  bless $self, $class;
  return $self
  
}

=head2 fromXML

Creates a new experiment, same as before, but with an XML specification. An 
example of it follows:

 <ea xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:noNamespaceSchemaLocation='ea-alpha.xsd'
    version='0.2'>

  <initial>
    <pop size='20'>
       <section name='indi'> 
          <param name='type' value='BitString' /> 
          <param name='length' value='64' />
       </section>
    </pop>

    <op name='Easy'  type='unary'>
        <param name='selrate' value='0.4' />
        <param name='maxgen' value='100' />
        <code type='eval' language='perl'>
    	  <src><![CDATA[ #source goes here ]]>
          </src>
        </code>
        <op name='GaussianMutation' type='unary' rate='1'>
        	<param name='avg' value='0' />
			<param name='stddev' value='0.1' />
      	</op>
      	<op name='VectorCrossover' type='binary' rate='1'>
        	<param name='numpoints' value='1' />
      	</op>
    </op>
    
    
  </initial>

 </ea>
 
 This is an alternative constructor. Takes a well-formed string with the XML
 spec, which should have been done according to EvoSpec 0.3, or the same
 string processed with C<XML::Parser::EasyTree>, and returns a built experiment

=cut

sub fromXML ($;$) {
  my $class = shift;
  my $xml = shift || carp "XML fragment missing ";
  if ( ref $xml eq ''  ) { #We are receiving a string, parse it
    $xml = parse_xml( $xml );
  }

  my @pop;
  my $self = { _pop => \@pop, #Just an empty reference
	       _xml => $xml }; # Create a reference
  #Process operators
  for ( @{ ref $xml->{'ea'}->{'initial'}->{'op'} eq 'ARRAY' ?
	 $xml->{'ea'}->{'initial'}->{'op'}:
	   [ $xml->{'ea'}->{'initial'}->{'op'}]} ) { #Should process the <initial> tag
    push( @{$self->{'_algo'}}, 
	  Algorithm::Evolutionary::Op::Base::fromXML( $_->{'-name'},$_ ) );
  }

  #Process population
  if ( $xml->{'ea'}->{'initial'}->{'pop'} ) {
    my $pop_hash = $xml->{'ea'}->{'initial'}->{'pop'};
    my $size = $pop_hash->{'-size'};
    my $type;
    my %params;
    for my $p ( @{$pop_hash->{'param'}} ) {
      if ( $p->{'-name'} eq 'type' ) {
 	$type = $p->{'-value'};
      } else {
 	$params{ $p->{'-name'} } = $p->{'-value'};
      }
    }
    my $creator = new Algorithm::Evolutionary::Op::Creator  $size, $type, \%params ;
    
     $creator->apply( \@pop );
     push( @{$self->{_pop}}, @pop ) ;
  }

  #Process population, if it exists
  if ( $xml->{'ea'}->{'pop'} ) { #Process runtime population
    for my $i (  @{$xml->{'ea'}->{'pop'}->{'indi'}} ) { 
      push( @{$self->{_pop}}, 
	    Algorithm::Evolutionary::Individual::Base::fromXML( $i->{'-type'}, $i ) );
    }
  }
  #Bless and return
  bless $self, $class;

  return $self;
}


=head2 go

Applies the different operators in the order that they appear; returns the population
as a ref-to-array.

=cut

sub go {
  my $self = shift;
  for ( @{$self->{_algo}} ) {
	$_->apply( $self->{_pop} );
  }
  return $self->{_pop}
}

=head2 asXML
 
Opposite of fromXML; serializes the object in XML. First the operators, and then
the population

=cut

sub asXML {
  my $self = shift;
  my $str=<<'EOC';
<ea version='0.4'>
<!-- Serialization of an Experiment object. Generated automatically by
     Experiment $Revision: 3.0 $ -->
    <initial>
EOC

  for ( @{$self->{_algo}} ) {
	$str.= $_->asXML()."\n";
  }
  
  $str .="\t</initial>\n<!-- Population --><pop>\n";
   for ( @{$self->{_pop}} ) {
	$str .= $_->asXML()."\n";
  }
  $str .="\n\t</pop>\n</ea>\n";
  return $str;
}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/07/24 08:46:59 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Experiment.pm,v 3.0 2009/07/24 08:46:59 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 3.0 $
  $Name $

=cut

"What???";

use strict;
use warnings;

=head1 NAME

Algorithm::Evolutionary::Individual::Base - Base class for chromosomes that knows how to build them, and has some helper methods.
                 
=head1 SYNOPSIS

  use  Algorithm::Evolutionary::Individual::Base;
  my $xmlStr="<indi type='BitString'><atom>1</atom><atom>0</atom><atom>1</atom><atom>0</atom></indi>";
  my $ref = XMLin($xmlStr);

  my $binIndi2 = Algorithm::Evolutionary::Individual::Base->fromXML( $ref ); #From XML fragment
  print $binIndi2->asXML();

  my $indi = Algorithm::Evolutionary::Individual::Base->fromParam( $ref->{initial}{section}{indi}{param} ); #From parametric description

  $binIndi2->Fitness( 3.5 ); #Sets or gets fitness
  print $binIndi2->Fitness();

  my $emptyIndi = new Algorithm::Evolutionary::Individual::Base;

=head1 DESCRIPTION

Base class for individuals, that is, "chromosomes" in evolutionary computation algorithms. However, chromosomes needn't be bitstrings, so the name is a bit misleading. This is, however, an "empty" base class, that acts as a boilerplate for deriving others. 

=cut

package Algorithm::Evolutionary::Individual::Base;

use XML::Parser;
use XML::Parser::EasyTree;
use YAML qw(Dump Load LoadFile);
use Carp;

our ($VERSION) = ( '$Revision: 1.11 $ ' =~ / (\d+\.\d+)/ );

use constant MY_OPERATORS => qw(None);

=head1 METHODS 

=head2 new( $options )

Creates a new Base individual of the required class, with a fitness, and sets fitnes to undef.
Takes as params a hash to the options of the individual, that will be passed
on to the object of the class when it iss initialized.

=cut

sub new {
  my $class = shift;
  if ( $class !~ /Algorithm::Evolutionary/ ) {
    $class = "Algorithm::Evolutionary::Individual::$class";
  }
  my $options = shift;
  my $self = { _fitness => undef }; # Avoid error
  bless $self, $class; # And bless it

  #If the class is not loaded, we load it. The 
  if ( !$INC{"$class\.pm"} ) {
    eval "require $class" || croak "Can't find $class Module";
  }
  if ( $options ) {
	$self->set( $options );
  }

  return $self;
}

=head2 create( $ref_to_hash )

Creates a new random string, but uses a different interface: takes a
ref-to-hash, with named parameters, which gives it a common interface
to all the hierarchy. The main difference with respect to new is that
after creation, it is initialized with random values.

=cut

sub create {
  my $class = shift; 
  my $ref = shift ||  croak "Can't find the parameters hash";
  my $self = Algorithm::Evolutionary::Individual::Base::new( $class, $ref );
  $self->randomize();
  return $self;
}

=head2 set( $ref_to_hash )

Sets values of an individual; takes a hash as input. Keys are prepended an
underscore and turn into instance variables

=cut

sub set {
  my $self = shift; 
  my $hash = shift || croak "No params here";
  for ( keys %{$hash} ) {
    $self->{"_$_"} = $hash->{$_};
  }
}

=head2 fromXML( $xml_string )

Takes a definition in the shape <indi><atom>....</indi><fitness></fitness></indi> and turns it into a bitstring, 
if it knows how to do it. The definition must have been processed using XML::Simple. It forwards stuff it does 
not know about to the corresponding subclass, which should implement the C<set> method. The class it refers
about is C<require>d in runtime.

=cut

sub fromXML {
  my $class = shift;
  my $xml = shift || croak "XML fragment missing ";
  if ( ref $xml eq ''  ) { #We are receiving a string, parse it
    my $p=new XML::Parser(Style=>'EasyTree');
    $XML::Parser::EasyTree::Noempty=1;
    $xml = $p->parse($xml);
  }

  my $thisClassName = $xml->[0]{attrib}{type};
  if ( $class eq  __PACKAGE__ ) { #Deduct class from the XML
    $class = $thisClassName || shift || croak "Class name missing";
  }

  #Calls new, adds preffix if it's not there
  my $self = Algorithm::Evolutionary::Individual::Base::new( $class );
  ($self->Fitness( $xml->[0]{attrib}{fitness} ) )if defined $xml->[0]{attrib}{fitness};
 
  $class = ref $self;
  eval "require $class"  || croak "Can't find $class\.pm Module";
  no strict qw(refs); # To be able to check if a ref exists or not
  my $fragment;
  if ( scalar @$xml > 1 ) { #Received from experiment or suchlike; already processed
    $fragment = $xml;
  }  else {
    $fragment = $xml->[0]{content};
  } 
  for (@$fragment ) {
    if ( defined(  $_->{content} ) ) { 
      $self->addAtom($_->{content}->[0]->{content}); #roundabout way of adding the content of the stuff
    } 
  }
  return $self;
}

=head2 fromParam( $xml_fragment )

Takes an array of params that describe the individual, and build it, with
random initial values.

Params have this shape:
 <param name='type' value='Vector' /> 
 <param name='length' value='2' />
 <param name='range' start='0' end='1' />

The 'type' will show the class of the individuals that are going to
be created, and the rest will be type-specific, and left to the particular
object to interpret.

=cut

sub fromParam {
  my $class = shift;
  my $xml = shift || croak "XML fragment missing ";
  my $thisClass;
  
  my %params;
  for ( @$xml ) {
    if ( $_->{attrib}{name} eq 'type' ) {
      $thisClass = $_->{attrib}{value}
    } else {
      $params{ $_->{attrib}{name} } = $_->{attrib}{value};
    }
  }
  $thisClass = "Algorithm::Evolutionary::Individual::$thisClass" if $thisClass !~ /Algorithm::Evolutionary/;

  eval "require $thisClass" || croak "Can't find $class\.pm Module";
  my $self = $thisClass->new();
  $self->set( \%params );
  $self->randomize();
  return $self;
}

=head2 asXML()

Prints it as XML. The caller must close the tags.

=cut

sub asXML {
  my $self = shift;
  my ($opName) = ( ( ref $self) =~ /::(\w+)$/ );
  my $str = "<indi type='$opName' ";
  if ( defined $self->{_fitness} ) {
	$str.= "fitness='$self->{_fitness}'";
  }
  $str.=" />\n\t";
  return $str;
}

=head2 as_yaml()

Prints it as YAML. 

=cut

sub as_yaml {
  my $self = shift;
  return Dump($self);
}

=head2 as_string()

Prints it as a string in the most meaningful representation possible

=cut

sub as_string {
  croak "This function is not defined at this level, you should override it in a subclass\n";
}

=head2 as_string_with_fitness( [$separator] )

Prints it as a string followeb by fitness. Separator by default is C<;>

=cut

sub as_string_with_fitness {
  my $self = shift;
  my $separator = shift || "; ";
  return $self->as_string().$separator.$self->Fitness();
}

=head2 Atom( $index [, $value )

Sets or gets the value of an atom. Each individual is divided in atoms, which
can be accessed sequentially. If that does not apply, Atom can simply return the
whole individual

=cut

sub Atom {
  croak "This function is not defined at this level, you should override it in a subclass\n";
}

=head2 Fitness( [$value] )

Sets or gets fitness

=cut

sub Fitness {
  my $self = shift;
  if ( defined $_[0] ) {
	$self->{_fitness} = shift;
  }
  return $self->{_fitness};
}

=head2 my_operators()

Operators that can act on this data structure. Returns an array with the names of the known operators

=cut

sub my_operators {
    my $self = shift;
    return $self->MY_OPERATORS;
}

=head2 evaluate( $fitness )

Evaluates using the $fitness function given. Can be a Fitness object or a ref-to-sub

=cut

sub evaluate {
  my $self = shift;
  my $fitness_func = shift || croak "Need a fitness function";
  if ( ref $fitness_func eq 'CODE' ) {
      return $self->Fitness( $fitness_func->($self) );
  } elsif (  ( ref $fitness_func ) =~ 'Fitness' ) {
      return $self->Fitness( $fitness_func->apply($self) );
  } else {
      croak "$fitness_func is can't be used to evaluate";
  }

}

=head2 Chrom()

Sets or gets the chromosome itself, that is, the data
structure evolved. Since each derived class has its own
data structure, and its own name, it is left to them to return 
it

=cut

sub Chrom {
  my $self = shift;
  croak "To be implemented in derived classes!";
}

=head2 size()

OK, OK, this is utter inconsistence, but I'll re-consistence it
    eventually. Returns a meaningful size; but should be reimplemented
    by siblings

=cut

sub size() {
    croak "To be implemented in derived classes!";
}

=head1 Known subclasses

=over 4

=item * 

L<Algorithm::Evolutionary::Individual::Vector>

=item * 

L<Algorithm::Evolutionary::Individual::String>

=item * 

L<Algorithm::Evolutionary::Individual::Tree>

=item * 

L<Algorithm::Evolutionary::Individual::Bit_Vector>

=back

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/07/25 11:26:17 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Individual/Base.pm,v 1.11 2008/07/25 11:26:17 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.11 $
  $Name $

=cut

"The plain truth";


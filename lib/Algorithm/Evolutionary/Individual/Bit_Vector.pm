use strict;
use warnings;

=head1 NAME

    Algorithm::Evolutionary::Individual::Bit_Vector - Classic bitstring individual for evolutionary computation; 
                 usually called I<chromosome>, and using a different implementation from L<Algorithm::Evolutionary::Individual::BitString>


=head1 SYNOPSIS

    use Algorithm::Evolutionary::Individual::BitVector;

    my $indi = new Algorithm::Evolutionary::Individual::Bit_Vector 10 ; # Build random bitstring with length 10
                                   # Each element in the range 0 .. 1

    my $indi3 = new Algorithm::Evolutionary::Individual::Bit_Vector;
    $indi3->set( { length => 20 } );   #Sets values, but does not build the string
    
    $indi3->randomize(); #Creates a random bitstring with length as above
 
    print $indi3->Atom( 7 );       #Returns the value of the 7th character
    $indi3->Atom( 3 ) = 1;       #Sets the value

    $indi3->addAtom( 1 ); #Adds a new character to the bitstring at the end

    my $indi4 = Algorithm::Evolutionary::Individual::Bit_Vector->fromString( '10110101');   #Creates an individual from that string

    my $indi5 = $indi4->clone(); #Creates a copy of the individual

    my @array = qw( 0 1 0 1 0 0 1 ); #Create a tied array
    tie my @vector, 'Algorithm::Evolutionary::Individual::Bit_Vector', @array;
    print tied( @vector )->asXML();

    print $indi3->asString(); #Prints the individual
    print $indi3->asXML() #Prints it as XML. See 
    print $indi3->as_yaml() #Change of convention, I know...

=head1 Base Class

L<Algorithm::Evolutionary::Individual::String|Algorithm::Evolutionary::Individual::String>

=head1 DESCRIPTION

Bitstring Individual for a Genetic Algorithm. Used, for instance, in a canonical GA

=cut

package Algorithm::Evolutionary::Individual::Bit_Vector;

use Carp;
use Bit::Vector;
use String::Random; # For initial string generation

our ($VERSION) =  ( '$Revision: 1.1 $ ' =~ /(\d+\.\d+)/ );

use base 'Algorithm::Evolutionary::Individual::Base';

use constant MY_OPERATORS => ( qw(Algorithm::Evolutionary::Op::BitFlip Algorithm::Evolutionary::Op::Mutation )); 
 

=head1 METHODS

=head2 new( $length )

Creates a new random bitstring individual, with fixed initial length, and 
uniform distribution of bits. Options as in L<Algorithm::Evolutionary::Individual::String>
If no length is given, a default of 16 is assigned

=cut

sub new {
    my $class = shift; 
    my $self = Algorithm::Evolutionary::Individual::Base::new( $class );
    my $length = shift || 16;
    my $rander = new String::Random;
    my $hex_string = $rander->randregex("[0..9A..F]{".$length/4."}");
    $self->{'_bit_vector'} = Bit::Vector->new_Hex( $hex_string );
    return $self;
}

sub TIEARRAY {
  my $class = shift; 
  my $self = { _bit_vector => Bit::Vector->new_Bin(join("",@_)) };
  bless $self, $class;
  return $self;
}

=head2 Atom

Sets or gets the value of the n-th character in the string. Counting
starts at 0, as usual in Perl arrays.

=cut

sub Atom: lvalue {
  my $self = shift;
  my $index = shift;
  if ( @_ ) {
      $self->{'_bit_vector'}->Bit_Copy($index, shift );
  } else {
      $self->{'_bit_vector'}->bit_test($index);
  }
}

=head2 TIE methods

String implements FETCH, STORE, PUSH and the rest, so an String
can be tied to an array and used as such.

=cut

sub FETCH {
  my $self = shift;
  return $self->Atom( @_ );
}

sub STORE {
  my $self = shift;
  $self->Atom( @_ );
}

sub PUSH {
    my $self = shift;
    my $new_vector =  Bit::Vector->new_Bin(join("",@_));
    $self->{'_bit_vector'}->Concat( $new_vector );
}

sub UNSHIFT {
    my $self = shift;
    my $new_vector =  Bit::Vector->new_Bin(join("",@_));
    $self->{'_bit_vector'}  = Bit::Vector->Concat_List( $new_vector, $self->{'_bit_vector'}) ;
}

sub POP {
  my $self = shift;
  my $pop = substr( $self->{_str}, length( $self->{_str} )-1, 1 );
  substr( $self->{_str}, length( $self->{_str} ) -1, 1 ) = ''; 
  return $pop;
}

sub SHIFT {
  my $self = shift;
  my $shift = substr( $self->{_str}, 0, 1 );
  substr( $self->{_str}, 0, 1 ) = ''; 
}

sub SPLICE {
  my $self = shift;
  substr( $self->{_str}, shift, shift ) = join("", @_ );
}

sub FETCHSIZE {
  my $self = shift;
  return length( $self->{_str} );
}


=head2 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/07/23 06:06:22 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Individual/Bit_Vector.pm,v 1.1 2008/07/23 06:06:22 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $
  $Name $

=cut

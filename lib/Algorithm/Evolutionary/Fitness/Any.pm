use strict; #-*-cperl-*-
use warnings;

use lib qw( ../../../../lib );

=head1 NAME

Algorithm::Evolutionary::Fitness::Any - Façade for any function to
look like fitness

=head1 SYNOPSIS

   use Algorithm::Evolutionary::Utils qw( string_decode )

   sub squares {
     my $chrom = shift;
     my @values = string_decode( $chrom, 10, -1, 1 );
     return $values[0] * $values[1];
   }

   my $any_eval = new Algorithm::Evolutionary::Fitness::Any \&squares

   

=head1 DESCRIPTION

Turns any subroutine or closure into a fitness function. Useful mainly
if you want results cached; it's not really needed otherwise.

=head1 METHODS

=cut

package Algorithm::Evolutionary::Fitness::Any;

use Carp;

use base 'Algorithm::Evolutionary::Fitness::Base';

our $VERSION =   sprintf "%d.%03d", q$Revision: 3.0 $ =~ /(\d+)\.(\d+)/g; 

=head2 new( $function )

Assigns default variables

=cut 

sub new {
  my $class = shift;
  my $self = { _function => shift || croak "No functiona rray" };
  bless $self, $class;
  $self->initialize();
  return $self;
}

=head2 apply( $individual )

Applies the instantiated problem to a chromosome. Actually it is a
wrapper around C<_apply>

=cut

sub apply {
    my $self = shift;
    my $individual = shift || croak "Nobody here!!!";
    $self->{'_counter'}++;
    return $self->_apply( $individual );
}

=head2 _apply( $individual )

This is the one that really does the stuff. It applies the defined
function to each individual 

=cut

sub _apply {
  my $self = shift;
  my $individual = shift || croak "Nobody here!";
  my $chrom = $individual->Chrom();
  my $cache = $self->{'_cache'};
  if ( $cache->{$chrom} ) {
    return $cache->{$chrom};
  }
  my $result = $self->{'_function'}->($chrom);
  if ( (scalar $chrom ) eq $chrom ) {
    $cache->{$chrom} = $result;
  }
  return $result;
}


=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/07/24 08:46:59 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Fitness/Any.pm,v 3.0 2009/07/24 08:46:59 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 3.0 $

=cut

"What???";

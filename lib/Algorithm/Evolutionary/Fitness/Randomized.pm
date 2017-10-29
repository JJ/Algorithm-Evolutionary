use strict; # -*- cperl -*-
use warnings;

use lib qw( ../../../../lib );

=head1 NAME

Algorithm::Evolutionary::Fitness::Randomized - Randomizes a param of a particular function

=head1 SYNOPSIS

      my $trap = Algorithm::Evolutionary::Fitness::SkewTrap->new( $number_of_bits, 1, 0.1, $a, $b, $z );

      #Changes skewness on the fly
      my $noisy = new Algorithm::Evolutionary::Fitness::Randomized( $trap, { '_skewness' => { min = -1, range => 2} } ); 


=head1 DESCRIPTION

Uses a randon number generator and a fitness function to evaluate it noisily. 

=head1 METHODS

=cut

package Algorithm::Evolutionary::Fitness::Randomized;

our $VERSION = "0.0.1" ;

use Math::Random qw(random_normal);
use Carp qw(croak);

use lib qw(../../.. ../.. ..);

use base qw(Algorithm::Evolutionary::Fitness::Base);

=head2 new( $fitness_function, $params_to_change_with_range )

Creates a new fitness function with a RNG and an underlying function

=cut 

sub new {
  my $class = shift;
  my $fitness_function = shift || croak "Need a fitness function\n";
  my $params = shift || croak "Need params to randomize";

  my $self = $class->SUPER::new();
  bless $self, $class;
  $self->initialize();
  $self->{'fitness_function'} = $fitness_function;
  $self->{'params'} = $params;
  return $self;
}

=head2 _really_apply

Applies the instantiated problem to a chromosome

=cut

sub _apply {
  my $self = shift;
  my %self_params = %{$self->{'params'}};
  for my $p ( keys %self_params ) {
    $self->{'fitness_function'}->{$p} = $self_params{$p}{'min'} + rand()*$self_params{$p}{'range'};
  }
  my $real_fitness = $self->{'fitness_function'}->apply( @_ );
  return $real_fitness;
}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

=cut

"What???";

use strict; # -*- cperl -*-
use warnings;

use lib qw( ../../../../lib );

=head1 NAME

Algorithm::Evolutionary::Fitness::Noisy - Adds noise to underlying fitness function

=head1 SYNOPSIS

      my $trap = Algorithm::Evolutionary::Fitness::Trap->new( $number_of_bits, $a, $b, $z );

      #Noisy with normal distribution
      my $noisy = new Algorithm::Evolutionary::Fitness::Noisy( $trap ); 

      #Noisy with normal depending on the number of traps
      my $noisy = new Algorithm::Evolutionary::Fitness::Noisy( $trap, function() { return random_normal( 1, 0, $a*$number_of_traps ) }); 

=head1 DESCRIPTION

Uses a randon number generator and a fitness function to evaluate it noisily. 

=head1 METHODS

=cut

package Algorithm::Evolutionary::Fitness::Noisy;

our $VERSION = "0.0.1" ;

use Math::Random qw(random_normal);
use Carp qw(croak);

use lib qw(../../.. ../.. ..);

use base qw(Algorithm::Evolutionary::Fitness::Base);

=head2 new( $fitness_function, [ $rng = random_normal( 1, 0, 1 ) ]

Creates a new fitness function with a RNG and an underlying function

=cut 

sub new {
  my $class = shift;
  my $fitness_function = shift || croak "Need a fitness function\n";
  my $rng = shift || sub { return random_normal( 1,0,1 ) };

  my $self = $class->SUPER::new();
  bless $self, $class;
  $self->initialize();
  $self->{'fitness_function'} = $fitness_function;
  $self->{'rng'} = $rng;
  return $self;
}

=head2 _really_apply

Applies the instantiated problem to a chromosome

=cut

sub _apply {
  my $self = shift;
  my $real_fitness = $self->{'fitness_function'}->apply( @_ );
  my $noise = $self->{'rng'}();
  return $noise + $real_fitness;
}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

=cut

"What???";

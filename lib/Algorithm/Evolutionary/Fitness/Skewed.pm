use strict; # -*- cperl -*-
use warnings;

use lib qw( ../../../../lib );

=head1 NAME

Algorithm::Evolutionary::Fitness::Skewed - Adds skewed noise to underlying fitness function

=head1 SYNOPSIS

      my $trap = Algorithm::Evolutionary::Fitness::Trap->new( $number_of_bits, $a, $b, $z );

      #Noisy with normal distribution
      my $noisy = new Algorithm::Evolutionary::Fitness::Skewed( $trap ); 

      # Skews towards origin instead of default 1.
      my $noisy = new Algorithm::Evolutionary::Fitness::Skewed( $trap, -1, 0.1 ); 

=head1 DESCRIPTION

Uses a randon number generator and a fitness function to evaluate it noisily. 

=head1 METHODS

=cut

package Algorithm::Evolutionary::Fitness::Skewed;

our $VERSION = "0.0.1" ;

use Carp qw(croak);

use base qw(Algorithm::Evolutionary::Fitness::Noisy);

use constant TWOPI => 2.0 * 4.0 * atan2(1.0, 1.0);

=head2 rand_nd_generator(;@)

    Generates a random number with provided mean and standard deviation

=cut

sub rand_nd_generator(;@)
{
    my ($mean, $stddev) = @_;
    $mean = 0.0 if ! defined $mean;
    $stddev = 1.0 if ! defined $stddev;

    return sub {
        return $mean + $stddev * cos(TWOPI * (1.0 - rand)) * sqrt(-2.0 * log(1.0 - rand));
    }
}

=head2 generate_sn( $string )

Generates skewed normal with internal sigma.

=cut

sub generate_sn {
  my $self = shift;
  my $skewness = $self->{'_skewness'};
  my $a = $self->{'_generator'}();
  my $b = $self->{'_generator'}();
  my $sconst = $self->{'_sigma'};
  my $c = $sconst * $a + sqrt(1 - $sconst ** 2) * $b;
#  say "$a, $c";
  return $a > 0 ? $c : -$c ;
}


=head2 new( $fitness_function, $skewness = 1, $sigma = 0.1 )

Creates a new fitness function with a RNG and an underlying function

=cut 

sub new {
  my $class = shift;
  my $fitness_function = shift || croak "Need a fitness function\n";
  my $skewness = shift || 1;
  my $normal_sigma = shift || 0.1;
  my $self = $class->SUPER::new($fitness_function);
  bless $self, $class;
  $self->{'_skewness'} = $skewness;
  $self->{'_sigma'} = $skewness / sqrt(1 + $skewness ** 2);
  $self->{'_generator'} = rand_nd_generator(0,$normal_sigma);
  $self->{'rng'} = sub { $self->generate_sn };
  return $self;
}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

=cut

"What???";

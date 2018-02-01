package Algorithm::Evolutionary::Fitness::SkewTrap; # -*- cperl -*-

use strict; 
use warnings;
use Carp qw(croak);

our $VERSION = '0.1';

use lib qw(../../.. ../.. .. ../../../../lib);

use base qw(Algorithm::Evolutionary::Fitness::String);

=head1 NAME

Algorithm::Evolutionary::Fitness::SkewTrap - 'Trap' fitness function for evolutionary algorithms with noise

=head1 SYNOPSIS

    my $number_of_bits = 5;
    my $a = $number_of_bits -1; # Usual default values follow
    my $b = $number_of_bits;
    my $z = $number_of_bits -1;
    my $skewness = 1; # Skewed shape function, positive or negative; this is the default
    my $sigma = 0.1; # Normal distribution sigma used to generate skewed distribution
    my $trap = Algorithm::Evolutionary::Fitness::SkewTrap->new( $number_of_bits, $skewness, $sigma, $a, $b, $z );

=head1 DESCRIPTION

Trap functions act as "yucky" or deceptive for evolutionary algorithms;
they "trap" population into going to easier, but local, optima.

=head1 METHODS


=head2 new( $number_of_bits, [$skewness = 1, $normal_sigma = 0.1, $a = $number_of_bits -1, $b = $number_of_bits, $z=$number_of_bits-1])

Creates a new instance of the problem, with the said number of bits
and traps. Uses default values computed from C<$number_of_bits> if needed. 
Since noise is added at the block level, the derivation from normal is relatively small as a default value. 

=cut

sub new {
  my $class = shift;
  my $number_of_bits = shift || croak "Need non-null number of bits\n";
  my $skewness = shift || 1;
  my $normal_sigma = shift || 0.1;
  my $a = shift || $number_of_bits - 1;
  my $b = shift || $number_of_bits;
  my $z = shift || $number_of_bits - 1;

  croak "Z too big" if $z >= $number_of_bits;
  croak "Z too small" if $z < 1;
  croak "A must be less than B" if $a > $b;
  my $self = $class->SUPER::new();
  bless $self, $class;
  $self->{'l'} = $number_of_bits;
  $self->{'a'} = $a;
  $self->{'b'} = $b;
  $self->{'z'} = $z;
  $self->{'_skewness'} = $skewness;
  $self->{'_sigma'} = $skewness / sqrt(1 + $skewness ** 2);
  $self->{'_generator'} = rand_nd_generator(0,$normal_sigma);
  return $self;
}

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

=head2 _really_apply

Applies the instantiated problem to a chromosome

=cut

sub _really_apply {
  my $self = shift;
  return $self->skewtrap( @_ );
}


=head2 skewtrap( $string )

Computes the value of the trap function on the C<$string>. Optimum is
number_of_blocs * $b (by default, $b = $l or number of ones). Applies skewness.

=cut

sub skewtrap {
  my $self = shift;
  my $string = shift;
  my $l = $self->{'l'};
  my $z = $self->{'z'};
  my $total = 0;
  for ( my $i = 0; $i < length( $string); $i+= $l ) {
    my $substr = substr( $string, $i, $l );
    my $key = $substr;
    my $num_ones = 0;
    while ( $substr ) {
      $num_ones += chop( $substr );
    }
    my $partial;
    if ( $num_ones <= $z ) {
      $partial = $self->{'a'}*($z-$num_ones)/$z;
    } else {
      $partial = $self->{'b'}*($num_ones -$z)/($l-$z);
    }
    $total += $partial + $self->generate_sn();
  }
  return $total;
  
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

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

=cut

"Gotcha trapped!";


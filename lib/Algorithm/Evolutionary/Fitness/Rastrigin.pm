use strict; # -*- cperl -*-
use warnings;

use lib qw( ../../../../lib );

=head1 NAME

    Algorithm::Evolutionary::Fitness::Rastrigin - Implementation of Rastrigin's function

=head1 SYNOPSIS

    my $n_dimensions=2;  #Max. number of elements to choose
    my $rastrigin = Algorithm::Evolutionary::Fitness::Rastrigin->new( $n_dimensions ); 

=head1 DESCRIPTION

    Classical Rastrigin function, used for tests of numerical optimization problems. 
Check it at http://www-optima.amp.i.kyoto-u.ac.jp/member/student/hedar/Hedar_files/TestGO_files/Page2607.htm

=head1 METHODS

=cut

package Algorithm::Evolutionary::Fitness::Rastrigin;

our ($VERSION) = ( '$Revision: 3.1 $ ' =~ / (\d+\.\d+)/ ) ;

use Carp qw( croak );
use base qw(Algorithm::Evolutionary::Fitness::Base);
use constant PI2    => 2 * atan2(1, 1);

=head2 new

    Creates a new instance of the problem, with the said number of bits and peaks

=cut 

sub new {
  my $class = shift;
  my ( $n_dimensions ) = @_;

  #Instantiate superclass
  my $self = $class->SUPER::new();

  #Assign stuff
  $self->{'n_dimensions'} = $n_dimensions;
  $self->{'_base_fitness'} = 10*$n_dimensions;
  $self->initialize();
  return $self;
}

sub _really_apply {
    my $self = shift;
    return $self->Rastrigin( @_ );
}

=head2 Rastrigin

    Applies the knapsack problem to the string, using a penalty function

=cut

sub Rastrigin {
    my $self = shift;
    my @array = @_;
    my $fitness = $self->{'_base_fitness'};
    for ( my $i = 0; $i < $self->{'n_dimensions'}; $i ++ ) {
      $fitness += $array[$i]-cos(PI2*$array[$i]);
    }
    return $fitness;
}


=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2010/09/24 08:39:07 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Fitness/Rastrigin.pm,v 3.1 2010/09/24 08:39:07 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 3.1 $
  $Name $

=cut

"Pi squared???";

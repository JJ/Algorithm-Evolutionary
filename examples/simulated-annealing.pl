#!/usr/bin/perl

=head1 NAME

simulated-annealing.pl - Program that tests the simulated annealing classes in A::E

=head1 SYNOPSIS

  prompt% ./simulated-annealing.pl <number of changes> <initial temperature> <minimum temperature>


=head1 DESCRIPTION  

Example of simple and fast simulated annealing

=cut

use strict;
use warnings;

use lib qw (lib ../lib);

use Algorithm::Evolutionary::Op::LinearFreezer;
use Algorithm::Evolutionary::Op::GaussianMutation;
use Algorithm::Evolutionary::Individual::Vector;
use Algorithm::Evolutionary::Op::SimulatedAnnealing;

print "\n(c)2001 - Pedro Angel Castillo Valdivieso\n\n" ;

######################## PARAMETROS #######################
my $numChanges = shift || 7; #7 , 15
my $initTemp   = shift || 0.2; #0.2 , 0.3
my $minTemp    = shift || 0.001; #0.001 , 0.01

print "\nPARAMETROS:\n";
print "\tnumChanges = $numChanges\n";
print "\tinitTemp   = $initTemp\n";
print "\tminTemp    = $minTemp\n";

######################## PARAMETROS #######################

print "Creating  evaluador...\n";
my $eval = sub {
                my $indi = shift;
		my ( $x, $y ) = @{$indi->{_array}};
		my $sqrt = sqrt( $x*$x+$y*$y);
		return sin( $sqrt )/$sqrt;
};

print "Creating  FREEZER...\n";
my $freezer = new Algorithm::Evolutionary::Op::LinearFreezer( $initTemp );

print "Creating Mutation operator...\n";
my $op = new Algorithm::Evolutionary::Op::GaussianMutation( 0, 0.1 );

print "Creating  SimAnn...\n";
my $sa = new Algorithm::Evolutionary::Op::SimulatedAnnealing( $eval, $op, $freezer, $initTemp, $minTemp, $numChanges, 1 ); #Verbosity = 1

print "Creating  individuo...\n";
my $indiv = new Algorithm::Evolutionary::Individual::Vector( 2 ); #Creates random individual


print "\nPerforming simulated annealing\n";
$indiv = $sa->run( $indiv );


print "\n\Final Fitness:\n";
print "\t", $eval->( $indiv ), "\n\n" ;

=head1 AUTHOR

Pedro Castillo, C<pedro (at) geneura.ugr.es>

=cut

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/07/24 08:46:58 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/examples/simulated-annealing.pl,v 3.0 2009/07/24 08:46:58 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 3.0 $
  $Name $

=cut

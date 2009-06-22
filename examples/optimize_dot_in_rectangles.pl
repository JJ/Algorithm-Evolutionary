#!/usr/bin/perl

use strict;
use warnings;

use Algorithm::RectanglesContainingDot;

my $alg = Algorithm::RectanglesContainingDot->new;


my $num_rects = shift || 25;
my $arena_x = shift || 10;
my $arena_y = shift || 10;
my $dot_x = shift || 5;
my $dot_y = shift || 5;

for my $i (0 .. $num_rects) {

  my $x_0 = rand( $arena_x );
  my $y_0 = rand( $arena_y);
  $alg->add_rectangle("rectangle_$i", $x_0, $y_0, rand( $arena_x - $x_0 ), rand($arena_y-$y_0));
}


my $fitness = sub {
  my ( $dot_x, $dot_y ) = @_;
  my @contained_in = $alg->rectangles_containing_dot($dot_y, $dot_y);
  return scalar @contained_in;
};

print "Fitness es ", $fitness->($dot_x, $dot_y), "\n";

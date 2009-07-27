#!/usr/bin/perl

use strict;
use warnings;

use GD::Image;
use Algorithm::Evolutionary::Utils qw( random_bitstring );
use File::Slurp qw(write_file);

my $length = 20;
my $pixels_per_bit = 2;
my $number_of_strings = 20;
my $generations = 20;

my $image = GD::Image->new($length*$pixels_per_bit,$number_of_strings);
my $white = $image->colorAllocate(0,0,0); #background color
my $black = $image->colorAllocate(255,255,255);

my $gifdata = $image->gifanimbegin;
$gifdata   .= $image->gifanimadd;    # first frame
for (1..$generations) {
     # make a frame of right size
  my $frame  = GD::Image->new($image->getBounds);
  for my $l ( 1..$number_of_strings ) {
    my $bit_string = random_bitstring( $length );
    for my $c ( 0..($length-1) ) {
      my $bit = substr( $bit_string, $c, 1 );
      for my $p ( 1..$pixels_per_bit ) {
	if ( $bit ) {
	  $frame->setPixel($c*$pixels_per_bit+$p,$l,$black)
	}
      }
    }
#    add_frame_data($frame);              # add the data for this frame
  }
  $gifdata   .= $frame->gifanimadd;     # add frame
}
$gifdata   .= $image->gifanimend;   # finish the animated GIF
print $gifdata;                     # write animated gif to STDOUT

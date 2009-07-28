package Algorithm::Evolutionary::Op::Animated_GIF_Output;

use lib qw( ../../../../../../Algorithm-Evolutionary/lib ../Algorithm-Evolutionary/lib ); #For development and perl syntax mode

use warnings;
use strict;
use Carp;

our $VERSION =   sprintf "%d.%03d", q$Revision: 1.3 $ =~ /(\d+)\.(\d+)/g; 

use base 'Algorithm::Evolutionary::Op::Base';

use GD::Image;

sub new {
  my $class = shift;
  my $hash = shift || croak "No default values for length ";
  my $self = Algorithm::Evolutionary::Op::Base::new( __PACKAGE__, 1, $hash );
  $self->{'_image'} = GD::Image->new($hash->{'length'}*$hash->{'pixels_per_bit'},
				     $hash->{'number_of_strings'}*$hash->{'pixels_per_bit'});
  $self->{'_length'} = $hash->{'length'};
  $self->{'_pixels_per_bit'} = $hash->{'pixels_per_bit'};
  $self->{'_white'} = $self->{'_image'}->colorAllocate(0,0,0); #background color
  $self->{'_black'} = $self->{'_image'}->colorAllocate(255,255,255);
  $self->{'_gifdata'} = $self->{'_image'}->gifanimbegin;
  $self->{'_gifdata'}   .= $self->{'_image'}->gifanimadd;    # first frame
  return $self;
}


sub apply {
    my $self = shift;
    my $population_hashref=shift;
    my $frame  = GD::Image->new($self->{'_image'}->getBounds);
    my $ppb = $self->{'_pixels_per_bit'};
    my $l=0;
    for my $p (@$population_hashref) {
      my $bit_string = $p->{'_str'};
      for my $c ( 0..($self->{'_length'}-1) ) {
	my $bit = substr( $bit_string, $c, 1 );
	if ( $bit ) {
	  for my $p ( 1..$ppb ) {
	    for my $q (1..$ppb ) {

	      $frame->setPixel($c*$ppb+$p,
			       $l*$ppb+$q,$self->{'_black'})
	    }
	  }
	}
      }
      $l++;
    }
    $self->{'_gifdata'}   .= $frame->gifanimadd;     # add frame
}

sub terminate {
  my $self= shift;
  $self->{'_gifdata'}   .= $self->{'_image'}->gifanimend;
}

sub output {
  my $self = shift;
  return $self->{'_gifdata'};
}

"No man's land" ; # Magic true value required at end of module

__END__

=head1 NAME

Algorithm::Evolutionary::Op::Animated_GIF_Output - Flexible population printing class


=head1 SYNOPSIS

  my $pp = new Algorithm::Evolutionary::Op::Animated_GIF_Output; 

  my @pop;
  for ( 1..10 ) {
    my $indi= new Algorithm::Evolutionary::Individual::String [0,1], 8;
    push @pop, $indi;
  }

  $pp->apply( \@pop );

  $pp = new Algorithm::Evolutionary::Op::Animated_GIF_Output;

  $pp->apply( \@pop );
  $pp->terminate();
  $pp->output(); # Prints final results

=head1 DESCRIPTION

Saves each generation as a frame in an animated GIF

=head1 INTERFACE 

=head2 new( [$printer] )

C<$printer> is a closure or reference to function that receives as
input a single population member. By default, calls C<as_string> on
each one followed by a carriage return

=head2 apply( $population_hashref )

Applies the single-member printing function to every population member

=head2 terminate()

Finish the setup of the animated gif

=head2 output()

Returns the animaged GIF

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-algorithm-evolutionary@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

JJ Merelo  C<< <jj@merelo.net> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2009, JJ Merelo C<< <jj@merelo.net> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

  CVS Info: $Date: 2009/07/28 11:30:56 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary/Op/Animated_GIF_Output.pm,v 1.3 2009/07/28 11:30:56 jmerelo Exp $ 
  $Author: jmerelo $ 

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

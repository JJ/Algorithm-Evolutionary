package Algorithm::Evolutionary;

our $VERSION = '0.54';

# Preloaded methods go here.

1;
__END__

=head1 NAME

Algorithm::Evolutionary - Perl extension for performing paradigm-free evolutionary algorithms. 

=head1 SYNOPSIS

  use Algorithm::Evolutionary;
  

=head1 DESCRIPTION

Algorithm::Evolutionary is a set of classes for doing object-oriented
evolutionary computation in Perl. Why would anyone want to do that
escapes my knowledge, but, in fact, we have found it quite useful for
our own purposes. Same as Perl itself.

The design principle of Algorithm::Evolutionary is I<flexibility>: it
should be very easy to extend using this library, and it should be
also quite easy to program what's already there in the evolutionary
computation community. Besides, the library classes should have
persistence provided by XML modules.

The algorithm allows to create simple evolutionary algorithms, as well
as more complex ones, that interface with databases or with the
web. 

=begin html

The project is hosted at
<a href='http://opeal.sourceforge.net'>Sourceforge </a>. Latest aditions, and
nightly updates, can be downloaded from there before they are uploaded
to CPAN. That page also hosts the mailing list, as well as bug
reports, news, updates, whatever.

=end html

=head1 AUTHOR

=begin html

Main author and developer is J. J. Merelo, jmerelo (at)
geneura.ugr.es. There have also been some contributions from Javi
García, fjgc (at) decsai.ugr.es and Pedro Castillo, pedro (at)
geneura.ugr.es. Patient users that have submitted bugs include <a
href='http://barbacana.net'>jamarier</a>. Bugs, requests and any kind
of comment are welcome.

=end html

=head1 SEE ALSO

L<Algorithm::Evolutionary::Op::Base>.
L<Algorithm::Evolutionary::Individual::Base>.
L<Algorithm::Evolutionary::XML>
L<Algorithm::samples::5_marea_reales.pl>

=cut

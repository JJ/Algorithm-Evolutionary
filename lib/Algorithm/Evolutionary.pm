package Algorithm::Evolutionary;

use Carp qw(croak);

our $VERSION = '0.65';

# Preloaded methods go here.

# A bit of importing magic taken from POE
sub import {
  my $self = shift;

  my @modules  = grep(!/^(Op|Indi|Fitness)$/, @_);

  my $package = caller();
  my @failed;

  # Load all the others.
  foreach my $module (@modules) {
    my $code = "package $package; use Algorithm::Evolutionary::$module;";
    # warn $code;
    eval($code);
    if ($@) {
      warn $@;
      push(@failed, $module);
    }
  }

  @failed and croak "could not import qw(" . join(' ', @failed) . ")";
}

1;
__END__

=head1 NAME

Algorithm::Evolutionary - Perl module for performing paradigm-free evolutionary algorithms. 

=head1 SYNOPSIS

  #Short way of loading a lot of modules, POE-style
  use Algorithm::Evolutionary qw( Op::This_Operator
                                  Individual::That_Individual
                                  Fitness::Some_Fitness); 
  

=head1 DESCRIPTION

C<Algorithm::Evolutionary> is a set of classes for doing object-oriented
evolutionary computation in Perl. Why would anyone want to do that
escapes my knowledge, but, in fact, we have found it quite useful for
our own purposes. Same as Perl itself.

The design principle of Algorithm::Evolutionary is I<flexibility>: it
should be very easy to extend using this library, and it should be
also quite easy to program what's already there in the evolutionary
computation community. Besides, the library classes should have
persistence provided by XML modules, and, in some cases, YAML.

The algorithm allows to create simple evolutionary algorithms, as well
as more complex ones, that interface with databases or with the
web. 

=begin html

<p>The project is hosted at
<a href='http://opeal.sourceforge.net'>Sourceforge </a>. Latest aditions, and
nightly updates, can be downloaded from there before they are uploaded
to CPAN. That page also hosts the mailing list, as well as bug
reports, news, updates, whatever.</p>

<p>In case the examples are hidden somewhere in the <code>.cpan</code> directory,
    you can also download them from <a
    href='http://opeal.cvs.sourceforge.net/opeal/Algorithm-Evolutionary/'>the
    CVS repository</a>, and the <a
    href='https://sourceforge.net/project/showfiles.php?group_id=34080&package_id=54504'>-examples</a>
    tarballs in the file download area of that repository</p>

<p>I have used this continously for my research all these year, and
any search will return a number of papers; a journal article is
already submitted, but meanwhile if you use it for any of your
research, I would be very grateful if you quoted papers such as this
one:</p>

=end html

 @InProceedings{jj:2008:PPSN,
   author =	"Juan J. Merelo and  Antonio M. Mora and Pedro A. Castillo and Juan L. J. Laredo and Lourdes Araujo and Ken C. Sharman and Anna I. Esparcia-Alcázar and Eva Alfaro-Cid and Carlos Cotta",
   title =	"Testing the Intermediate Disturbance Hypothesis: Effect of Asynchronous Population Incorporation on Multi-Deme Evolutionary Algorithms",
   booktitle =	"Parallel Problem Solving from Nature - PPSN X",
   year = 	"2008",
   editor =	"Gunter Rudolph and Thomas Jansen and Simon Lucas and
		  Carlo Poloni and Nicola Beume",
   volume =	"5199",
   series =	"LNCS",
   pages =	"266-275",
   address =	"Dortmund",
   month =	"13-17 " # sep,
   publisher =	"Springer",
   keywords =	"genetic algorithms, genetic programming, p2p computing",
   ISBN = 	"3-540-87699-5",
   doi =  	"10.1007/978-3-540-87700-4_27",
   size = 	"pages",
   notes =	"PPSN X",
}

=begin html

<p>Some information on this paper and instructions from download can
be found in <a
href='http://nohnes.wordpress.com/2008/09/21/paper-on-performance-of-asynchronous-distributed-evolutionary-algorithms-available-online/'>our
group blog</a></p> 

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

=head1 Examples

There are a few examples in the C<examples> subdirectory, which should
have been included with your CPAN bundle. Foor instance, check out
C<tide_float.pl>, an example of floating point vector optimization, or
C<run_easy_ga.pl p_peaks.yaml>, which should run an example of a
simple GA on the P_Peaks deceptive function. 

Some other examples are installed: check out L<tide_bitstring.pl>, L<tide_float.pl> and L<canonical-genetic-algorithm.pl>, 
which you can run and play with to get a taste of what EA programming is like. 

=head1 SEE ALSO

=over

=item L<Algorithm::Evolutionary::Op::Base>.

=item L<Algorithm::Evolutionary::Individual::Base>.

=item L<Algorithm::Evolutionary::Fitness::Base>.

=item L<Algorithm::Evolutionary::Experiment>.

=item L<XML> for an explanation of the XML format used

=item L<POE::Component::Algorithm::Evolutionary> if you want to mix
evolutionary algorithms with anything else easily

You might be interested in one of the other GA modules out there, such
as L<AI::Genetic::Pro> 

=back 

=cut

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2009/03/18 20:41:22 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/lib/Algorithm/Evolutionary.pm,v 2.9 2009/03/18 20:41:22 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 2.9 $
  $Name $

=cut

Algorithm::Evolutionary
===================================

This is the repo for development of [`Algorithm::Evolutionary`](http://search.cpan.org/dist/Algorithm-Evolutionary/), a CPAN module for doing evolutionary algorithms in Perl.


##INSTALLATION

To install this module type the following:

```
   perl Makefile.PL
   make
   make test
   make install
```



##WARNING

Since evolutionary algorithms are stochastic optimization algorithms,
some tests, specially in the general.t test, might fail; running
them again might yield a different result. If your installation (from
CPAN, CPANPLUS or cpanminus) fails for this reason, run a force install, or try
to `make install` disregarding the tests.

##DEPENDENCIES

Modules listed in [`Makefile.PL`](Makefile.PL) plus `libgd-dev`. Install it in ubuntu with

	sudo apt-get install libgd-dev

or

    sudo apt-get install libgd2-xpm-dev

if that fails. Type equivalent incantations for other distros. You're good to go if you have the `GD` module already installed, though.


##COPYRIGHT AND LICENCE

Copyright (C) 2002-2014 J. J. Merelo-Guervós, jmerelo (at) geneura.ugr.es
This module is released under the GNU General Public License (see the
[`LICENSE`](LICENSE) file in this distribution).


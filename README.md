Algorithm/Evolutionary version 0.01
===================================

##INSTALLATION

To install this module type the following:

   perl Makefile.PL
   make
   make test
   make install

##WARNING

Since evolutionary algorithms are stochastic optimization algorithms,
some tests, specially in the general.t test, might fail; running
them again might yield a different result. If your installation (from
CPAN, CPANPLUS or cpanminus) fails for this reason, run a force install, or try
to make install.

##DEPENDENCIES

Modules listed in [`Makefile.PL`](Makefile.PL) plus `libgd-dev`. Install it in ubuntu with

	sudo apt-get install libgd-dev

or equivalente in other distros. You're good if you have the `GD` module already installed, though.



##COPYRIGHT AND LICENCE

Copyright (C) 2002-2014 J. J. Merelo-Guervós, jmerelo (at) geneura.ugr.es
This module is released under the GNU General Public License (see the
LICENSE file in this distribution).


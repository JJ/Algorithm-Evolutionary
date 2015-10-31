Algorithm::Evolutionary
===================================

This is the repo for development of
[`Algorithm::Evolutionary`](http://search.cpan.org/dist/Algorithm-Evolutionary/),
a CPAN module for creating evolutionary algorithms using Perl. 


##INSTALLATION

To install this module type the following:

```
   perl Makefile.PL
   make
   make test
   make install
```

Issue first

	cpanm --installdeps .

if the upstream dependencies are not installed (which they are wont to
do). Check also the DEPENDENCIES section below for non-perl dependencies.

##WARNING

Since evolutionary algorithms are stochastic optimization algorithms,
some tests, specially in the `general.t` test, might fail; running
them again might yield a different result. If your installation (from
CPAN, CPANPLUS or cpanminus) fails for this reason, run a force install, or try
to `make install` disregarding the tests.

##DEPENDENCIES

Modules listed in [`Makefile.PL`](Makefile.PL) plus `libgd-dev`. Install it in ubuntu with

	sudo apt-get install libgd-dev

or

    sudo apt-get install libgd2-xpm-dev

if that fails. Type equivalent incantations for other distros. You're
good to go if you have the `GD` module already installed, though.

##DEMO

Install demo dependencies with

	cpanm --installdeps .
	
You can run the demos included in the [`scripts`](scripts/) directory,
for instance

	./rectangle-coverage.pl

for a beautiful and slightly annoying test with a certain
Mondrianesque aspect.


##COPYRIGHT AND LICENCE

Copyright (C) 2002-2015 J. J. Merelo-Guervós, jmerelo (at) geneura.ugr.es
This module is released under the GNU General Public License (see the
[`LICENSE`](LICENSE) file in this distribution).


use ExtUtils::MakeMaker;

my @scripts = grep {-f } glob("scripts/*.pl "); # Ripped from Text::PDF

WriteMakefile(
	      NAME                => 'Algorithm::Evolutionary',
	      AUTHOR              => 'JJ Merelo <jj /at/ merelo.net>',
	      VERSION_FROM        => 'lib/Algorithm/Evolutionary.pm',
	      ABSTRACT_FROM       => 'lib/Algorithm/Evolutionary.pm',
	      EXE_FILES => \@scripts,
  
	      PL_FILES            => {},
	      PREREQ_PM => {
			    'Test::More' => 0,
			    'Test::Pod' => 0,
			    'version'    => 0,
			    constant => 0,
			    'Test::Simple' => 0.44,
			    'XML::Parser' => 0,
			    'XML::Parser::Style::EasyTree' => 0.01,
			    'Math::Random' => 0.63,
			    'Tree::DAG_Node' => 1.04,
			    'B::Deparse' => 0.56,
			    'Algorithm::Permute' => 0.01,
			    'XML::LibXML' => 1.50,
			    'String::Random' => 0,
			    'Bit::Vector' => 0,
			    'Memoize' => 0, 
			    'Time::HiRes' => 0,
			    'Clone::Fast' => 0,
			    YAML => 0,
			    'Object::Array' => 0
			   },
	      dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
	      clean               => { FILES => 'Algorithm-Evolutionary-*' }
	     );

#Add new targets
sub MY::postamble {
  return <<'MAKE_FRAG';
docs:
	pod2html --verbose --htmlroot .. --podpath=Evolutionary/Individual:Evolutionary/Op:Evolutionary --outfile index.html Evolutionary.pm; \
        cd examples; for i in *.pl; do pod2html --verbose --htmlroot ../..  --podpath=../Evolutionary/Individual:../Evolutionary/Op:../Evolutionary --outfile $$i.html $$i; done ; \
	cd ../Evolutionary; for i in *.pm; do base=`basename $$i .pm`; echo $$base; pod2html --verbose --htmlroot ../.. --podpath=Individual:Op --outfile $$base.html $$i; done ; \
		for i in *.pod; do base=`basename $$i .pod`; echo $$base; pod2html --verbose --htmlroot ../..   --podpath=Individual:Op --outfile $$base.html $$i; done; \
 		cd Op; for i in *.pm; do base=`basename $$i .pm`; echo $$base; pod2html --verbose --htmlroot ../../.. --podroot ..  --outfile $$base.html $$i; done ; \
		cd ../Individual; for i in *.pm; do base=`basename $$i .pm`; echo $$base; pod2html --verbose --htmlroot ../../.. --podroot .. --outfile $$base.html $$i; done

$(DISTVNAME)-examples.tar$(SUFFIX) : distdir
	$(PREOP)
	$(TO_UNIX)
	$(TAR) $(TARFLAGS) $(DISTVNAME)-examples.tar $(DISTVNAME)/examples
	$(RM_RF) $(DISTVNAME)
	$(COMPRESS) $(DISTVNAME)-examples.tar
	$(POSTOP)

examplesdist : $(DISTVNAME)-examples.tar$(SUFFIX)
	$(NOECHO) $(NOOP)


MAKE_FRAG
}

#!/usr/bin/perl

my $fn = shift || die "Usage: $0 file_name.xml\n";
use XML::LibXML;
my $parser = XML::LibXML->new();
$parser->validation(1); # Set validation to on
my $doc = $parser->parse_file( $fn );
eval {
  $doc->validate();
};
if ( $@ ) {
  die "Validation error: $@ \n";
} else {
  print "Validated: ", $doc->toString(), "\n";
}

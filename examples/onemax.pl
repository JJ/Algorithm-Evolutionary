#!/usr/bin/perl

use warnings;
use strict;

use lib qw( ../lib );

use Time::HiRes qw( gettimeofday tv_interval);

use Algorithm::Evolutionary qw( Individual::BitString
				Op::Breeder
				Op::Replace_Worst
				Op::Mutation
				Op::Crossover
				Op::Tournament_Selection );

use Sort::Key::Top qw(rnkeytop);

#----------------------------------------------------------#
my $numBits = shift || 64;    # longitud en num. bits de la cadena
my $popSize = shift || 100;   # tama?o de poblacion
my $numGens = shift || 100 ;  # num. generaciones max.
my $tournament_size = shift || 2; # Tournament size 
my $replacement_rate = shift || 0.5; # Replacement rate

#----------------------------------------------------------#
#Definimos la función de fitnes, que es la función Marea
my $funcionOneMax = sub {
  #Cogemos el individuo a evaluar
  my $chrom = shift;

  #Pasamos el individuo a una cadena
  my $str = $chrom->Chrom();
  
  my $num_ones;
  while ( $str ) {
            $num_ones += chop( $str );
  }                 
  return $num_ones;
};

#----------------------------------------------------------#
#Creamos la población inicial
my $pop;
#Creamos $popSize individuos
for ( 0..$popSize ) {
  my $indi = Algorithm::Evolutionary::Individual::BitString->new( $numBits ) ;
  push( @$pop, $indi );
}

#----------------------------------------------------------#
#Definimos los operadores de variación
my $m = Algorithm::Evolutionary::Op::Mutation->new(1); #Cambia a un sólo bit
my $c = Algorithm::Evolutionary::Op::Crossover->new(9 ); #Cruce en 2 puntos clásico
my $selector = new Algorithm::Evolutionary::Op::Tournament_Selection $tournament_size;

#----------------------------------------------------------#
#Usamos estos operadores para definir una generación del algoritmo. Lo cual
# no es realmente necesario ya que este algoritmo define ambos operadores por
# defecto. Los parámetros son la función de fitness, la tasa de selección y los
# operadores de variación.
my $generation = new Algorithm::Evolutionary::Op::Breeder([$m, $c], $selector );
my $replacer =  new Algorithm::Evolutionary::Op::Replace_Worst;

#Inicializar el contador de tiempo
my $inicioTiempo = [gettimeofday()];

#----------------------------------------------------------#
for ( @$pop ) {
  if ( !defined $_->Fitness() ) {
    my $fitness = $funcionOneMax->($_);
    $_->Fitness( $fitness );
  }
}

my $contador=0;
do {
  my $new_pop = $generation->apply( $pop, @$pop/2 );
  for ( @$new_pop ) {
    if ( !defined $_->Fitness() ) {
      my $fitness = $funcionOneMax->($_);
      $_->Fitness( $fitness );
    }
  }
  $pop = $replacer->apply( $pop, $new_pop );
  my $the_best = rnkeytop { $_->{'_fitness'} } 1 => @$pop;
  print "$contador : ", $the_best->asString(), "\n" ;

  $contador++;
} while( $contador < $numGens );


#----------------------------------------------------------#
#mostramos el mejor resultado
print "El mejor es:\n\t ",$pop->[0]->asString(),"\n\t Fitness: ",$pop->[0]->Fitness(),"\n";

print "\n\nTiempo transcurrido: ". tv_interval( $inicioTiempo ) . "\n";


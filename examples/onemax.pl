#!/usr/bin/perl
use warnings;
use strict;

use Time::HiRes qw( gettimeofday tv_interval);

use Algorithm::Evolutionary qw( Individual::BitString
				Op::Generation_Skeleton
				Op::Mutation
				Op::Crossover
				Op::Tournament_Selection );

#----------------------------------------------------------#
my $numBits = shift || 64;    # longitud en num. bits de la cadena
my $popSize = shift || 100;   # tama?o de poblacion
my $numGens = shift || 100 ;  # num. generaciones max.


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
my @pop;
#Creamos $popSize individuos
for ( 0..$popSize ) {
  my $indi = Algorithm::Evolutionary::Individual::BitString->new( $numBits ) ;
  push( @pop, $indi );
}


#----------------------------------------------------------#
#Definimos los operadores de variación
my $m = Algorithm::Evolutionary::Op::Mutation->new(); #Cambia a un sólo bit
my $c = Algorithm::Evolutionary::Op::Crossover->new(); #Cruce en 2 puntos clásico


#----------------------------------------------------------#
#Usamos estos operadores para definir una generación del algoritmo. Lo cual
# no es realmente necesario ya que este algoritmo define ambos operadores por
# defecto. Los parámetros son la función de fitness, la tasa de selección y los
# operadores de variación.
my $generation = Algorithm::Evolutionary::Op::Easy->new( $funcionOneMax , 0.2 , [$m, $c] ) ;

#Inicializar el contador de tiempo
my $inicioTiempo = [gettimeofday()];

#----------------------------------------------------------#
for ( @pop ) {
  if ( !defined $_->Fitness() ) {
    my $fitness = $funcionOneMax->($_);
    $_->Fitness( $fitness );
  }
}

my $contador=0;
do {
  $generation->apply( \@pop );

  print "$contador : ", $pop[0]->asString(), "\n" ;

  $contador++;
} while( $contador < $numGens );


#----------------------------------------------------------#
#mostramos el mejor resultado
print "El mejor es:\n\t ",$pop[0]->asString(),"\n\t Fitness: ",$pop[0]->Fitness(),"\n";

print "\n\nTiempo transcurrido: ". tv_interval( $inicioTiempo ) . "\n";


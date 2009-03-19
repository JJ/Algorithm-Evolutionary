#!/usr/bin/perl

use AI::Genetic::Pro;
    
    sub fitness {
        my ($ga, $chromosome) = @_;
        return oct('0b' . $ga->as_string($chromosome)); 
    }
    
    sub terminate {
        my ($ga) = @_;
        my $result = oct('0b' . $ga->as_string($ga->getFittest));
        return $result == 4294967295 ? 1 : 0;
    }
    
    my $ga = AI::Genetic::Pro->new(        
        -fitness         => \&fitness,        # fitness function
        -terminate       => \&terminate,      # terminate function
        -type            => 'bitvector',      # type of chromosomes
        -population      => 1000,             # population
        -crossover       => 0.9,              # probab. of crossover
        -mutation        => 0.01,             # probab. of mutation
        -parents         => 2,                # number  of parents
        -selection       => [ 'Roulette' ],   # selection strategy
        -strategy        => [ 'Points', 2 ],  # crossover strategy
        -cache           => 0,                # cache results
        -history         => 1,                # remember best results
        -preserve        => 3,                # remember the bests
        -variable_length => 1,                # turn variable length ON
    );
        
    # init population of 32-bit vectors
    $ga->init(32);
        
    # evolve 10 generations
    $ga->evolve(10);
    
    # best score
    print "SCORE: ", $ga->as_value($ga->getFittest), ".\n";

#!/bin/bash

for i in {1..30}
do
    echo "Test $i"
    ./noisy-trap-memory-wilcoxon.pl  15 4 1024 2000 0.5 10 1 8 > "x8-c10-l15-w-trap-noisy-mem-$i.dat" 
done

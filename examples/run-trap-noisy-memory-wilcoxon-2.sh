#!/bin/bash

for i in {1..30}
do
    echo "Test $i"
    ./noisy-trap-memory-wilcoxon.pl  10 4 1024 2000 0.5 20 1 9 > "x9-c20-w-trap-noisy-mem-$i.dat" 
done

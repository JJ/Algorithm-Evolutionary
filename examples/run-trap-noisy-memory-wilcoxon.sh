#!/bin/bash

for i in {1..30}
do
    echo "Test $i"
    ./noisy-trap-memory-wilcoxon.pl  10 4 1024 2000 0.5 4 > "w-trap-noisy-mem-n4-$i.dat" 
done

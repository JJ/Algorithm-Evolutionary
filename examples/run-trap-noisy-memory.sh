#!/bin/bash

for i in {21..30}
do
    echo "Test $i"
    ./noisy-trap-memory.pl 15 > "trap-noisy-mem-15-$i.dat" 
done

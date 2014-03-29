#!/bin/bash

for i in {1..30}
do
    echo "Test $i"
    ./noisy-trap.pl 10 4 1024 2000 0.5 8 > "trap-noisy-s05-n8-$i.dat" 
done

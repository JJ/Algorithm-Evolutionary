#!/bin/bash

for i in {1..30}
do
    echo "Test $i"
    ./noisy-trap.pl > "trap-noisy-$i.dat" 
done

#!/bin/bash

for i in {1..30}
do
    echo "Test $i"
    ./trap.pl 10 4 1024 2000 0.5   > "trap-base-05-$i.dat" 
done

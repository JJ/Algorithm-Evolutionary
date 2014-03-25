#!/bin/bash

for i in {1..30}
do
    echo "Test $i"
    ./trap.pl 20 > "trap-base-20-$i.dat" 
done

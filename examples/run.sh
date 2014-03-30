#!/bin/bash

for i in {1..30}
do
    echo "Test $i"
    ./canonical-genetic-algorithm-conf.pl 4-trap.conf.yaml > 4-trap-p1k-$i.dat
done

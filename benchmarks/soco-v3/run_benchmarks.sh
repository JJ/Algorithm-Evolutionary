#!/bin/bash

for (( i = 0; i < 30; i++)); do echo $i\n && time java ec.Evolve -file ae.params; done
#!/bin/bash

for (( i = 0; i < 30; i++)); do echo $i\n && time ~/soft/perl5.11/bin/perl ../onemax.pl; done
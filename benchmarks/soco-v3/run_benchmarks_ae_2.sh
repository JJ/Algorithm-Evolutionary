#!/bin/bash

for (( i = 1; i < 30; i++)); do echo $i\n && time ~/soft/perl5.11/bin/perl ../onemax.pl 256; done
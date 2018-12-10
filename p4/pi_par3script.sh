#!/bin/bash
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -pe openmp 16

for S in 1 2 4 6 8 9 10 12;do
  echo "para $S"
  ./pi_par3 $S
done

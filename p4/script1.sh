#!/bin/bash
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -pe openmp 2
NUMCORES=16
export OMP_NUM_THREADS=$NUMCORES
./pescalar_serie
#!/bin/bash
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -pe openmp 16
time1=14
time2=12

z=0$(bc <<< "scale=2; $time1/$time2")
echo $z

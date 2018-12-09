#!/bin/bash
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -pe openmp 16
fDAT=multiplicacion.txt
# $fDAT $fDAT2
rm -f  $fDAT
touch  $fDAT
export OMP_NUM_THREADS=4
# 50000000 75000000 100000000 250000000 500000000 750000000 1000000000 1002000000
echo "Ejecutando multN_serie..."
for S in $(seq 1000 100 1600); ;do
    serie=$(./multN_serie $S | grep 'time:' | awk '{print $2}')
    echo "serie	$S $serie" >> $fDAT
done

for S in $(seq 1000 100 1600); ;do
    bucle1=$(./multN_par1 $S | grep 'time:' | awk '{print $2}')
    echo "bucle1	$S $bucle1" >> $fDAT
done

for S in $(seq 1000 100 1600); ;do
    bucle2=$(./multN_par2 $S | grep 'time:' | awk '{print $2}')
    echo "bucle2	$S $bucle2" >> $fDAT
done

for S in $(seq 1000 100 1600); ;do
    bucle3=$(./multN_par3 $S | grep 'time:' | awk '{print $2}')
    echo "bucle3	$S $bucle3" >> $fDAT
done

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

# for N in $(seq 1 1 4);do
#     echo "iteracion $N"
#     echo "Ejecutando multN_serie..."
#     for S in $(seq 1000 600 1600);do
#         serie=$(./multN_serie $S | grep 'time:' | awk '{print $2}')
#         echo "serie	$S $serie" >> $fDAT
#     done
#     export OMP_NUM_THREADS=$N
#     echo "Ejecutando multN_serie..."
#     for S in $(seq 1000 600 1600);do
#         bucle1=$(./multN_par1 $S | grep 'time:' | awk '{print $2}')
#         echo "bucle1	$S $bucle1" >> $fDAT
#     done
#     echo "Ejecutando multN_serie..."
#     for S in $(seq 1000 600 1600);do
#         bucle2=$(./multN_par2 $S | grep 'time:' | awk '{print $2}')
#         echo "bucle2	$S $bucle2" >> $fDAT
#     done
#     echo "Ejecutando multN_serie..."
#     for S in $(seq 1000 600 1600);do
#         bucle3=$(./multN_par3 $S | grep 'time:' | awk '{print $2}')
#         echo "bucle3	$S $bucle3" >> $fDAT
#     done
# done

for 

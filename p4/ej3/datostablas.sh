#!/bin/bash
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -pe openmp 16
fDAT=multiplicacion.txt
fDAT2=mul_acel.txt
# $fDAT $fDAT2
rm -f $fDAT2
rm -f  $fDAT
touch  $fDAT

for N in $(seq 1 1 4);do
    echo "iteracion $N"
    echo "Ejecutando multN_serie..."
    for S in $(seq 1000 600 1600);do
        serie=$(./multN_serie $S | grep 'time:' | awk '{print $2}')
        echo "serie	$S $serie N$N" >> $fDAT
    done
    export OMP_NUM_THREADS=$N
    echo "Ejecutando multN_par1..."
    for S in $(seq 1000 600 1600);do
        bucle1=$(./multN_par1 $S | grep 'time:' | awk '{print $2}')
        echo "bucle1	$S $bucle1 N$N" >> $fDAT
    done
    echo "Ejecutando multN_par2..."
    for S in $(seq 1000 600 1600);do
        bucle2=$(./multN_par2 $S | grep 'time:' | awk '{print $2}')
        echo "bucle2	$S $bucle2 N$N" >> $fDAT
    done
    echo "Ejecutando multN_par3..."
    for S in $(seq 1000 600 1600);do
        bucle3=$(./multN_par3 $S | grep 'time:' | awk '{print $2}')
        echo "bucle3	$S $bucle3 N$N" >> $fDAT
    done
done

for N in $(seq 1 1 4);do
    echo "iteracion $N"

    for S in $(seq 1000 600 1600);do
        tserie=$(grep N$N $fDAT | grep serie | grep $S | awk '{print $3}')
        echo "serie	$S 1 N$N" >> $fDAT2

        tbucle1=$(grep N$N $fDAT | grep bucle1 | grep $S | awk '{print $3}')
        acbucle1=$(echo "scale=10; $tserie/$tbucle1" | bc )
        echo "bucle1	$S $acbucle1 N$N" >> $fDAT2

        tbucle2=$(grep N$N $fDAT | grep bucle2 | grep $S | awk '{print $3}')
        acbucle2=$(echo "scale=10; $tserie/$tbucle2" | bc )
        echo "bucle2	$S $acbucle2 N$N" >> $fDAT2

        tbucle3=$(grep N$N $fDAT | grep bucle3 | grep $S | awk '{print $3}')
        acbucle3=$(echo "scale=10; $tserie/$tbucle3" | bc )
        echo "bucle3	$S $acbucle3 N$N" >> $fDAT2
    done
done

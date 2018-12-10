#!/bin/bash
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -pe openmp 16
barra=_
fDAT=serie.dat
fDAT2=paralelo.dat
fDATAUX=auxiliar

rm -f $fDAT $fDAT2 $fDATAUX.dat auxiliar1.dat auxiliar2.dat auxiliar4.dat auxiliar8.dat auxiliar16.dat
echo "Ejecutando pescalar_serie..."
for S in 7500001 10000002 25000003 50000004 75000005 100000006 250000007 500000008 750000009 ;do
  for T in $(seq 1 1 3);do
    serie=$(./pescalar_serie_1 $S | grep 'Tiempo:' | awk '{print $2}')
    echo "0	$S	$serie" >> $fDAT
  done
done

echo "Ejecutando pescalar_paralelo2..."
for N in 1 2 4 8 16;do
  export OMP_NUM_THREADS=$N
  for S in 7500001 10000002 25000003 50000004 75000005 100000006 250000007 500000008 750000009 ;do
    for T in $(seq 1 1 3);do
      paralelo=$(./pescalar_par2_1 $S | grep 'Tiempo:' | awk '{print $2}')
      echo "P$N$barra	$S	$paralelo" >> $fDAT2
    done
  done
done

echo "Calculando la aceleracion..."
for S in 7500001 10000002 25000003 50000004 75000005 100000006 250000007 500000008 750000009;do
  time=$(grep $S $fDAT | awk '{suma += $3} END {print suma/NR}')
  echo "$S	$time	0" >> $fDATAUX.dat

  for N in 1 2 4 8 16;do
    time2=$(grep P$N$barra $fDAT2 | grep $S | awk '{suma += $3} END {print suma/NR}')
    acel=$(bc <<< "scale=10; $time/$time2")
    echo "$S	$time2	$acel" >> $fDATAUX$N.dat
  done
done

#!/bin/bash
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -pe openmp 2
fDAT=serie.dat
fDAT2=paralelo.dat

rm -f $fDAT
touch $fDAT

echo "Ejecutando pescalar_serie..."
for N in $(seq 1 1 16);do
  export OMP_NUM_THREADS=$N
  for S in 10000000 25000000 50000000 75000000 100000000 250000000 500000000 750000000 1000000000 1002000000;do
    for T in $(seq 1 1 5);do
      serie=$(./pescalar_serie_1 $S | grep 'Tiempo:' | awk '{print $2}')
      echo "$N	$S $serie" >> $fDAT
    done
  done
done

echo "Ejecutando pescalar_paralelo2..."
for N in $(seq 1 1 16);do
  export OMP_NUM_THREADS=$N
  for S in 10000000 25000000 50000000 75000000 100000000 250000000 500000000 750000000 1000000000 1002000000;do
    for T in $(seq 1 1 5);do
      paralelo=$(./pescalar_par2_1 $S | grep 'Tiempo:' | awk '{print $2}')
      echo "$N	$S $paralelo" >> $fDAT
    done
  done
done

echo "Generando las graficas..."
# llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
# estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"
gnuplot << END_GNUPLOT
set title "Tiempo de ejecucion en serie"
set ylabel "Tiempo"
set xlabel "Tamano Matriz"
set key right bottom
set grid
set term png
set output "$fPNG"
plot "$fDAT" using 2:3 with lines lw 2 title "Thread1"
replot
quit
END_GNUPLOT
#
# echo "Generating plot..."
gnuplot << END_GNUPLOT
set title "Aceleracion en serie"
set ylabel "Tiempo"
set xlabel "Tamano Matriz"
set key right bottom
set grid
set term png
set output "$fPNG2"
plot "$fDAT" using 1:3 with lines lw 2 title "slow1024"
replot
quit
speaker-test -t sine -f 1000 -l 1

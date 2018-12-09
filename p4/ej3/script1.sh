#!/bin/bash
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -pe openmp 16
fDAT=serie.dat
fDAT2=paralelo.dat
fDATAUX=auxiliar
# $fDAT $fDAT2
rm -f  $fDATAUX
touch  $fDATAUX
# 50000000 75000000 100000000 250000000 500000000 750000000 1000000000 1002000000
echo "Ejecutando pescalar_serie..."
for S in $(seq 1000 100 1600); ;do
    serie=$(./multN_serie $S | grep 'time:' | awk '{print $2}')
    echo "0	$S $serie" >> $fDAT
done

echo "Ejecutando pescalar_paralelo2..."
for N in $(seq 1 1 16);do
  export OMP_NUM_THREADS=$N
  for S in 10000000 25000000 ;do
    for T in $(seq 1 1 3);do
      paralelo=$(./multN_par $S | grep 'time:' | awk '{print $2}')
      echo "P$N	$S $paralelo" >> $fDAT2
    done
  done
done

for S in 10000000 25000000;do
  time=$(grep $S $fDAT | awk '{suma += $3} END {print suma/NR}')
  echo "S  $S  $time  0" >> $fDATAUX.dat

  for N in $(seq 14 1 16);do
    time2=$(grep P$N $fDAT2 | grep $S | awk '{suma += $3} END {print suma/NR}')
    acel=$(bc <<< "scale=10; $time1/$time2")
    echo "$S  $time $acel" >> $fDATAUX$N.dat
  done
done

echo "Calculando la aceleracion..."

#
# echo "Generando las graficas..."
# # llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
# # estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"
# gnuplot << END_GNUPLOT
# set title "Tiempo de ejecucion en serie"
# set ylabel "Tiempo"
# set xlabel "Tamano Matriz"
# set key right bottom
# set grid
# set term png
# set output "$fPNG"
# plot "$fDAT" using 2:3 if value_in_column_1 == 0 with lines lw 2 title "Serie"
# replot
# quit
# END_GNUPLOT
# #
# # echo "Generating plot..."
# gnuplot << END_GNUPLOT
# set title "Aceleracion en serie"
# set ylabel "Tiempo"
# set xlabel "Tamano Matriz"
# set key right bottom
# set grid
# set term png
# set output "$fPNG2"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 1 with lines lw 2 title "Thread1"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 2 with lines lw 2 title "Thread2"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 3 with lines lw 2 title "Thread3"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 4 with lines lw 2 title "Thread4"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 5 with lines lw 2 title "Thread5"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 6 with lines lw 2 title "Thread6"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 7 with lines lw 2 title "Thread7"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 8 with lines lw 2 title "Thread8"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 9 with lines lw 2 title "Thread9"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 10 with lines lw 2 title "Thread10"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 11 with lines lw 2 title "Thread11"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 12 with lines lw 2 title "Thread12"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 13 with lines lw 2 title "Thread13"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 14 with lines lw 2 title "Thread14"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 15 with lines lw 2 title "Thread15"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 16 with lines lw 2 title "Thread16"
# replot
# quit
# END_GNUPLOT
# # llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
# # estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"
# gnuplot << END_GNUPLOT
# set title "Aceleracion en serie"
# set ylabel "Tiempo"
# set xlabel "Tamano Matriz"
# set key right bottom
# set grid
# set term png
# set output "$fPNG2"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 1 with lines lw 2 title "Thread1Par"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 2 with lines lw 2 title "Thread2Par"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 3 with lines lw 2 title "Thread3Par"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 4 with lines lw 2 title "Thread4Par"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 5 with lines lw 2 title "Thread5Par"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 6 with lines lw 2 title "Thread6Par"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 7 with lines lw 2 title "Thread7Par"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 8 with lines lw 2 title "Thread8Par"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 9 with lines lw 2 title "Thread9Par"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 10 with lines lw 2 title "Thread10Par"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 11 with lines lw 2 title "Thread11Par"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 12 with lines lw 2 title "Thread12Par"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 13 with lines lw 2 title "Thread13Par"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 14 with lines lw 2 title "Thread14Par"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 15 with lines lw 2 title "Thread15Par"
# plot "$fDATAUX" using 2:3 if value_in_column_1 == 16 with lines lw 2 title "Thread16Par"
# replot
# quit
# END_GNUPLOT

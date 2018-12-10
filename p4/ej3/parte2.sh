#!/bin/bash
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -pe openmp 16
fDAT=serie_parte2.txt
fDAT2=par_parte2.txt
fPNG=tiempo.png
fPNG2=aceleracion.png
# $fDAT $fDAT2
# rm -f $fDAT2
# rm -f  $fDAT
# touch  $fDAT $fDAT2

# export OMP_NUM_THREADS=4
# for S in $(seq 513 64 1537);do
# echo "Ejecutando multN_serie..."
#
#     serie=$(./multN_serie $S | grep 'time:' | awk '{print $2}')
#     echo "serie	$S $serie 1" >> $fDAT
#
#
# echo "Ejecutando multN_par3..."
#     bucle3=$(./multN_par3 $S | grep 'time:' | awk '{print $2}')
#     acel=$(echo "scale=5; $serie/$bucle3" | bc )
#     echo "bucle3	$S $bucle3 $acel" >> $fDAT2
# done


echo "Generating plot..."
gnuplot << END_GNUPLOT
set title "Tiempo ejecucion en paralelo"
set ylabel "Tiempo"
set xlabel "Tamano Matriz"
set key right bottom
set grid
set term png
set output "$fPNG"
plot "$fDAT" using 2:3 with lines lw 2 title "Serie", "$fDAT2" using 2:3 with lines lw 2 title "Bucle3"
replot
quit
END_GNUPLOT
# llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
# estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"
gnuplot << END_GNUPLOT
set title "Aceleracion respecto a serie"
set ylabel "Veces mas rapido que en serie"
set xlabel "Tamano Matriz"
set key right bottom
set grid
set term png
set output "$fPNG2"

plot "$fDAT" using 2:4 with lines lw 2 title "Serie",\
   "$fDAT2" using 2:4 with lines lw 2 title "Bucle3"
replot
quit
END_GNUPLOT

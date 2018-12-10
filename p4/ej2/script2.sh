#!/bin/sh
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -pe openmp 16


fDAT=serie.dat

fDATAUX=auxiliar.dat
fDAT1=auxiliar1.dat
fDAT2=auxiliar2.dat
fDAT4=auxiliar4.dat
fDAT8=auxiliar8.dat
fDAT16=auxiliar16.dat

fPNG=grafica1.png
fPNG1=grafica2.png
fPNG2=grafica3.png



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
plot "$fDAT" using 2:3 with lines lw 2 title "Serie"
replot
quit
END_GNUPLOT
#
 echo "Generating plot..."
gnuplot << END_GNUPLOT
set title "Tiempo ejecucion en paralelo"
set ylabel "Tiempo"
set xlabel "Tamano Matriz"
set key right bottom
set grid
set term png
set output "$fPNG1"
plot "$fDATAUX" using 1:2 with lines lw 2 title "Serie",\
    "$fDAT1" using 1:2 with lines lw 2 title "Thread1",\
    "$fDAT2" using 1:2 with lines lw 2 title "Thread2",\
    "$fDAT4" using 1:2 with lines lw 2 title "Thread4",\
    "$fDAT8" using 1:2 with lines lw 2 title "Thread8",\
    "$fDAT16" using 1:2 with lines lw 2 title "Thread16"
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

plot "$fDAT" using 1:3 with lines lw 2 title "Serie",\
    "$fDAT1" using 1:3 with lines lw 2 title "Thread1",\
    "$fDAT2" using 1:3 with lines lw 2 title "Thread2",\
    "$fDAT4" using 1:3 with lines lw 2 title "Thread4",\
    "$fDAT8" using 1:3 with lines lw 2 title "Thread8",\
    "$fDAT16" using 1:3 with lines lw 2 title "Thread16"
replot
quit
END_GNUPLOT

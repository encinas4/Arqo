#!/bin/sh
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -pe openmp 16


fDAT=serie.dat

fDATAUX=auxiliar.dat
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
# echo "Generating plot..."
gnuplot << END_GNUPLOT
set title "Aceleracion en paralelo"
set ylabel "Tiempo"
set xlabel "Tamano Matriz"
set key right bottom
set grid
set term png
set output "$fPNG1"
plot "$fDATAUX" using 2:($1==P1?$3:1/0) with lines lw 2 title "Thread1Par"
plot "$fDATAUX" using 2:($1==P2?$3:1/0) with lines lw 2 title "Thread2Par"
plot "$fDATAUX" using 2:($1==P3?$3:1/0) with lines lw 2 title "Thread3Par"
plot "$fDATAUX" using 2:($1==P4?$3:1/0) with lines lw 2 title "Thread4Par"
plot "$fDATAUX" using 2:($1==P5?$3:1/0) with lines lw 2 title "Thread5Par"
plot "$fDATAUX" using 2:($1==P6?$3:1/0) with lines lw 2 title "Thread6Par"
plot "$fDATAUX" using 2:($1==P7?$3:1/0) with lines lw 2 title "Thread7Par"
plot "$fDATAUX" using 2:($1==P8?$3:1/0) with lines lw 2 title "Thread8Par"
plot "$fDATAUX" using 2:($1==P9?$3:1/0) with lines lw 2 title "Thread9Par"
plot "$fDATAUX" using 2:($1==P10?$3:1/0) with lines lw 2 title "Thread10Par"
plot "$fDATAUX" using 2:($1==P11?$3:1/0) with lines lw 2 title "Thread11Par"
plot "$fDATAUX" using 2:($1==P12?$3:1/0) with lines lw 2 title "Thread12Par"
plot "$fDATAUX" using 2:($1==P13?$3:1/0) with lines lw 2 title "Thread13Par"
plot "$fDATAUX" using 2:($1==P14?$3:1/0) with lines lw 2 title "Thread14Par"
plot "$fDATAUX" using 2:($1==P15?$3:1/0) with lines lw 2 title "Thread15Par"
plot "$fDATAUX" using 2:($1==P16?$3:1/0) with lines lw 2 title "Thread16Par"
replot
quit
END_GNUPLOT
# llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
# estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"
gnuplot << END_GNUPLOT
set title "Aceleracion respecto a serie"
set ylabel "Tiempo"
set xlabel "Tamano Matriz"
set key right bottom
set grid
set term png
set output "$fPNG2"
plot "$fDATAUX" using 2:("$1"==P1?$3:1/0) with lines lw 2 title "Thread1Par"
plot "$fDATAUX" using 2:("$1"==P2?$3:1/0) with lines lw 2 title "Thread2Par"
plot "$fDATAUX" using 2:($1==P3?$3:1/0) with lines lw 2 title "Thread3Par"
plot "$fDATAUX" using 2:($1==P4?$3:1/0) with lines lw 2 title "Thread4Par"
plot "$fDATAUX" using 2:($1==P5?$3:1/0) with lines lw 2 title "Thread5Par"
plot "$fDATAUX" using 2:($1==P6?$3:1/0) with lines lw 2 title "Thread6Par"
plot "$fDATAUX" using 2:($1==P7?$3:1/0) with lines lw 2 title "Thread7Par"
plot "$fDATAUX" using 2:($1==P8?$3:1/0) with lines lw 2 title "Thread8Par"
plot "$fDATAUX" using 2:($1==P9?$3:1/0) with lines lw 2 title "Thread9Par"
plot "$fDATAUX" using 2:($1==P10?$3:1/0) with lines lw 2 title "Thread10Par"
plot "$fDATAUX" using 2:($1==P11?$3:1/0) with lines lw 2 title "Thread11Par"
plot "$fDATAUX" using 2:($1==P12?$3:1/0) with lines lw 2 title "Thread12Par"
plot "$fDATAUX" using 2:($1==P13?$3:1/0) with lines lw 2 title "Thread13Par"
plot "$fDATAUX" using 2:($1==P14?$3:1/0) with lines lw 2 title "Thread14Par"
plot "$fDATAUX" using 2:($1==P15?$3:1/0) with lines lw 2 title "Thread15Par"
plot "$fDATAUX" using 2:($1==P16?$3:1/0) with lines lw 2 title "Thread16Par"
replot
quit
END_GNUPLOT

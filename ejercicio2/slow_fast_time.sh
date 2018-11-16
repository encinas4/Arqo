#!/bin/bash

# inicializar variables
Ninicio=7120
Npaso=64
Nfinal=8144
fDAT=slow_fast_time.dat
fPNG=slow_fast_time.png
SizeCacheI=1024
SizeCacheF=8196
Spaso=1024

# borrar el fichero DAT y el fichero PNG
rm -f $fDAT fPNG

# generar el fichero DAT vacío
touch $fDAT

echo "Running slow and fast..."
# bucle para N desde P hasta Q
for N in $(seq $Ninicio $Npaso $Nfinal);do
	echo "N: $N / $Nfinal..."

	# ejecutar los programas slow y fast consecutivamente con tamaño de matriz N
	# para cada uno, filtrar la línea que contiene el tiempo y seleccionar la
	# tercera columna (el valor del tiempo). Dejar los valores en variables
	# para poder imprimirlos en la misma línea del fichero de datos
	for S in $(seq $SizeCacheI $Spaso $SizeCacheF);do
		slowTime=$(valgrind --tool=callgrind --I1=$S,1,64 --D1=$S,1,64 --LL=8388608,1,64 ./slow $N | grep 'time' | awk '{print $3}')
		fastTime=$(valgrind --tool=callgrind --I1=$S,1,64 --D1=$S,1,64 --LL=8388608,1,64 ./fast $N | grep 'time' | awk '{print $3}')
		echo "$N	$slowTime	$fastTime" >> $fDAT
	done
done

echo "Generating plot..."
# llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
# estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"
gnuplot << END_GNUPLOT
set title "Slow-Fast Execution Time"
set ylabel "Execution time (s)"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$fPNG"
plot "$fDAT" using 1:2 with lines lw 2 title "slow", \
     "$fDAT" using 1:3 with lines lw 2 title "fast"
replot
quit
END_GNUPLOT

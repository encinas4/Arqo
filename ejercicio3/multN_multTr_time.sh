#!/bin/bash

 inicializar variables
 # inicialmente era 1706 a 1792
 Ninicio=384
 Npaso=16
 Nfinal=428

# Ninicio=1
# Npaso=32
# Nfinal=33

fDAT=cachem_
fPNG=cache_read.png
fPNG2=cache_write.png
SizeCacheI=1024
SizeCacheF=8196
Spaso=1024
fDAT1=cachem_1024.dat
fDAT2=cachem_2048.dat
fDAT3=cachem_4096.dat
fDAT4=cachem_8192.dat


# borrar el fichero DAT y el fichero PNG
rm -f $fDAT1 $fDAT2 $fDAT3 $fDAT4 $fPNG

# generar el fichero DAT vacío

touch $fDAT1
touch $fDAT2
touch $fDAT3
touch $fDAT4

echo "Running slow and fast..."
# bucle para N desde P hasta Q
for N in $(seq $Ninicio $Npaso $Nfinal);do
	echo "N: $N / $Nfinal..."

	# ejecutar los programas slow y fast consecutivamente con tamaño de matriz N
	# para cada uno, filtrar la línea que contiene el tiempo y seleccionar la
	# tercera columna (el valor del tiempo). Dejar los valores en variables
	# para poder imprimirlos en la misma línea del fichero de datos
	for S in 1024 2048 4096 8192;do
		valgrind --tool=cachegrind --cachegrind-out-file=multN.out.dat --I1=$S,1,64 --D1=$S,1,64 --LL=8388608,1,64 ./multN $N
		valgrind --tool=cachegrind --cachegrind-out-file=multTr.out.dat --I1=$S,1,64 --D1=$S,1,64 --LL=8388608,1,64 ./multTr $N
		slowTime5=$(cg_annotate multN.out.dat | grep PROGRAM | awk '{print $5}' | tr -d ',')
		slowTime8=$(cg_annotate multN.out.dat | grep PROGRAM | awk '{print $8}' | tr -d ',')
		fastTime5=$(cg_annotate multTr.out.dat | grep PROGRAM | awk '{print $5}' | tr -d ',')
		fastTime8=$(cg_annotate multTr.out.dat | grep PROGRAM | awk '{print $8}' | tr -d ',')
		echo "$N	$slowTime5 $slowTime8 $fastTime5	$fastTime8" >> $fDAT$S.dat
	done
done

echo "Generating plot..."
# llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
# estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"
gnuplot << END_GNUPLOT
set title "Cache Read"
set ylabel "Number of fails"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$fPNG"

plot "$fDAT1" using 1:2 with lines lw 2 title "multN1024", \
		 "$fDAT2" using 1:2 with lines lw 2 title "multN2048", \
		 "$fDAT3" using 1:2 with lines lw 2 title "multN4096", \
		 "$fDAT4" using 1:2 with lines lw 2 title "multN8192", \
     "$fDAT1" using 1:4 with lines lw 2 title "multTr1024", \
		 "$fDAT2" using 1:4 with lines lw 2 title "multTr2048", \
		 "$fDAT3" using 1:4 with lines lw 2 title "mulTr4096", \
		 "$fDAT4" using 1:4 with lines lw 2 title "mulTr8192"
replot
quit
END_GNUPLOT
#
# echo "Generating plot..."
gnuplot << END_GNUPLOT
set title "Cache Write"
set ylabel "Number of fails"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$fPNG2"

plot "$fDAT1" using 1:3 with lines lw 2 title "slow1024", \
		 "$fDAT2" using 1:3 with lines lw 2 title "slow2048", \
		 "$fDAT3" using 1:3 with lines lw 2 title "slow4096", \
		 "$fDAT4" using 1:3 with lines lw 2 title "slow8192", \
     "$fDAT1" using 1:5 with lines lw 2 title "fast1024", \
		 "$fDAT2" using 1:5 with lines lw 2 title "fast2048", \
		 "$fDAT3" using 1:5 with lines lw 2 title "fast4096", \
		 "$fDAT4" using 1:5 with lines lw 2 title "fast8192"
replot
quit
END_GNUPLOT

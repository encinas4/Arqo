#!/bin/bash

 inicializar variables
 Ninicio=7120
 Npaso=64
 Nfinal=8144

# Ninicio=1
# Npaso=32
# Nfinal=33

fDAT=cache_
fPNG=cache_lectura.png
fPNG2=cache_escritura.png
fDAT1=cache_1024.dat
fDAT2=cache_2048.dat
fDAT3=cache_4096.dat
fDAT4=cache_8192.dat


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
		valgrind --tool=cachegrind --cachegrind-out-file=slow.out.dat --I1=$S,1,64 --D1=$S,1,64 --LL=8388608,1,64 ./slow $N
		valgrind --tool=cachegrind --cachegrind-out-file=fast.out.dat --I1=$S,1,64 --D1=$S,1,64 --LL=8388608,1,64 ./fast $N
		slowTime5=$(cg_annotate slow.out.dat | grep PROGRAM | awk '{print $5}' | tr -d ',')
		slowTime8=$(cg_annotate slow.out.dat | grep PROGRAM | awk '{print $8}' | tr -d ',')
		fastTime5=$(cg_annotate fast.out.dat | grep PROGRAM | awk '{print $5}' | tr -d ',')
		fastTime8=$(cg_annotate fast.out.dat | grep PROGRAM | awk '{print $8}' | tr -d ',')
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
plot "$fDAT1" using 1:2 with lines lw 2 title "slow1024", \
		 "$fDAT2" using 1:2 with lines lw 2 title "slow2048", \
		 "$fDAT3" using 1:2 with lines lw 2 title "slow4096", \
		 "$fDAT4" using 1:2 with lines lw 2 title "slow8192", \
     "$fDAT1" using 1:4 with lines lw 2 title "fast1024", \
		 "$fDAT2" using 1:4 with lines lw 2 title "fast2048", \
		 "$fDAT3" using 1:4 with lines lw 2 title "fast4096", \
		 "$fDAT4" using 1:4 with lines lw 2 title "fast8192"
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

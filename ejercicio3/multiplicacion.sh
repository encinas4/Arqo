#!/bin/bash

#inicializar variables
#NOTA: Con 256 era 1706 a 1792
Ninicio=384
Npaso=16
Nfinal=428

#Ninicio=1
#Npaso=32
#Nfinal=33

fDAT=mult.dat
fPNG1=mult_cache.png
fPNG2=mult_time.png
fDAT1=matN.dat
fDAT2=matTr.dat

# borrar el fichero DAT y el fichero PNG
rm -f $fDAT $fPNG1 $fPNG2

# generar el fichero DAT vacío
touch $fDAT
touch $fDAT1
touch $fDAT2

echo "Running Multication matrix normal..."
# bucle para N desde P hasta Q
for N in $(seq $Ninicio $Npaso $Nfinal);do
	echo "N: $N / $Nfinal..."

	# ejecutar los programas slow y fast consecutivamente con tamaño de matriz N
	# para cada uno, filtrar la línea que contiene el tiempo y seleccionar la
	# tercera columna (el valor del tiempo). Dejar los valores en variables
	# para poder imprimirlos en la misma línea del fichero de datos
	time1=$(valgrind --tool=cachegrind --cachegrind-out-file=multN.out.dat --I1=8192,1,64 --D1=8192,1,64 --LL=8388608,1,64 ./multN $N | grep 'time' | awk '{print $3}')
	slowTime5=$(cg_annotate multN.out.dat | grep PROGRAM | awk '{print $5}' | tr -d ',')
	slowTime8=$(cg_annotate multN.out.dat | grep PROGRAM | awk '{print $8}' | tr -d ',')
	echo "$N $time1 $slowTime5 $slowTime8" >> $fDAT1
done

echo "Running Multication matrix trasp..."
for N in $(seq $Ninicio $Npaso $Nfinal);do
	echo "N: $N / $Nfinal..."

	# ejecutar los programas slow y fast consecutivamente con tamaño de matriz N
	# para cada uno, filtrar la línea que contiene el tiempo y seleccionar la
	# tercera columna (el valor del tiempo). Dejar los valores en variables
	# para poder imprimirlos en la misma línea del fichero de datos

	time2=$(valgrind --tool=cachegrind --cachegrind-out-file=multTr.out.dat --I1=8192,1,64 --D1=8192,1,64 --LL=8388608,1,64 ./multTr $N | grep 'time' | awk '{print $3}')
	fastTime5=$(cg_annotate multTr.out.dat | grep PROGRAM | awk '{print $5}' | tr -d ',')
	fastTime8=$(cg_annotate multTr.out.dat | grep PROGRAM | awk '{print $8}' | tr -d ',')
	echo "$N $time2 $fastTime5 $fastTime8" >> $fDAT2
done

echo "Volcamos los datos de los dos ficheros en uno..."
for N in $(seq $Ninicio $Npaso $Nfinal);do
	time1=$(grep $N $fDAT1 | awk '{print $2}')
  matN1=$(grep $N $fDAT1 | awk '{print $3}')
  matN2=$(grep $N $fDAT1 | awk '{print $4}')
  time2=$(grep $N $fDAT2 | awk '{print $2}')
  matTr1=$(grep $N $fDAT2 | awk '{print $3}')
  matTr2=$(grep $N $fDAT2 | awk '{print $4}')

  echo "$N $time1 $matN1 $matN2 $time2 $matTr1 $matTr2" >> $fDAT
done

rm -f $fDAT1 $fDAT2

echo "Generating plot of Cache Fail related with size..."
# llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
# estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"
gnuplot << END_GNUPLOT
set title "Cache Fails related with size"
set ylabel "Number of fails"
set xlabel "Matrix size"
set key right bottom
set grid
set term png
set output "$fPNG1"
plot "$fDAT" using 1:3 with lines lw 2 title "freadNormal", \
     "$fDAT" using 1:4 with lines lw 2 title "fwriteNormal", \
     "$fDAT" using 1:6 with lines lw 2 title "freadTrasp", \
     "$fDAT" using 1:7 with lines lw 2 title "fwriteTrasp"
replot
quit
END_GNUPLOT

echo "Generating plot of Execution Time related with size..."
gnuplot << END_GNUPLOT
set title "Time related with size"
set ylabel "Execution Time"
set xlabel "Matrix size"
set key right bottom
set grid
set term png
set output "$fPNG2"
plot "$fDAT" using 1:2 with lines lw 2 title "TimeNormal",\
     "$fDAT" using 1:5 with lines lw 2 title "TimeTrasp"
replot
quit
END_GNUPLOT

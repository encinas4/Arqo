#!/bin/bash

# inicializar variables
Ninicio=1
Npaso=64
Nfinal=300
auxS=0
auxF=0
fDAT=slow_fast_time.dat
fPNG=slow_fast_time.png
#fDAT=slow_fast_time.dat
#fPNG=slow_fast_time.png

# borrar el fichero DAT y el fichero PNG
rm -f $fDAT fPNG

# generar el fichero DAT vacío

for i in $(seq 1 1 10); do
	echo "Running slow and fast 10 times..."
	touch "slowTime$i.dat"
	touch "fastTime$i.dat"
	# bucle para N desde Ninicio hasta Nfinal
	for N in $(seq $Ninicio $Npaso $Nfinal); do
		echo "N: $N / $Nfinal the slow program..."

		# ejecutar los programas slow y fast consecutivamente con tamaño de matriz N
		# para cada uno, filtrar la línea que contiene el tiempo y seleccionar la
		# tercera columna (el valor del tiempo). Dejar los valores en variables
		# para poder imprimirlos en la misma línea del fichero de datos
		slowTime=$(./slow $N | grep 'time' | awk '{print $3}')
		slow$i$N=$slowTime
		echo "$N	$slowTime" >> slowTime$i.dat
	done
	# bucle para N desde Ninicio hasta Nfinal
	for N in $(seq $Ninicio $Npaso $Nfinal); do
		echo "N: $N / $Nfinal the fast programm..."

		# ejecutar los programas slow y fast consecutivamente con tamaño de matriz N
		# para cada uno, filtrar la línea que contiene el tiempo y seleccionar la
		# tercera columna (el valor del tiempo). Dejar los valores en variables
		# para poder imprimirlos en la misma línea del fichero de datos
		fastTime=$(./fast $N | grep 'time' | awk '{print $3}')
		fast$i$N=$fastTime
		echo "$N	$fastTime" >> fastTime$i.dat
	done
done

for N in $(seq $Ninicio $Npaso $Nfinal); do
	auxS$N=0
	auxF$N=0
	for i in $(seq 1 1 10); do
		auxS$N+=slow$i$N
		auxF$N+=fast$i$N
	done
	auxS=auxS$N/10
	auxF=auxF$N/10

	echo "$N	$auxS	$auxF" >> $fDAT
done



#Ahora hay que calcular la media de cada fichero slow y fast con un numero y volcarlo en otro fichero que tenga todas las medias y plotearlo

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
plot "$slowTime$i.dat" using 1:2 with lines lw 2 title "slow", \
     "$fastTime$i.dat" using 1:3 with lines lw 2 title "fast"
replot
quit
END_GNUPLOT

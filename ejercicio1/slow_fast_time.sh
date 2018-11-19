# inicializar variables
Ninicio=15120
Npaso=64
Nfinal=16144
fDAT=slow_fast_time.dat
fPNG=slow_fast_time.png

# borrar el fichero DAT y el fichero PNG
rm -f $fDAT $fPNG
rm -f slowTime.dat
rm -f fastTime.dat

# generar el fichero DAT vacío


for i in $(seq 1 1 10); do
	echo "Running slow and fast 10 times..."
	touch "slowTime.dat"
	touch "fastTime.dat"
	# bucle para N desde Ninicio hasta Nfinal
	for N in $(seq $Ninicio $Npaso $Nfinal); do
		echo "N: $N / $Nfinal the slow program..."

		# ejecutar los programas slow y fast consecutivamente con tamaño de matriz N
		# para cada uno, filtrar la línea que contiene el tiempo y seleccionar la
		# tercera columna (el valor del tiempo). Dejar los valores en variables
		# para poder imprimirlos en la misma línea del fichero de datos
		slowTime=$(./slow $N | grep 'time' | awk '{print $3}')

		echo "$N	$slowTime" >> slowTime.dat
	done

	# bucle para N desde Ninicio hasta Nfinal
	for N in $(seq $Ninicio $Npaso $Nfinal); do
		echo "N: $N / $Nfinal the fast programm..."

		# ejecutar los programas slow y fast consecutivamente con tamaño de matriz N
		# para cada uno, filtrar la línea que contiene el tiempo y seleccionar la
		# tercera columna (el valor del tiempo). Dejar los valores en variables
		# para poder imprimirlos en la misma línea del fichero de datos
		fastTime=$(./fast $N | grep 'time' | awk '{print $3}')

		echo "$N	$fastTime" >> fastTime.dat
	done
done

touch $fDAT

for N in $(seq $Ninicio $Npaso $Nfinal); do
	slowtime=$(grep -n $N slowTime.dat | awk '{suma += $2} END {print suma/NR}')
	fasttime=$(grep -n $N fastTime.dat | awk '{suma += $2} END {print suma/NR}')

 	echo "$N  $slowtime  $fasttime" >> $fDAT
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
plot "$fDAT" using 1:2 with lines lw 2 title "slow", \
     "$fDAT" using 1:3 with lines lw 2 title "fast"
replot
quit
END_GNUPLOT

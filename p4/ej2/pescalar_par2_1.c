// ----------- Arqo P4-----------------------
// pescalar_par2
//
#include <stdio.h>
#include <stdlib.h>
#include "arqo4.h"

int main(int argc, char *argv[])
{
	float *A=NULL, *B=NULL;
	long long k=0;
	struct timeval fin,ini;
	int m;
	double sum=0;

	if(argc <= 1) {
		printf("Introduce el tamano del vector\n");
		return -1;
	}else if(argc > 2) {
		printf("Demasiados argumentos\n");
		return -1;
	}else {
		m = atoi(argv[1]);
		A = generateVector(m);
		B = generateVector(m);
	}
	if ( !A || !B )
	{
		printf("Error when allocationg matrix\n");
		freeVector(A);
		freeVector(B);
		return -1;
	}

	gettimeofday(&ini,NULL);
	/* Bloque de computo */
	sum = 0;
	#pragma omp parallel for reduction(+:sum)
	for(k=0;k<m;k++)
	{
		sum = sum + A[k]*B[k];
	}
	/* Fin del computo */
	gettimeofday(&fin,NULL);

	printf("Resultado: %lf\n",sum);
	printf("Tiempo: %f\n", ((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);
	freeVector(A);
	freeVector(B);

	return 0;
}

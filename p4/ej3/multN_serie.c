#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#include "arqo3.h"

void compute(tipo **matrix, tipo **matrix2, tipo **resultado, int n);

int main( int argc, char *argv[])
{
	int n;
	tipo **m=NULL;
  tipo **m2=NULL;
  tipo **res=NULL;
	struct timeval fin,ini;


	printf("Word size: %ld bits\n",8*sizeof(tipo));

	if( argc!=2 )
	{
		printf("Error: ./%s <matrix size>\n", argv[0]);
		return -1;
	}
	n=atoi(argv[1]);
	m=generateMatrix(n);
  m2=generateMatrix(n);
  res=generateEmptyMatrix(n);
	if( !m )
	{
		return -1;
	}
  if( !m2 )
	{
		return -1;
	}
  if( !res )
	{
		return -1;
	}


	gettimeofday(&ini,NULL);

	/* Main computation */
	compute(m, m2, res, n);
	/* End of computation */

	gettimeofday(&fin,NULL);
	printf("time: %f\n", ((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);




	free(m);
	free(m2);
	free(res);
	return 0;
}


void compute(tipo **matrix, tipo **matrix2, tipo **resultado, int n) {

	int i,j,k ,l;

	for(i=0;i<n;i++) {
		for(j=0;j<n;j++) {
      for(k=0, l=0; k<n && l<n; k++, l++){
        resultado[i][j] += matrix[i][k]*matrix2[l][j];
        }
			}
	}

}

#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <omp.h>
#include "arqo4.h"



int main( int argc, char *argv[])
{
	int n;

	float **m=NULL;
  float **m2=NULL;
  float **res=NULL;
	struct timeval fin,ini;


	printf("Word size: %ld bits\n",8*sizeof(float));

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
	#pragma omp parallel
	{
	int i,j,k;

	for(i=0;i<n;i++) {
		for(j=0;j<n;j++) {
			#pragma omp for
			for(k=0; k<n; k++){
				res[i][j] += m[i][k]*m2[k][j];
				}
			}
	}
}
	gettimeofday(&fin,NULL);
	printf("time: %f\n", ((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);




	free(m);
	free(m2);
	free(res);
	return 0;
}

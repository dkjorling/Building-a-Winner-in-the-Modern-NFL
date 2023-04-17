#include <R.h>
#include <Rmath.h>

void lowp (double *x, int *n, int *m, double *y)
{
	int i,j;
	double x1[*n][*m];

	for(j = 0; j < *m; j++) {
	   for(i = 0; i < *n; i++) {
	      x1[i][j] = x[j * *n + i];
	   }
	}
	for(i = 0; i< *m; i++){
		y[i] = x1[4][i];
	}
}

void highp (double *x, int *n, int *m, double *y)
{
	int i,j;
	double x1[*n][*m];

	for(j = 0; j < *m; j++) {
	   for(i = 0; i < *n; i++) {
	      x1[i][j] = x[j * *n + i];
	   }
	}
	for(i = 0; i< *m; i++){
		y[i] = x1[194][i];
	}
}


	

	
	
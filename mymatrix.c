#include <R.h>
#include <Rmath.h>

void matmult (double *a, int *n1, int *m1,
	      double *b, int *n2, int *m2,
	      double *y)
{
    int i,j,k;
    double x;
    double a1[*n1][*m1];
    double b1[*n2][*m2];    

    for(j = 0; j < *m1; j++) {
	for(i = 0; i < *n1; i++) {
	    a1[i][j] = a[j * *n1 + i];
	}
    }
    
    for(j = 0; j < *m2; j++) {
	for(i = 0; i < *n2; i++) {
	    b1[i][j] = b[j * *n2 + i];
	}
    }
	    
    for(i = 0; i < *n1; i++) {
	for(j = 0; j < *m2; j++) {
	    x = 0.0;
	    for(k = 0; k < *m1; k++) {
		x += a1[i][k] * b1[k][j];
	    }
	    y[i* *m2 + j] = x;  // y[i][j] = x;
	}
    }
}
#include <stdlib.h>
#include <math.h>
#include <stdio.h>
#include <complex.h>
#include <mpc.h>

// compile gcc bk.c -lmpc -o bk

#define PRECISION 200
#define RHO 1.0L

#define PRINT_MPC(prefix, x) printf("%s %.30g\n", prefix, creal(mpc_get_ldc(x, MPC_RNDNN)))
#define MPC_NEW(varname, value) mpc_t varname; mpc_init2(varname, PRECISION); mpc_set_ld(varname, value, MPC_RNDNN);

mpc_t rho;
//long double rho = 0.439L;

long double f(int k)
{
	if (k) 
		return k*f(k-1);
	else 
		return 1.0L;
}


void b(mpc_t sum, mpc_t rho, int n)
{
	volatile int k;
	mpc_set_ld(sum, 0.0L, MPC_RNDNN);
	
	for (k = 0; k <= n; k++)
	{
		// calculate nkkk = ((n-k)*p)^k/k!
		MPC_NEW(nkkk, 1.0L);

		// nkp = (n-k)*rho
		MPC_NEW(nkp, 1.0L*(n-k));
		mpc_mul(nkp, nkp, rho, MPC_RNDNN);

		// nkpi = (n-k)*p/i
		MPC_NEW(nkpi, 0.0L);

		for (unsigned int long i = 1; i <= k; i++)
		{
			// nkkk *= ((n-k)*p)/i
			mpc_div_ui(nkpi, nkp, i, MPC_RNDNN);
			mpc_mul(nkkk, nkpi, nkkk, MPC_RNDNN);
		}
		// the above is equivalent to nkkk = powl((n-k)*rho, k)/f(k);
		
		// enkp = exp((n-k)*p);
		MPC_NEW(enkp, 1.0L);
		mpc_exp(enkp, nkp, MPC_RNDNN);

		// nkkk = pow((n-k)*p, k) * exp((n-k)*p)) * 1/k! 
		mpc_mul(nkkk, nkkk, enkp, MPC_RNDNN);
		if (k % 2 == 1) // k is odd
			mpc_sub(sum, sum, nkkk, MPC_RNDNN);
		else // k is even
			mpc_add(sum, sum, nkkk, MPC_RNDNN);
	}
	PRINT_MPC("bk=", sum);
}

int main(int argc, char *argv[])
{

	if (argc < 3)
	{
		fprintf(stderr, "usage: b <k> <rho>\n");
		exit(3);
	}
	int k = atoi(argv[1]);
        double r = atof(argv[2]);
      
	MPC_NEW(rho, r);
	MPC_NEW(sum, 0.0L);
	MPC_NEW(bk, 0.0L);
        b(bk, rho, k);
        printf("estimated=%g\n", 1/(1 - r));
	//printf("--%Lg\n", bk);
}

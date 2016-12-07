#include <stdlib.h>
#include <math.h>
#include <stdio.h>
#include <complex.h>
#include <mpc.h>

// compile gcc xn.c -lmpc -o xn

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

	if (argc < 2)
	{
		fprintf(stderr, "usage: X <N>\n");
		exit(3);
	}
	int N = atoi(argv[1]);

	MPC_NEW(rho, RHO);
	MPC_NEW(sum, 0.0L);
	MPC_NEW(bk, 0.0L);
	for (volatile int k = 0; k <= N-1; k++)
	{
		b(bk, rho, k);
		mpc_add(sum, sum, bk, MPC_RNDNN);
	}

	// bk should be b(N-1) now
	// set rbN1 to 1 + p*B(N-1)
	MPC_NEW(rbN1, 0.0L);
	mpc_mul(rbN1, rho, bk, MPC_RNDNN);
	mpc_add_ui(rbN1, rbN1, 1, MPC_RNDNN);

	// set sum to sum/(1 + p*B(N-1))
	mpc_div(sum, sum, rbN1, MPC_RNDNN);

	long double XN = N - creal(mpc_get_ldc(sum, MPC_RNDNN));
	printf("--%Lg\n", XN);
}

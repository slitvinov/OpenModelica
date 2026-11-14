#include <dlfcn.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "fmi2Functions.h"

static void
logger(fmi2ComponentEnvironment e, fmi2String n, fmi2Status s, fmi2String c, fmi2String m, ...)
{
	va_list ap;

	if (s < fmi2Warning)
		return;
	va_start(ap, m);
	vfprintf(stderr, m, ap);
	fputc('\n', stderr);
	va_end(ap);
}

#define SYM(T, f) T *f = (T *)dlsym(h, #f); if (!f) { fprintf(stderr, "no %s\n", #f); return 1; }

int
main(int argc, char **argv)
{
	/* run.c lib guid resourceURI tstop dt */
	void *h = dlopen(argv[1], RTLD_NOW);
	double tstop = atof(argv[4]), dt = atof(argv[5]), t = 0;
	fmi2CallbackFunctions cb = {logger, calloc, free, NULL, NULL};
	struct timespec a, b;
	fmi2Component c;
	long n = 0;

	if (!h) { fprintf(stderr, "%s\n", dlerror()); return 1; }
	SYM(fmi2InstantiateTYPE, fmi2Instantiate);
	SYM(fmi2SetupExperimentTYPE, fmi2SetupExperiment);
	SYM(fmi2EnterInitializationModeTYPE, fmi2EnterInitializationMode);
	SYM(fmi2ExitInitializationModeTYPE, fmi2ExitInitializationMode);
	SYM(fmi2DoStepTYPE, fmi2DoStep);
	c = fmi2Instantiate("m", fmi2CoSimulation, argv[2], argv[3], &cb, fmi2False, fmi2False);
	if (!c) { fprintf(stderr, "instantiate failed\n"); return 1; }
	clock_gettime(CLOCK_MONOTONIC, &a);
	if (fmi2SetupExperiment(c, fmi2False, 0, 0, fmi2True, tstop) > fmi2Warning ||
	    fmi2EnterInitializationMode(c) > fmi2Warning || fmi2ExitInitializationMode(c) > fmi2Warning) {
		fprintf(stderr, "init failed\n");
		return 1;
	}
	clock_gettime(CLOCK_MONOTONIC, &b);
	clock_gettime(CLOCK_MONOTONIC, &a);
	for (; t < tstop - 1e-9; t += dt, n++)
		if (fmi2DoStep(c, t, dt, fmi2True) > fmi2Warning) {
			fprintf(stderr, "doStep failed at t=%g\n", t);
			return 1;
		}
	clock_gettime(CLOCK_MONOTONIC, &b);
	double s = b.tv_sec - a.tv_sec + 1e-9 * (b.tv_nsec - a.tv_nsec);
	printf("%ld fmi2DoStep calls of %g s: %.3f s\n", n, dt, s);
	return 0;
}

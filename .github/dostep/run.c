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

int
main(int argc, char **argv)
{
	/* run fmu.so guid resourceURI steps */
	void *h = dlopen(argv[1], RTLD_NOW);
	fmi2CallbackFunctions cb = {logger, calloc, free, NULL, NULL};
	long i, n = atol(argv[4]);
	struct timespec a, b;
	fmi2Component c;

	if (!h) { fprintf(stderr, "%s\n", dlerror()); return 1; }
	fmi2InstantiateTYPE *inst = (fmi2InstantiateTYPE *)dlsym(h, "fmi2Instantiate");
	fmi2SetupExperimentTYPE *setup = (fmi2SetupExperimentTYPE *)dlsym(h, "fmi2SetupExperiment");
	fmi2EnterInitializationModeTYPE *enter = (fmi2EnterInitializationModeTYPE *)dlsym(h, "fmi2EnterInitializationMode");
	fmi2ExitInitializationModeTYPE *leave = (fmi2ExitInitializationModeTYPE *)dlsym(h, "fmi2ExitInitializationMode");
	fmi2DoStepTYPE *step = (fmi2DoStepTYPE *)dlsym(h, "fmi2DoStep");
	c = inst("m", fmi2CoSimulation, argv[2], argv[3], &cb, fmi2False, fmi2False);
	if (!c) { fprintf(stderr, "instantiate failed\n"); return 1; }
	if (setup(c, fmi2False, 0, 0, fmi2False, 0) > fmi2Warning || enter(c) > fmi2Warning || leave(c) > fmi2Warning) { fprintf(stderr, "init failed\n"); return 1; }
	clock_gettime(CLOCK_MONOTONIC, &a);
	for (i = 0; i < n; i++)
		if (step(c, i * 1e-3, 1e-3, fmi2True) > fmi2Warning) { fprintf(stderr, "doStep failed\n"); return 1; }
	clock_gettime(CLOCK_MONOTONIC, &b);
	printf("%.2f us per fmi2DoStep\n", 1e6 * (b.tv_sec - a.tv_sec + 1e-9 * (b.tv_nsec - a.tv_nsec)) / n);
	return 0;
}

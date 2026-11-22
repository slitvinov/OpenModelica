#include <fcntl.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ModelicaInternal.h"

void ModelicaError(const char *s) { exit(1); }
void ModelicaFormatError(const char *f, ...) { exit(1); }
void ModelicaFormatMessage(const char *f, ...) { }
char *ModelicaAllocateString(size_t n) { return calloc(n + 1, 1); }
char *ModelicaDuplicateString(const char *s) { return strdup(s); }
char *ModelicaDuplicateStringWithErrorReturn(const char *s) { return strdup(s); }

static int nopen(void) {
  int fd, n = 0;
  for (fd = 0; fd < 4096; fd++) n += fcntl(fd, F_GETFD) != -1;
  return n;
}

static void *reader(void *p) {
  int i, eof;
  for (i = 0; i < 1000; i++) {
    ModelicaInternal_readLine("f.txt", 1, &eof);
    ModelicaInternal_readLine("f.txt", 2, &eof);
  }
  return NULL;
}

int main(int argc, char **argv) {
  int i, n, nt = atoi(argv[1]);
  pthread_t t[4];
  FILE *f = fopen("f.txt", "w");
  fputs("a\nb\n", f);
  fclose(f);
  n = nopen();
  for (i = 0; i < nt; i++) pthread_create(&t[i], NULL, reader, NULL);
  for (i = 0; i < nt; i++) pthread_join(t[i], NULL);
  printf("%d %d\n", nt, nopen() - n);
}


/*
 * stdlib.h - STDLIB library header.
 *
 * Copyright (C) 2020-2026 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

/* __REF__ http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/stdlib.h.html */

#ifndef _STDLIB_H
#define _STDLIB_H 1

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct { int quot; int rem; } div_t;
typedef struct { long quot; long rem; } ldiv_t;

extern void           abort(void) __attribute__((noreturn));
extern int            abs(int);
extern int            atoi(const char *);
extern long           atol(const char *);
extern div_t          div(int, int);
extern long           labs(long);
extern ldiv_t         ldiv(long, long);
extern long           strtol(const char *, char **, int);
extern unsigned long  strtoul(const char *, char **, int);
extern void          *malloc(size_t);
extern void          *calloc(size_t, size_t);
extern void          *realloc(void *, size_t);
extern void           free(void *);

#define EXIT_SUCCESS 0
#define EXIT_FAILURE 1

#ifdef __cplusplus
}
#endif

#endif /* _STDLIB_H */


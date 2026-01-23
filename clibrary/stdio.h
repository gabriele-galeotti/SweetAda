
/*
 * stdio.h - STDIO library header.
 *
 * Copyright (C) 2020-2026 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

/* __REF__ http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/stdio.h.html */

#ifndef _STDIO_H
#define _STDIO_H 1

#include <stdarg.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

extern int printf(const char *, ...) __attribute__((format (printf, 1, 2)));
extern int putchar(int);
extern int puts(const char *);
extern int sprintf(char *, const char *, ...) __attribute__((format (printf, 2, 3)));
extern int vsnprintf(char *, size_t, const char *, va_list);

#define EOF (-1)

#ifdef __cplusplus
}
#endif

#endif /* _STDIO_H */


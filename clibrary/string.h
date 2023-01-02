
/*
 * string.h - STRING library header.
 *
 * Copyright (C) 2020-2023 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

/* __REF__ http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/string.h.html */

#ifndef _STRING_H
#define _STRING_H 1

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

extern void   *memchr(const void *, int, size_t);
extern int     memcmp(const void *, const void *, size_t);
extern void   *memcpy(void *, const void *, size_t);
extern void   *memmove(void *, const void *, size_t);
extern void   *memset(void *, int, size_t);
extern int     strcasecmp(const char *, const char *);
extern char   *strcat(char *, const char *);
extern char   *strchr(const char *, int);
extern int     strcmp(const char *, const char *);
extern char   *strcpy(char *, const char *);
extern size_t  strcspn(const char *, const char *);
extern size_t  strlen(const char *);
extern int     strncasecmp(const char *, const char *, size_t);
extern char   *strncat(char *, const char *, size_t);
extern int     strncmp(const char *, const char *, size_t);
extern char   *strncpy(char *, const char *, size_t);
extern size_t  strnlen(const char *, size_t);
extern char   *strpbrk(const char *, const char *);
extern char   *strrchr(const char *, int);
extern size_t  strspn(const char *, const char *);
extern char   *strstr(const char *, const char *);

#ifdef __cplusplus
}
#endif

#endif /* _STRING_H */


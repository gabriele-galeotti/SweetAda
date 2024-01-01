
/*
 * assert.h - ASSERT library header.
 *
 * Copyright (C) 2020-2024 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

/* __REF__ http://pubs.opengroup.org/onlinepubs/009695399/basedefs/assert.h.html */

#ifndef _ASSERT_H
#define _ASSERT_H 1

#ifdef __cplusplus
extern "C" {
#endif

#undef assert

#if defined(NDEBUG)
# define assert(ignore) ((void)0)
#else
extern void __assert(const char *, int, const char *, const char *) __attribute__((noreturn));
# if defined(__STDC__)
#  define assert(e) ((e) != 0 ? (void)0 : __assert(__FILE__, __LINE__, __func__, #e))
# else
#  define assert(e) ((e) != 0 ? (void)0 : __assert(__FILE__, __LINE__, __func__, "e"))
# endif
#endif /* NDEBUG */

#ifdef __cplusplus
}
#endif

#endif /* _ASSERT_H */



/*
 * strings.h - BSD "strings" library header.
 *
 * Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

/* __REF__ http://pubs.opengroup.org/onlinepubs/7908799/xsh/strings.h.html */

#ifndef _STRINGS_H
#define _STRINGS_H 1

#include <stddef.h>
#include <string.h> /* strchr(), strrchr() */

#ifdef __cplusplus
extern "C" {
#endif

extern int  bcmp(const void *, const void *, size_t);
extern void bcopy(const void *, void *, size_t);
extern void bzero(void *, size_t);

// http://pubs.opengroup.org/onlinepubs/009695399/functions/index.html
#define index(a,b) strchr((a),(b))
// http://pubs.opengroup.org/onlinepubs/009695399/functions/rindex.html
#define rindex(a,b) strrchr((a),(b))

#ifdef __cplusplus
}
#endif

#endif /* _STRINGS_H */


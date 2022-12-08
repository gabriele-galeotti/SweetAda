
/*
 * errno.h - ERRNO library header.
 *
 * Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

/* __REF__ http://pubs.opengroup.org/onlinepubs/009695399/basedefs/errno.h.html */

#ifndef _ERRNO_H
#define _ERRNO_H 1

#ifdef __cplusplus
extern "C" {
#endif

extern volatile int errno;

#define EINVAL 1
#define ERANGE 2

#ifdef __cplusplus
}
#endif

#endif /* _ERRNO_H */



/*
 * ada_interface.h - C library Ada interface.
 *
 * Copyright (C) 2020-2023 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#ifndef _ADA_INTERFACE_H
#define _ADA_INTERFACE_H 1

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

extern void  ada_abort(void) __attribute__((noreturn));
extern void  ada_print_character(char);
extern void *ada_malloc(size_t);
extern void  ada_free(void *);
extern void *ada_calloc(size_t, size_t);
extern void *ada_realloc(void *, size_t);

#ifdef __cplusplus
}
#endif

#endif /* _ADA_INTERFACE_H */


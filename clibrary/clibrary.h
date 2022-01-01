
/*
 * clibrary.h - CLIBRARY configuration header.
 *
 * Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#ifndef _CLIBRARY_H
#define _CLIBRARY_H 1

//#define ENABLE_ABORT               1 /* enable abort() in stdlib.c */
//#define ENABLE_MEMORY_FUNCTIONS    1 /* enable mem[cmp|cpy|move|set]() in string.c, bcopy() in strings.c */
//#define SET_ERRNO                  1 /* use errno variable for errors */
//#define VSPRINTF_USE_INTERNAL_ATOI 1 /* use inlined internal_atoi() instead of strtol() */
#define PRINTF_BUFFER_SIZE         1024
#define LF_DOES_CR                 1

#include "ada_interface.h"

#endif /* _CLIBRARY_H */



/*
 * strings.c - BSD "strings" implementation library.
 *
 * Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#include <clibrary.h>
#include <strings.h>

/******************************************************************************
 * int bcmp(const void *s1, const void *s2, size_t n)                         *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/7908799/xsh/bcmp.html                 *
 * http://snipplr.com/view/22147/stringsh-implementation/                     *
 ******************************************************************************/
int
bcmp(const void *s1, const void *s2, size_t n)
{
        return memcmp(s1, s2, n);
}

#if defined(ENABLE_MEMORY_FUNCTIONS)

/******************************************************************************
 * void bcopy(const void *s1, void *s2, size_t n)                             *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/7908799/xsh/bcopy.html                *
 * http://snipplr.com/view/22147/stringsh-implementation/                     *
 ******************************************************************************/
void
bcopy(const void *s1, void *s2, size_t n)
{
        (void)memmove(s2, s1, n);
}

#endif

/******************************************************************************
 * void bzero(void *s, size_t n)                                              *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/7908799/xsh/bzero.html                *
 * http://snipplr.com/view/22147/stringsh-implementation/                     *
 ******************************************************************************/
void
bzero(void *s, size_t n)
{
        (void)memset(s, 0, n);
}



/*
 * stdlib.c - STDLIB implementation library.
 *
 * Copyright (C) 2020-2026 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#include <ada_interface.h>
#include <clibrary.h>

#include <ctype.h>
#include <errno.h>
#include <limits.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>

/******************************************************************************
 * void abort(void)                                                           *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/abort.html       *
 ******************************************************************************/
void
abort(void)
{
        ada_abort();
}

#define UNSIGNED (1 << 0) /* use unsigned long version */
#define NEGATIVE (1 << 1) /* "-" detected              */
#define OVERFLOW (1 << 2) /* overflow in conversion    */
#define ANYDIGIT (1 << 3) /* 1+ valid digits detected  */

/******************************************************************************
 * unsigned long strtoxl(const char *str, char **endptr, int base, int flags) *
 *                                                                            *
 * Ignores "locale" stuff. Assumes that the upper and lower case alphabets    *
 * and digits are each contiguous.                                            *
 ******************************************************************************/
static unsigned long
strtoxl(const char *str, char **endptr, int base, int flags)
{
        int           errno_code;
        unsigned long number;

        errno_code = 0;

        ada_strtoxl(str, endptr, base, flags, &number, &errno_code);

        if (errno_code != 0)
        {
                errno = errno_code;
        }

        return number;
}

/******************************************************************************
 * long strtol(const char *str, char **endptr, int base)                      *
 *                                                                            *
 * Ignores "locale" stuff. Assumes that the upper and lower case alphabets    *
 * and digits are each contiguous.                                            *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/strtol.html      *
 ******************************************************************************/
long
strtol(const char *str, char **endptr, int base)
{
        return (long)strtoxl(str, endptr, base, 0);
}

/******************************************************************************
 * unsigned long strtoul(const char *str, char **endptr, int base)            *
 *                                                                            *
 * Ignores "locale" stuff. Assumes that the upper and lower case alphabets    *
 * and digits are each contiguous.                                            *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/strtoul.html     *
 ******************************************************************************/
unsigned long
strtoul(const char *str, char **endptr, int base)
{
        return strtoxl(str, endptr, base, UNSIGNED);
}

/******************************************************************************
 * int atoi(const char *str)                                                  *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/atoi.html        *
 ******************************************************************************/
int
atoi(const char *str)
{
        return (int)strtol(str, (char **)NULL, 10);
}

/******************************************************************************
 * long atol(const char *str)                                                 *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/atol.html        *
 ******************************************************************************/
long
atol(const char *str)
{
        return strtol(str, (char **)NULL, 10);
}

/******************************************************************************
 * div_t div(int numer, int denom)                                            *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/div.html         *
 ******************************************************************************/
div_t
div(int numer, int denom)
{
        div_t result;

        /*
         * (C99 section 6.5.5):
         * the quotient is always truncated towards 0 and (equivalently) the
         * remainder always has the same sign as the numerator (dividend).
         */
        result.quot = numer / denom;
        result.rem = numer % denom;

        return result;
}

/******************************************************************************
 * ldiv_t ldiv(long numer, long denom)                                        *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/ldiv.html        *
 ******************************************************************************/
ldiv_t
ldiv(long numer, long denom)
{
        ldiv_t result;

        result.quot = numer / denom;
        result.rem = numer % denom;

        return result;
}

/******************************************************************************
 * int abs(int i)                                                             *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/abs.html         *
 ******************************************************************************/
int
abs(int i)
{
        return i < 0 ? -i : i;
}

/******************************************************************************
 * long labs(long i)                                                          *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/labs.html        *
 ******************************************************************************/
long
labs(long i)
{
        return i < 0 ? -i : i;
}

/******************************************************************************
 * void *malloc(size_t size)                                                  *
 *                                                                            *
 * https://pubs.opengroup.org/onlinepubs/9699919799/functions/malloc.html     *
 ******************************************************************************/
void *
malloc(size_t size)
{
        return ada_malloc(size);
}

/******************************************************************************
 * void free(void *ptr)                                                       *
 *                                                                            *
 * https://pubs.opengroup.org/onlinepubs/9699919799/functions/free.html       *
 ******************************************************************************/
void
free(void *ptr)
{
        ada_free(ptr);
}

/******************************************************************************
 * void *calloc(size_t nelem, size_t elsize)                                  *
 *                                                                            *
 * https://pubs.opengroup.org/onlinepubs/9699919799/functions/calloc.html     *
 ******************************************************************************/
void *
calloc(size_t nelem, size_t elsize)
{
        return ada_calloc(nelem, elsize);
}

/******************************************************************************
 * void *realloc(void *ptr, size_t size)                                      *
 *                                                                            *
 * https://pubs.opengroup.org/onlinepubs/9699919799/functions/realloc.html    *
 ******************************************************************************/
void *
realloc(void *ptr, size_t size)
{
        return ada_realloc(ptr, size);
}


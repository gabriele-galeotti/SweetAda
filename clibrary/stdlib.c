
/*
 * stdlib.c - STDLIB implementation library.
 *
 * Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
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

#if defined(ENABLE_ABORT)
/******************************************************************************
 * void abort(void)                                                           *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/abort.html       *
 ******************************************************************************/
void
abort(void)
{
        while (true)
        {
                /* __NOP__ */
        }
}
#endif

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
        unsigned long  number;
        const char    *p;
        char           c;
        unsigned long  cutoff;
        unsigned long  limit;
        int            digit;

        number = 0;
        p = str;

        /* check for invalid base */
        if (base < 0 || base == 1 || base > 36)
        {
#if defined(SET_ERRNO)
                errno = EINVAL;
#endif
                goto strtoxl_exit;
        }

        /* skip white spaces */
        do
        {
                c = *p++;
        } while (isspace(c) != 0);

        /* detect sign */
        if (c == '-')
        {
                flags |= NEGATIVE;
                c = *p++;
        }
        else if (c == '+')
        {
                c = *p++;
        }

        /* setup base */
        if ((base == 0 || base == 16) && c == '0' && (*p == 'x' || *p == 'X'))
        {
                base = 16;
                c = p[1];
                p += 2;
        }
        if (base == 0)
        {
                base = (c == '0' ? 8 : 10);
        }

        /* setup range values */
        if ((flags & UNSIGNED) != 0)
        {
                cutoff = ULONG_MAX / (unsigned long)base;
                limit  = ULONG_MAX % (unsigned long)base;
        }
        else
        {
                unsigned long maxvalue;
                /* use directly -LONG_MIN causes a warning */
                maxvalue = ((flags & NEGATIVE) != 0 ? -(unsigned long)LONG_MIN : (unsigned long)LONG_MAX);
                cutoff = maxvalue / (unsigned long)base;
                limit  = maxvalue % (unsigned long)base;
        }

        /* conversion loop */
        while (true)
        {
                if (isdigit(c) != 0)
                {
                        digit = c - '0';
                }
                else if (isalpha(c) != 0)
                {
                        digit = toupper(c) - 'A' + 10;
                }
                else
                {
                        break;
                }
                if (digit >= base)
                {
                        break;
                }
                /* valid digit */
                flags |= ANYDIGIT;
                if (
                    (flags & OVERFLOW) != 0                       ||
                    number > cutoff                               ||
                    (number == cutoff && (unsigned)digit > limit)
                   )
                {
                        flags |= OVERFLOW;
                }
                else
                {
                        number = number * base + digit;
                }
                c = *p++;
        }

        /* conversion overflowed */
        if ((flags & OVERFLOW) != 0)
        {
                if ((flags & UNSIGNED) != 0)
                {
                        number = ULONG_MAX;
                }
                else
                {
                        if ((flags & NEGATIVE) != 0)
                        {
                                number = (unsigned long)LONG_MIN;
                        }
                        else
                        {
                                number = (unsigned long)LONG_MAX;
                        }
                }
#if defined(SET_ERRNO)
                errno = ERANGE;
#endif
        }
        /* valid number */
        else if ((flags & NEGATIVE) != 0)
        {
                number = -number;
        }

strtoxl_exit:

        if (endptr != NULL)
        {
                /* note that last fetch statement increments p */
                *endptr = (char *)((flags & ANYDIGIT) != 0 ? p - 1 : p);
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


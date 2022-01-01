
/*
 * stdio.c - STDIO implementation library.
 *
 * Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#include <clibrary.h>
#include <ctype.h>
#include <limits.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/******************************************************************************
 *                                                                            *
 ******************************************************************************/

static char printf_buffer[PRINTF_BUFFER_SIZE];

/******************************************************************************
 * int putchar(int c)                                                         *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/putchar.html     *
 ******************************************************************************/
int
putchar(int c)
{
#if defined(LF_DOES_CR)
        if (c == '\n')
        {
                ada_print_character('\r');
        }
#endif

        ada_print_character(c);

        return c;
}

/******************************************************************************
 * int puts(const char *s)                                                    *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/puts.html        *
 ******************************************************************************/
int
puts(const char *s)
{
        char c;

        while ((c = *s++) != '\0')
        {
                (void)putchar(c);
        }

        return 1;
}

#if defined(VSPRINTF_USE_INTERNAL_ATOI)
/******************************************************************************
 * internal_atoi()                                                            *
 *                                                                            *
 * Fast conversion of a digit string to an integer value. No check performed, *
 * only positive values parsed.                                               *
 ******************************************************************************/
static __inline__ int
internal_atoi(const char **pstring)
{
        int number;

        number = 0;

        while (isdigit((int)**pstring) != 0)
        {
                number = number * 10 + *((*pstring)++) - '0';
        }

        return number;
}
#endif

#define ZEROPAD 0x1  /* pad with zero         */
#define SIGN    0x2  /* unsigned/signed long  */
#define PLUS    0x4  /* show plus             */
#define SPACE   0x8  /* space if plus         */
#define LEFT    0x10 /* left justified        */
#define LEAD0X  0x20 /* leading "0x"          */
#define UCASE   0x40 /* use "ABCDEF"/"abcdef" */

/******************************************************************************
 * number_to_literal()                                                        *
 *                                                                            *
 * Create a literal from an integer value.                                    *
 ******************************************************************************/
static char *
number_to_literal(char *string, char *string_end, unsigned long number, int base, int field_width, int precision, int type)
{
        const char *digit_table_ucase;
        const char *digit_table_lcase;
        const char *digit_table;
        char        sign;
        char        pad_character;
        char        buffer[64]; /* 64-bit max string number length in base 2 */
        int         ndigits;

        digit_table_ucase = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        digit_table_lcase = "0123456789abcdefghijklmnopqrstuvwxyz";

        /*
         * Sanity check.
         */
        if (base < 2 || base > 36)
        {
                if (string < string_end)
                {
                        *string++ = '=';
                }
                return string;
        }

        /*
         * Setup.
         */
        sign = 0;
        if ((type & UCASE) != 0)
        {
                digit_table = digit_table_ucase;
        }
        else
        {
                digit_table = digit_table_lcase;
        }
        if ((type & LEFT) != 0)
        {
                type &= ~ZEROPAD;
        }
        pad_character = (type & ZEROPAD) != 0 ? '0' : ' ';

        /*
         * Determine the sign symbol.
         */
        if ((type & SIGN) != 0)
        {
                if ((signed long)number < 0)
                {
                        sign = '-';
                        number = -number;
                        --field_width;
                }
                else if ((type & PLUS) != 0)
                {
                        sign = '+';
                        --field_width;
                }
                else if ((type & SPACE) != 0)
                {
                        sign = ' ';
                        --field_width;
                }
        }

        /*
         * Leading "0x" symbol.
         */
        if ((type & LEAD0X) != 0)
        {
                if (base == 16)
                {
                        field_width -= 2;
                }
                else if (base == 8)
                {
                        field_width -= 1;
                }
        }

        /*
         * Build the numeric string.
         */
        ndigits = 0;
        if (number == 0)
        {
                buffer[ndigits] = '0';
                ++ndigits;
        }
        else
        {
                int digit;
                while (number != 0)
                {
                        digit = (unsigned long)number % (unsigned int)base;
                        number = (unsigned long)number / (unsigned int)base;
                        buffer[ndigits] = digit_table[digit];
                        ++ndigits;
                }
        }

        if (ndigits > precision)
        {
                precision = ndigits;
        }

        field_width -= precision;

        if (!(type & (ZEROPAD | LEFT)))
        {
                while (field_width-- > 0)
                {
                        *string++ = ' ';
                }
        }

        if (sign != 0)
        {
                if (string < string_end)
                {
                        *string++ = sign;
                }
        }

        if ((type & LEAD0X) != 0)
        {
                if (base == 8)
                {
                        if (string < string_end)
                        {
                                *string++ = '0';
                        }
                }
                else if (base == 16)
                {
                        if (string < string_end)
                        {
                                *string++ = '0';
                        }
                        if (string < string_end)
                        {
                                *string++ = digit_table[33]; /* "x" or "X" */
                        }
                }
        }

        if ((type & LEFT) == 0)
        {
                while (field_width-- > 0)
                {
                        if (string < string_end)
                        {
                                *string++ = pad_character;
                        }
                }
        }

        while (ndigits < precision--)
        {
                if (string < string_end)
                {
                        *string++ = '\0';
                }
        }

        while (ndigits-- > 0)
        {
                if (string < string_end)
                {
                        *string++ = buffer[ndigits];
                }
        }

        while (field_width-- > 0)
        {
                if (string < string_end)
                {
                        *string++ = ' ';
                }
        }

        return string;
}

/******************************************************************************
 * int vsnprintf(char *s, size_t n, const char *format, va_list ap)           *
 *                                                                            *
 * "variable-arguments string print-formatted"                                *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/vfprintf.html    *
 *                                                                            *
 *----------------------------------------------------------------------------*
 * format qualifier type              sign base notes                         *
 *----------------------------------------------------------------------------*
 * d/i              S int             Y    10                                 *
 * d/i    h         S short int       Y    10                                 *
 * d/i    l         S long int        Y    10                                 *
 * d/i    ll, L     S long long int   Y    10   not supported                 *
 *----------------------------------------------------------------------------*
 * u                S/U int           N    10                                 *
 * u      h         S/U short int     N    10                                 *
 * u      l         S/U long int      N    10                                 *
 * u      ll, L     S/U long long int N    10   not supported                 *
 *----------------------------------------------------------------------------*
 * o                S/U int           N    8    no leading 0                  *
 * o      h         S/U short int     N    8    no leading 0                  *
 * o      l         S/U long int      N    8    no leading 0                  *
 * o      ll, L     S/U long long int N    8    not supported                 *
 *----------------------------------------------------------------------------*
 * x/X              S/U int           N    16   without leading 0x            *
 * x/X    h         S/U short int     N    16   without leading 0x            *
 * x/X    l         S/U long int      N    16   without leading 0x            *
 * x/X    ll, L     S/U long long int N    16   not supported                 *
 *----------------------------------------------------------------------------*
 * c                int               N         cast to unsigned char         *
 * s                char *            N                                       *
 * p                void *            N                                       *
 *----------------------------------------------------------------------------*
 * n                int *             N                                       *
 * n      l         long int *        N                                       *
 * n      Z         size_t *          N                                       *
 ******************************************************************************/
int
vsnprintf(char *s, size_t n, const char *format, va_list ap)
{
        char          *string_end;  /* string buffer end position                              */
        char          *string;      /* string scan pointer                                     */
        int            flags;       /* flags passed to number_to_literal()                     */
        int            field_width; /* width of output field                                   */
        int            precision;   /* min # of digits for integers; max # of chars for string */
        int            qualifier;   /* "h", "l", or "L" for integer fields                     */
        int            base;
        unsigned long  number;

        string_end = s + n - 1;

        if (string_end < s - 1)
        {
                string_end = (void *)-1;
                n = string_end - s + 1;
        }

        for (string = s; *format != '\0'; ++format)
        {
                if (*format != '%')
                {
                        if (string < string_end)
                        {
                                *string++ = *format;
                        }
                        continue;
                }
                /*
                 * Flag processing.
                 */
                flags = 0;
repeat:
                ++format;
                switch (*format)
                {
                        case '-': flags |= LEFT; goto repeat; break;
                        case '+': flags |= PLUS; goto repeat; break;
                        case ' ': flags |= SPACE; goto repeat; break;
                        case '#': flags |= LEAD0X; goto repeat; break;
                        case '0': flags |= ZEROPAD; goto repeat; break;
                }
                /* field width */
                field_width = -1;
                if (isdigit(*format) != 0)
                {
#if defined(VSPRINTF_USE_INTERNAL_ATOI)
                        field_width = internal_atoi(&format);
#else
                        field_width = strtol(format, (char **)&format, 10);
#endif
                }
                else if (*format == '*')
                {
                        ++format;
                        /* next argument */
                        field_width = va_arg(ap, int);
                        if (field_width < 0)
                        {
                                field_width = -field_width;
                                flags |= LEFT;
                        }
                }
                /* precision */
                precision = -1;
                if (*format == '.')
                {
                        ++format;
                        if (isdigit(*format) != 0)
                        {
#if defined(VSPRINTF_USE_INTERNAL_ATOI)
                                precision = internal_atoi(&format);
#else
                                precision = strtol(format, (char **)&format, 10);
#endif
                        }
                        else if (*format == '*')
                        {
                                ++format;
                                /* next argument */
                                precision = va_arg(ap, int);
                        }
                        if (precision < 0)
                        {
                                precision = 0;
                        }
                }
                /* conversion qualifier */
                qualifier = -1;
                if (*format == 'h' || *format == 'l')
                {
                        qualifier = *format;
                        ++format;
                }
                base = 10; /* set default base for numeric formats */
                switch (*format)
                {
                        case 'c':
                                {
                                        char c;
                                        c = (unsigned char)va_arg(ap, int);
                                        if ((flags & LEFT) == 0)
                                        {
                                                while (--field_width > 0)
                                                {
                                                        if (string < string_end)
                                                        {
                                                                *string++ = ' ';
                                                        }
                                                }
                                        }
                                        if (string < string_end)
                                        {
                                                *string++ = c;
                                        }
                                        while (--field_width > 0)
                                        {
                                                if (string < string_end)
                                                {
                                                        *string++ = ' ';
                                                }
                                        }
                                }
                                continue;
                                break;
                        case 'n':
                                if (qualifier == 'l')
                                {
                                        long *plong_argument;
                                        plong_argument = va_arg(ap, long *);
                                        *plong_argument = string - s;
                                }
                                else if (qualifier == 'Z')
                                {
                                        size_t *psizet_argument;
                                        psizet_argument = va_arg(ap, size_t *);
                                        *psizet_argument = string - s;
                                }
                                else
                                {
                                        int *pint_argument;
                                        pint_argument = va_arg(ap, int *);
                                        *pint_argument = string - s;
                                }
                                continue;
                                break;
                        case 'p':
                                if (field_width == -1)
                                {
                                        field_width = 2 * sizeof(void *);
                                        flags |= ZEROPAD;
                                }
                                string = number_to_literal(
                                                           string,
                                                           string_end,
                                                           (unsigned long)va_arg(ap, void *),
                                                           16,
                                                           field_width,
                                                           precision,
                                                           flags
                                                          );
                                continue;
                                break;
                        case 's':
                                {
                                        const char *string_argument;
                                        int length;
                                        int count;
                                        string_argument = va_arg(ap, char *);
                                        if (string_argument == NULL)
                                        {
                                                string_argument = "<NULL>";
                                        }
                                        length = strnlen(string_argument, precision);
                                        if ((flags & LEFT) == 0)
                                        {
                                                while (length < field_width--)
                                                {
                                                        if (string < string_end)
                                                        {
                                                                *string++ = ' ';
                                                        }
                                                }
                                        }
                                        for (count = 0; count < length; ++count)
                                        {
                                                if (string < string_end)
                                                {
                                                        *string++ = *string_argument++;
                                                }
                                        }
                                        while (length < field_width--)
                                        {
                                                if (string < string_end)
                                                {
                                                        *string++ = ' ';
                                                }
                                        }
                                }
                                continue;
                                break;
                        case '%':
                                if (string < string_end)
                                {
                                        *string++ = '%';
                                }
                                continue;
                                break;
                        case 'd':
                        case 'i':
                                flags |= SIGN;
                                break;
                        case 'u':
                                break;
                        case 'o':
                                base = 8;
                                break;
                        case 'X':
                                flags |= UCASE; /* fall through */ // no break
                        case 'x':
                                base = 16;
                                break;
                        default:
                                if (string < string_end)
                                {
                                        *string++ = '%';
                                }
                                if (*format != '\0')
                                {
                                        if (string < string_end)
                                        {
                                                *string++ = *format;
                                        }
                                }
                                else
                                {
                                        --format;
                                }
                                continue;
                                break;
                }
                if (qualifier == 'l')
                {
                        number = va_arg(ap, unsigned long);
                }
                else if (qualifier == 'Z')
                {
                        number = va_arg(ap, size_t);
                }
                else if (qualifier == 'h')
                {
                        number = (unsigned short)va_arg(ap, int);
                        if ((flags & SIGN) != 0)
                        {
                                number = (signed short)number;
                        }
                }
                else
                {
                        number = va_arg(ap, unsigned int);
                        if ((flags & SIGN) != 0)
                        {
                                number = (signed int)number;
                        }
                }
                string = number_to_literal(
                                           string,
                                           string_end,
                                           number,
                                           base,
                                           field_width,
                                           precision,
                                           flags
                                          );
        }

        if (string <= string_end)
        {
                *string = '\0';
        }
        else if (n > 0)
        {
                *string_end = '\0';
        }

        return string - s;
}

/******************************************************************************
 * int sprintf(char *s, const char *format, ...)                              *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/fprintf.html     *
 ******************************************************************************/
int
sprintf(char *s, const char *format, ...)
{
        va_list ap;
        int     ncharacters;

        va_start(ap, format);
        ncharacters = vsnprintf(s, INT_MAX, format, ap);
        va_end(ap);

        return ncharacters;
}

/******************************************************************************
 * int printf(const char *format, ...)                                        *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/fprintf.html     *
 ******************************************************************************/
int
printf(const char *format, ...)
{
        va_list ap;
        int     ncharacters;

        va_start(ap, format);
        ncharacters = vsnprintf(printf_buffer, PRINTF_BUFFER_SIZE, format, ap);
        va_end(ap);

        if (ncharacters >= 0)
        {
                (void)puts(printf_buffer);
        }

        return ncharacters;
}


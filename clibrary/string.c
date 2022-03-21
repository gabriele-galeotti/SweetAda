
/*
 * string.c - STRING implementation library.
 *
 * Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#include <clibrary.h>

#include <ctype.h>
#include <stdbool.h>
#include <string.h>

/******************************************************************************
 * void *memchr(const void *s, int c, size_t n)                               *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/memchr.html      *
 ******************************************************************************/
void *
memchr(const void *s, int c, size_t n)
{
        const unsigned char *p;

        p = (unsigned char *)s;

        while (n-- != 0)
        {
                if (*p == (unsigned char)c)
                {
                        return (void *)p;
                }
                ++p;
        }

        return NULL;
}

#if defined(ENABLE_MEMORY_FUNCTIONS)

/******************************************************************************
 * int memcmp(const void *s1, const void *s2, size_t n)                       *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/memcmp.html      *
 ******************************************************************************/
int
memcmp(const void *s1, const void *s2, size_t n)
{
        const unsigned char *p1;
        const unsigned char *p2;
        int                  result;

        p1 = (unsigned char *)s1;
        p2 = (unsigned char *)s2;
        result = 0;

        while (n-- != 0)
        {
                if ((result = *p1++ - *p2++) != 0)
                {
                        break;
                }
        }

        return result;
}

/******************************************************************************
 * void *memcpy(void *s1, const void *s2, size_t n)                           *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/memcpy.html      *
 ******************************************************************************/
void *
memcpy(void *s1, const void *s2, size_t n)
{
        const char *p1;
        char       *p2;

        p1 = (const char *)s2;
        p2 = (char *)s1;

        while (n-- != 0)
        {
                *p2++ = *p1++;
        }

        return s1;
}

/******************************************************************************
 * void *memmove(void *s1, const void *s2, size_t n)                          *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/memmove.html     *
 ******************************************************************************/
void *
memmove(void *s1, const void *s2, size_t n)
{
        const char *p1;
        char       *p2;

        if (n == 0)
        {
                return s1;
        }

        if (s1 <= s2)
        {
                /*
                 * Ascending addresses.
                 */
                p2 = (char *)s1;
                p1 = (const char *)s2;
                while (n-- != 0)
                {
                        *p2++ = *p1++;
                }
        }
        else
        {
                /*
                 * Descending addresses.
                 */
                p2 = (char *)s1 + n;
                p1 = (const char *)s2 + n;
                while (n-- != 0)
                {
                        *--p2 = *--p1;
                }
        }

        return s1;
}

/******************************************************************************
 * void *memset(void *s, int c, size_t n)                                     *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/memset.html      *
 ******************************************************************************/
void *
memset(void *s, int c, size_t n)
{
        unsigned char *p;

        p = (unsigned char *)s;

        while (n-- != 0)
        {
                *p++ = (unsigned char)c;
        }

        return s;
}

#endif

/******************************************************************************
 * int strcasecmp(const char *s1, const char *s2)                             *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/strcasecmp.html  *
 ******************************************************************************/
int
strcasecmp(const char *s1, const char *s2)
{
        int c1;
        int c2;

        if (s1 == s2)
        {
                return 0;
        }

        do
        {
                c1 = tolower(*s1++);
                c2 = tolower(*s2++);
                if (c1 == '\0')
                {
                        break;
                }
        } while (c1 == c2);

        return c1 - c2;
}

/******************************************************************************
 * char *strcat(char *s1, const char *s2)                                     *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/strcat.html      *
 ******************************************************************************/
char *
strcat(char *s1, const char *s2)
{
        char *p;

        p = s1;

        while (*s1 != '\0')
        {
                ++s1;
        }

        while ((*s1++ = *s2++) != '\0')
        {
                /* __NOP__ */
        }

        return p;
}

/******************************************************************************
 * char *strchr(const char *s, int c)                                         *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/strchr.html      *
 ******************************************************************************/
char *
strchr(const char *s, int c)
{
        while (*s != (char)c)
        {
                if (*s == '\0')
                {
                        return NULL;
                }
                s++;
        }

        return (char *)s;
}

/******************************************************************************
 * int strcmp(const char *s1, const char *s2)                                 *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/strcmp.html      *
 ******************************************************************************/
int
strcmp(const char *s1, const char *s2)
{
        const unsigned char *p1;
        const unsigned char *p2;
        int                  result;

        p1 = (const unsigned char *)s1;
        p2 = (const unsigned char *)s2;

        while (true)
        {
                if ((result = *p1 - *p2++) != 0 || *p1++ == 0)
                {
                        break;
                }
        }

        return result;
}

/******************************************************************************
 * char *strcpy(char *s1, const char *s2)                                     *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/strcpy.html      *
 ******************************************************************************/
char *
strcpy(char *s1, const char *s2)
{
        char *p;

        p = s1;

        while ((*s1++ = *s2++) != '\0')
        {
                /* __NOP__ */
        }

        return p;
}

/******************************************************************************
 * size_t strcspn(const char *s1, const char *s2)                             *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/strcspn.html     *
 ******************************************************************************/
size_t
strcspn(const char *s1, const char *s2)
{
        size_t count;

        count = 0;

        while (*s1 != '\0')
        {
                if (strchr(s2, *s1++) == NULL)
                {
                        ++count;
                }
                else
                {
                        return count;
                }
        }

        return count;
}

/******************************************************************************
 * size_t strlen(const char *s)                                               *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/strlen.html      *
 ******************************************************************************/
size_t
strlen(const char *s)
{
        const char *p;

        for (p = s; *p != '\0'; ++p)
        {
                /* __NOP__ */
        }

        return (size_t)(p - s);
}

/******************************************************************************
 * int strncasecmp(const char *s1, const char *s2, size_t n)                  *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/strcasecmp.html  *
 ******************************************************************************/
int
strncasecmp(const char *s1, const char *s2, size_t n)
{
        int c1;
        int c2;

        if (s1 == s2 || n == 0)
        {
                return 0;
        }

        do
        {
                c1 = tolower(*s1++);
                c2 = tolower(*s2++);
                if (c1 == '\0' || c1 != c2)
                {
                        break;
                }
        } while (--n != 0);

        return c1 - c2;
}

/******************************************************************************
 * char *strncat(char *s1, const char *s2, size_t n)                          *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/strncat.html     *
 ******************************************************************************/
char *
strncat(char *s1, const char *s2, size_t n)
{
        char *p;

        p = s1;

        if (n != 0)
        {
                while (*s1 != '\0')
                {
                        ++s1;
                }
                while ((*s1++ = *s2++) != 0)
                {
                        if (--n == 0)
                        {
                                *s1 = '\0';
                                break;
                        }
                }
        }

        return p;
}

/******************************************************************************
 * int strncmp(const char *s1, const char *s2, size_t n)                      *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/strncmp.html     *
 ******************************************************************************/
int
strncmp(const char *s1, const char *s2, size_t n)
{
        const unsigned char *p1;
        const unsigned char *p2;
        int                  result;

        p1 = (const unsigned char *)s1;
        p2 = (const unsigned char *)s2;
        result = 0;

        while (n-- != 0)
        {
                if ((result = *p1 - *p2++) != 0 || *p1++ == 0)
                {
                        break;
                }
        }

        return result;
}

/******************************************************************************
 * char *strncpy(char *s1, const char *s2, size_t n)                          *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/strncpy.html     *
 ******************************************************************************/
char *
strncpy(char *s1, const char *s2, size_t n)
{
        char *p;

        p = s1;

        while (n-- != 0 && (*s1++ = *s2++) != '\0')
        {
                /* __NOP__ */
        }

        return p;
}

/******************************************************************************
 * size_t strnlen(const char *s, size_t maxlen)                               *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/strlen.html      *
 ******************************************************************************/
size_t
strnlen(const char *s, size_t maxlen)
{
        const char *p;

        for (p = s; maxlen-- != 0 && *p != '\0'; ++p)
        {
                /* __NOP__ */
        }

        return (size_t)(p - s);
}

/******************************************************************************
 * char *strpbrk(const char *s1, const char *s2)                              *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/strpbrk.html     *
 ******************************************************************************/
char *
strpbrk(const char *s1, const char *s2)
{
        const char *p1;
        const char *p2;

        for (p1 = s1; *p1 != '\0'; ++p1)
        {
                for (p2 = s2; *p2 != '\0'; ++p2)
                {
                        if (*p1 == *p2)
                        {
                                return (char *)p1;
                        }
                }
        }

        return NULL;
}

/******************************************************************************
 * char *strrchr(const char *s, int c)                                        *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/strrchr.html     *
 ******************************************************************************/
char *
strrchr(const char *s, int c)
{
        char *p;

        p = (char *)s + strlen(s);

        do
        {
                if (*p == (char)c)
                {
                        return p;
                }
        } while (--p >= s);

        return NULL;
}

/******************************************************************************
 * size_t strspn(const char *s1, const char *s2)                              *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/strspn.html      *
 ******************************************************************************/
size_t
strspn(const char *s1, const char *s2)
{
        const char *p1;
        const char *p2;
        size_t      count;

        count = 0;

        for (p1 = s1; *p1 != '\0'; ++p1)
        {
                for (p2 = s2; *p2 != '\0'; ++p2)
                {
                        if (*p1 == *p2)
                        {
                                break;
                        }
                }
                if (*p2 == '\0')
                {
                        return count;
                }
                ++count;
        }

        return count;
}

/******************************************************************************
 * char *strstr(const char *s1, const char *s2)                               *
 *                                                                            *
 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/strstr.html      *
 ******************************************************************************/
char *
strstr(const char *s1, const char *s2)
{
        size_t n1;
        size_t n2;

        n2 = strlen(s2);

        if (n2 == 0)
        {
                return (char *)s1;
        }

        n1 = strlen(s1);

        while (n1 >= n2)
        {
                --n1;
                if (memcmp(s1, s2, n2) == 0)
                {
                        return (char *)s1;
                }
                ++s1;
        }

        return NULL;
}


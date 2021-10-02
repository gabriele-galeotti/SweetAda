
/*
 * library.h - C library functions header.
 *
 * Copyright (C) 2020, 2021 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#ifndef _LIBRARY_H
#define _LIBRARY_H 1

/******************************************************************************
 * Environment selection macros.                                              *
 ******************************************************************************/

#if defined(__START_IF_SELECTION__)
# error __START_IF_SELECTION__ defined
#else
# define __START_IF_SELECTION__ 0
#endif

/******************************************************************************
 * System C headers.                                                          *
 ******************************************************************************/

#if __START_IF_SELECTION__
#elif defined(__APPLE__) || defined(__linux__)
/* feature test macros need to be defined before the first use of any */
/* standard library header */
# define _XOPEN_SOURCE 700
# define _GNU_SOURCE
#endif

/* standard includes */
#include <inttypes.h>
#include <stdarg.h>     /* va_list */
#include <stdbool.h>
#include <stddef.h>     /* size_t */
#include <sys/types.h>  /* pid_t */

/******************************************************************************
 * Useful constants.                                                          *
 ******************************************************************************/

/*
 * ASCII codes.
 */
#define ASCII_NUL 0x00 /* ^@ */
#define ASCII_SOH 0x01 /* ^A */
#define ASCII_STX 0x02 /* ^B */
#define ASCII_ETX 0x03 /* ^C */
#define ASCII_EOT 0x04 /* ^D */
#define ASCII_ENQ 0x05 /* ^E */
#define ASCII_ACK 0x06 /* ^F */
#define ASCII_BEL 0x07 /* ^G */
#define ASCII_BS  0x08 /* ^H */
#define ASCII_HT  0x09 /* ^I */
#define ASCII_LF  0x0A /* ^J */
#define ASCII_VT  0x0B /* ^K */
#define ASCII_FF  0x0C /* ^L */
#define ASCII_CR  0x0D /* ^M */
#define ASCII_SO  0x0E /* ^N */
#define ASCII_SI  0x0F /* ^O */
#define ASCII_DLE 0x10 /* ^P */
#define ASCII_DC1 0x11 /* ^Q */
#define ASCII_DC2 0x12 /* ^R */
#define ASCII_DC3 0x13 /* ^S */
#define ASCII_DC4 0x14 /* ^T */
#define ASCII_NAK 0x15 /* ^U */
#define ASCII_SYN 0x16 /* ^V */
#define ASCII_ETB 0x17 /* ^W */
#define ASCII_CAN 0x18 /* ^X */
#define ASCII_EM  0x19 /* ^Y */
#define ASCII_SUB 0x1A /* ^Z */
#define ASCII_ESC 0x1B /* ^[ */
#define ASCII_FS  0x1C /* ^\ */
#define ASCII_GS  0x1D /* ^] */
#define ASCII_RS  0x1E /* ^^ */
#define ASCII_US  0x1F /* ^_ */
#define ASCII_DEL 0x7F

/* aliases */
#define ASCII_XON  ASCII_DC1
#define ASCII_XOFF ASCII_DC3

/* ESC [ */
#define CSI 0x9B

/* PATH separator */
#define PATH_SEPARATOR_UNIX    '/'
#define PATH_SEPARATOR_WINDOWS '\\'

/******************************************************************************
 * Utility macros.                                                            *
 ******************************************************************************/

#if __START_IF_SELECTION__
#elif defined(_WIN32)
//# define OEMRESOURCE
# include <windows.h>
# if defined(_WIN64)
#  define SIZET_FORMAT PRIu64
#  define PID_FORMAT "lld"
# else
#  define SIZET_FORMAT PRIu32
#  define PID_FORMAT "d"
# endif
# define EXITSTATUS_FORMAT "lu"
# define PATH_SEPARATOR PATH_SEPARATOR_WINDOWS
#elif defined(__APPLE__) || defined(__linux__)
# define SIZET_FORMAT "zu"
# define EXITSTATUS_FORMAT "d"
# define PID_FORMAT "d"
# define PATH_SEPARATOR PATH_SEPARATOR_UNIX
#endif

#define NORETURN __attribute__ ((noreturn))
#define PACKED   __attribute__ ((packed))

#define PID_INVALID ((pid_t)-1)

#define _tostring(s) #s
#define TOSTRING(s) _tostring(s)

#define _strconcat(a, b) a##b
#define STRCONCAT(a, b) _strconcat(a, b)

#define STRING_MEMSIZE(string)      (strlen(string) + 1)
#define STRING_LENGTH(string)       strlen(string)
#define STRING_EQ(string1, string2) (strcmp(string1, string2) == 0)
#define STRING_NE(string1, string2) (strcmp(string1, string2) != 0)

#define ARRAY_MEMSIZE(array) sizeof(array)
#define ARRAY_LENGTH(array)  (sizeof(array) / sizeof((array)[0]))

#if !defined(MAX)
# define MAX(a, b) ((a) > (b) ? (a) : (b))
#endif
#if !defined(MIN)
# define MIN(a, b) ((a) < (b) ? (a) : (b))
#endif

#define SETON(value, flags)  do { (value) |= (flags); } while (false)
#define SETOFF(value, flags) do { (value) &= ~(flags); } while (false)
#define INVERT(value, flags) do { (value) ^= (flags); } while (false)

#define ROUNDDN(value, align) ((value) & ~((align) - 1))
#define ROUNDUP(value, align) (((value) + (align) - 1) & ~((align) - 1))

#define INRANGE(n, low, high)  ((n) >= (low) && (n) <= (high))
#define OUTRANGE(n, low, high) ((n) < (low) || (n) > (high))
#define MIDPOINT(low, high)    (((low) + (high)) / 2)

#define INSIDE(p, x, r) (abs((p) - (x)) < (r))
#define OUTSIDE(p, x, r) (abs((p) - (x)) >= (r))

/******************************************************************************
 * swapXX macros.                                                             *
 ******************************************************************************/

static __inline__ uint16_t
swap16(uint16_t x)
{
        return ((x << 8) & 0xFF00) | ((x >> 8) & 0xFF);
}

static __inline__ uint32_t
swap32(uint32_t x)
{
        return ((x << 24) & 0xFF000000UL) |
               ((x <<  8) & 0x00FF0000UL) |
               ((x >>  8) & 0x0000FF00UL) |
               ((x >> 24) & 0x000000FFUL);
}

static __inline__ uint64_t
swap64(uint64_t x)
{
        return ((((uint64_t)(swap32((uint32_t)(x)))) << 32) | (swap32(((uint64_t)(x)) >> 32)));
}

static __inline__ uint64_t
swapXX(uint64_t x, size_t size)
{
        switch (size)
        {
                case 2:  return swap16(x & 0x000000000000FFFFUL); break;
                case 4:  return swap32(x & 0x00000000FFFFFFFFUL); break;
                case 8:  return swap64(x); break;
                default: break;
        }

        return x;
}

/******************************************************************************
 * Endianness macros.                                                         *
 ******************************************************************************/

#define ENDIANNESS_BIG    0
#define ENDIANNESS_LITTLE 1

static __inline__ int
endianness_detect(void)
{
        volatile union {
                uint8_t  b[4];
                uint32_t w32;
                } data;

        data.w32 = 0x00000001;

        return (int)data.b[0];
}

/******************************************************************************
 * bits&bytes macros.                                                         *
 ******************************************************************************/

/* set bits b of v if condition is true, else reset */
#define setbits(v, b, condition)   \
        do {                       \
                if (condition)     \
                {                  \
                        v |= (b);  \
                }                  \
                else               \
                {                  \
                        v &= ~(b); \
                }                  \
        } while (false)

/* clear bits b of v if condition is true */
#define clearbits(v, b, condition) \
        do {                       \
                if (condition)     \
                {                  \
                        v &= ~(b); \
                }                  \
        } while (false)

/* reverse an 8-bit byte */
static __inline__ uint8_t
byte_reverse(uint8_t value)
{
        int     i;
        uint8_t result;

        result = 0;

        for (i = 0; i < 8; ++i)
        {
                int j;
                j = (value & (1 << i)) ? 1 : 0;
                result = result | (j << (7 - i));
        }

        return result;
}

/******************************************************************************
 * Various text facilities.                                                   *
 ******************************************************************************/

static __inline__ uint8_t
hexdigit2u8(int c, bool msd)
{
        uint8_t value;

        if      (c >= '0' && c <= '9') { value = c - '0'; }
        else if (c >= 'A' && c <= 'F') { value = c - 'A' + 10; }
        else if (c >= 'a' && c <= 'f') { value = c - 'a' + 10; }
        else                           { value = 0; }

        if (msd) { value <<= 4; }

        return value;
}

/******************************************************************************
 * Library structures and functions.                                          *
 ******************************************************************************/

#ifdef __cplusplus
extern "C" {
#endif

/******************************************************************************
 * Generic.                                                                   *
 ******************************************************************************/

extern const char *ascii_name(int);
extern char        ebcdic_to_ascii(uint8_t);

/******************************************************************************
 * Memory allocation.                                                         *
 ******************************************************************************/

extern void *lib_malloc(size_t);
extern void *lib_realloc(void *, size_t);
extern void  lib_free(void *);
extern char *lib_strdup(const char *);

/******************************************************************************
 * Environment.                                                               *
 ******************************************************************************/

extern const char *env_get(const char *);
extern int         env_put(const char *, const char *);

/******************************************************************************
 * Timing.                                                                    *
 ******************************************************************************/

extern int time_usleep(size_t);
extern int time_msleep(size_t);

/******************************************************************************
 * Filesystem.                                                                *
 ******************************************************************************/

extern bool        file_exists(const char *);
extern size_t      file_length(const char *);
extern const char *file_basename_simple(const char *);
extern const char *file_extensionname(const char *);
extern char       *file_dirname_simple(char *);
extern char       *file_add_path_separator(char *);
extern int         symlink_create(const char *, const char *);
extern int         symlink_delete(const char *);

/******************************************************************************
 * "argv-like" arrays.                                                        *
 ******************************************************************************/

extern void argv_append(const char **, const char *);

/******************************************************************************
 * Logging.                                                                   *
 ******************************************************************************/

extern void log_print(int);
extern int  log_vsnprintf(const char *, va_list);
extern int  log_printf(int, const char *, ...);
extern void log_argv_print(int, char **, const char *);
extern void log_mode_set(int);
extern int  log_mode_get(void);
extern void log_close(void);
extern int  log_init(const char *, const char *, const char *);

#define LOG_NONE   0
#define LOG_STDOUT (1 << 0)
#define LOG_STDERR (1 << 1)
#define LOG_FILE   (1 << 2)

/******************************************************************************
 * Executing.                                                                 *
 ******************************************************************************/

typedef struct _execute *execute_t; /* "opaque" pointer */

extern execute_t    execute_create(void);
extern void         execute_filename_set(execute_t, const char *);
extern const char  *execute_filename_get(execute_t);
extern void         execute_directory_set(execute_t, const char *);
extern const char  *execute_directory_get(execute_t);
extern void         execute_argv_add(execute_t, const char *);
extern const char **execute_argv_get(execute_t);
extern void         execute_envp_add(execute_t, const char *);
extern const char **execute_envp_get(execute_t);
extern void         execute_flags_set(execute_t, int);
extern int          execute_flags_get(execute_t);
extern void         execute_log_set(execute_t, int, const char *);
extern int          execute_exec(execute_t);
extern pid_t        execute_child_pid(execute_t);
#if __START_IF_SELECTION__
#elif defined(_WIN32)
extern DWORD        execute_child_exit_status(execute_t);
#elif defined(__APPLE__) || defined(__linux__)
extern int          execute_child_exit_status(execute_t);
#endif
extern void         execute_destroy(execute_t);

#define EXEC_FORK           (1 << 0)
/* do not log exit errors from the executable we have launched, they are    */
/* normal execution errors, and we do not want to add useless notifications */
#define EXEC_NO_EXIT_ERRORS (1 << 1)
#define EXEC_PRINT_CPID     (1 << 2)
#define EXEC_PRINT_ARGV     (1 << 3)

extern int  execute_system(int, char **);
extern bool process_terminate(pid_t);

/******************************************************************************
 * Library handling.                                                          *
 ******************************************************************************/

#if !defined(NO_DLL_HANDLING)
extern void *dll_load(const char *);
#endif

#ifdef __cplusplus
}
#endif

#endif /* _LIBRARY_H */


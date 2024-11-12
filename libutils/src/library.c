
/*
 * library.c - C library functions.
 *
 * Copyright (C) 2020-2024 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

/******************************************************************************
 * Standard C headers.                                                        *
 ******************************************************************************/

#include <assert.h>
#include <ctype.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

/******************************************************************************
 * System headers.                                                            *
 ******************************************************************************/

#include <unistd.h>
#include <sys/stat.h>

/******************************************************************************
 * Application headers.                                                       *
 ******************************************************************************/

#include "library.h"

/******************************************************************************
 * Private definitions.                                                       *
 ******************************************************************************/

#if __START_IF_SELECTION__
#elif defined(__APPLE__) || defined(__linux__)
# include <dlfcn.h>    /* dlopen() */
# include <spawn.h>
# include <sys/wait.h> /* WEXITSTATUS() */
#endif
#if __START_IF_SELECTION__
#elif defined(__APPLE__)
# include <signal.h>
#endif

/******************************************************************************
 *                                                                            *
 *                                                                            *
 * Generic.                                                                   *
 *                                                                            *
 *                                                                            *
 ******************************************************************************/

/******************************************************************************
 * ascii_name()                                                               *
 *                                                                            *
 ******************************************************************************/
const char *
ascii_name(int c)
{
        switch (c)
        {
                case ASCII_NUL: return "NUL"; break;
                case ASCII_SOH: return "SOH"; break;
                case ASCII_STX: return "STX"; break;
                case ASCII_ETX: return "ETX"; break;
                case ASCII_EOT: return "EOT"; break;
                case ASCII_ENQ: return "ENQ"; break;
                case ASCII_ACK: return "ACK"; break;
                case ASCII_BEL: return "BEL"; break;
                case ASCII_BS:  return "BS"; break;
                case ASCII_HT:  return "HT"; break;
                case ASCII_LF:  return "LF"; break;
                case ASCII_VT:  return "VT"; break;
                case ASCII_FF:  return "FF"; break;
                case ASCII_CR:  return "CR"; break;
                case ASCII_SO:  return "SO"; break;
                case ASCII_SI:  return "SI"; break;
                case ASCII_DLE: return "DLE"; break;
                case ASCII_DC1: return "DC1"; break;
                case ASCII_DC2: return "DC2"; break;
                case ASCII_DC3: return "DC3"; break;
                case ASCII_DC4: return "DC4"; break;
                case ASCII_NAK: return "NAK"; break;
                case ASCII_SYN: return "SYN"; break;
                case ASCII_ETB: return "ETB"; break;
                case ASCII_CAN: return "CAN"; break;
                case ASCII_EM:  return "EM"; break;
                case ASCII_SUB: return "SUB"; break;
                case ASCII_ESC: return "ESC"; break;
                case ASCII_FS:  return "FS"; break;
                case ASCII_GS:  return "GS"; break;
                case ASCII_RS:  return "RS"; break;
                case ASCII_US:  return "US"; break;
                case ASCII_DEL: return "DEL"; break;
                default:        return "."; break;
        }

        return NULL;
}

static unsigned char EBCDIC2ASCII[256] = {
/* 0x00  NUL   SOH   STX   ETX  *SEL    HT  *RNL   DEL */
        0x00, 0x01, 0x02, 0x03, 0x07, 0x09, 0x07, 0x7F,
/* 0x08  -GE  -SPS  -RPT    VT    FF    CR    SO    SI */
        0x07, 0x07, 0x07, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
/* 0x10  DLE   DC1   DC2   DC3  -RES   -NL    BS  -POC */
        0x10, 0x11, 0x12, 0x13, 0x07, 0x0A, 0x08, 0x07,
/* 0x18  CAN    EM  -UBS  -CU1  -IFS  -IGS  -IRS  -ITB */
        0x18, 0x19, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07,
/* 0x20  -DS  -SOS    FS  -WUS  -BYP    LF   ETB   ESC */
        0x07, 0x07, 0x1C, 0x07, 0x07, 0x0A, 0x17, 0x1B,
/* 0x28  -SA  -SFE   -SM  -CSP  -MFA   ENQ   ACK   BEL */
        0x07, 0x07, 0x07, 0x07, 0x07, 0x05, 0x06, 0x07,
/* 0x30 ----  ----   SYN   -IR   -PP  -TRN  -NBS   EOT */
        0x07, 0x07, 0x16, 0x07, 0x07, 0x07, 0x07, 0x04,
/* 0x38 -SBS   -IT  -RFF  -CU3   DC4   NAK  ----   SUB */
        0x07, 0x07, 0x07, 0x07, 0x14, 0x15, 0x07, 0x1A,
/* 0x40   SP   RSP           ?              ----       */
        0x20, 0xFF, 0x83, 0x84, 0x85, 0xA0, 0x07, 0x86,
/* 0x48                      .     <     (     +     | */
        0x87, 0xA4, 0x9B, 0x2E, 0x3C, 0x28, 0x2B, 0x7C,
/* 0x50    &                                      ---- */
        0x26, 0x82, 0x88, 0x89, 0x8A, 0xA1, 0x8C, 0x07,
/* 0x58          ?     !     $     *     )     ;       */
        0x8D, 0xE1, 0x21, 0x24, 0x2A, 0x29, 0x3B, 0xAA,
/* 0x60    -     /  ----     ?  ----  ----  ----       */
        0x2D, 0x2F, 0x07, 0x8E, 0x07, 0x07, 0x07, 0x8F,
/* 0x68             ----     ,     %     _     >     ? */
        0x80, 0xA5, 0x07, 0x2C, 0x25, 0x5F, 0x3E, 0x3F,
/* 0x70  ---        ----  ----  ----  ----  ----  ---- */
        0x07, 0x90, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07,
/* 0x78    *     `     :     #     @     '     =     " */
        0x70, 0x60, 0x3A, 0x23, 0x40, 0x27, 0x3D, 0x22,
/* 0x80    *     a     b     c     d     e     f     g */
        0x07, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67,
/* 0x88    h     i              ----  ----  ----       */
        0x68, 0x69, 0xAE, 0xAF, 0x07, 0x07, 0x07, 0xF1,
/* 0x90    ?     j     k     l     m     n     o     p */
        0xF8, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F, 0x70,
/* 0x98    q     r                    ----        ---- */
        0x71, 0x72, 0xA6, 0xA7, 0x91, 0x07, 0x92, 0x07,
/* 0xA0          ~     s     t     u     v     w     x */
        0xE6, 0x7E, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78,
/* 0xA8    y     z              ----  ----  ----  ---- */
        0x79, 0x7A, 0xAD, 0xAB, 0x07, 0x07, 0x07, 0x07,
/* 0xB0    ^                    ----     ?  ----       */
        0x5E, 0x9C, 0x9D, 0xFA, 0x07, 0x07, 0x07, 0xAC,
/* 0xB8       ----     [     ]  ----  ----  ----  ---- */
        0xAB, 0x07, 0x5B, 0x5D, 0x07, 0x07, 0x07, 0x07,
/* 0xC0    {     A     B     C     D     E     F     G */
        0x7B, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47,
/* 0xC8    H     I  ----           ?              ---- */
        0x48, 0x49, 0x07, 0x93, 0x94, 0x95, 0xA2, 0x07,
/* 0xD0    }     J     K     L     M     N     O     P */
        0x7D, 0x4A, 0x4B, 0x4C, 0x4D, 0x4E, 0x4F, 0x50,
/* 0xD8    Q     R  ----           ?                   */
        0x51, 0x52, 0x07, 0x96, 0x81, 0x97, 0xA3, 0x98,
/* 0xE0    \           S     T     U     V     W     X */
        0x5C, 0xF6, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58,
/* 0xE8    Y     Z        ----     ?  ----  ----  ---- */
        0x59, 0x5A, 0xFD, 0x07, 0x99, 0x07, 0x07, 0x07,
/* 0xF0    0     1     2     3     4     5     6     7 */
        0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,
/* 0xF8    8     9  ----  ----     ?  ----  ----  ---- */
        0x38, 0x39, 0x07, 0x07, 0x9A, 0x07, 0x07, 0x07
        };

/******************************************************************************
 * ebcdic_to_ascii()                                                          *
 *                                                                            *
 ******************************************************************************/
char
ebcdic_to_ascii(uint8_t c)
{
        return EBCDIC2ASCII[c];
}

/******************************************************************************
 *                                                                            *
 *                                                                            *
 * Memory allocation.                                                         *
 *                                                                            *
 *                                                                            *
 ******************************************************************************/

/******************************************************************************
 * lib_malloc()                                                               *
 *                                                                            *
 ******************************************************************************/
void *
lib_malloc(size_t size)
{
        return malloc(size);
}

/******************************************************************************
 * lib_realloc()                                                              *
 *                                                                            *
 ******************************************************************************/
void *
lib_realloc(void *ptr, size_t size)
{
        return realloc(ptr, size);
}

/******************************************************************************
 * lib_free()                                                                 *
 *                                                                            *
 ******************************************************************************/
void *
lib_free(void *ptr)
{
        if (ptr != NULL)
        {
                free(ptr);
        }

        return NULL;
}

/******************************************************************************
 * lib_strdup()                                                               *
 *                                                                            *
 ******************************************************************************/
char *
lib_strdup(const char *string)
{
        if (string != NULL)
        {
                return strdup(string);
        }

        return NULL;
}

/******************************************************************************
 *                                                                            *
 *                                                                            *
 * Environment.                                                               *
 *                                                                            *
 *                                                                            *
 ******************************************************************************/

/*
 * Rules valid in every OS:
 * - env_get():
 *   returns a heap-allocated string; once the caller has finished, it can
 *   free the string by means of lib_free()
 * - env_put():
 *   Windows: does not need a static string as input
 *   Linux: does need a static string as input
 *
 * NOTE: Windows refuses to put in the environment space an empty variable
 * (it should have length > 0)
 */

/******************************************************************************
 * env_get()                                                                  *
 *                                                                            *
 ******************************************************************************/
const char *
env_get(const char *envvarname)
{
        if (envvarname != NULL)
        {
#if __START_IF_SELECTION__
#elif defined(_WIN32)
                char string[1024];
                //string[0] = '\0'; defensive programming
                DWORD string_length;
                if ((string_length = GetEnvironmentVariable((LPCSTR)envvarname, (LPSTR)string, 1024)) > 0)
                {
                        const char *result;
                        /* allocate a buffer which will receives variable */
                        result = lib_malloc(STRING_MEMSIZE(string));
                        if (result != NULL)
                        {
                                strcpy((char *)result, string);
                                return result;
                        }
                        else
                        {
                                log_printf(LOG_STDERR, "env_get(): lib_malloc().");
                        }
                }
                else
                {
                        if (string_length == 0 || GetLastError() == ERROR_ENVVAR_NOT_FOUND)
                        {
                                /* variable not found */
                        }
                        else
                        {
                                //log_printf(LOG_STDERR, "env_get(): GetEnvironmentVariable().");
                        }
                }
#elif defined(__APPLE__) || defined(__linux__)
                const char *result;
                result = getenv(envvarname);
                if (result != NULL)
                {
                        const char *string;
                        /* allocate a buffer which will receive variable */
                        string = lib_malloc(STRING_MEMSIZE(result));
                        if (string != NULL)
                        {
                                strcpy((char *)string, result);
                                return string;
                        }
                        log_printf(LOG_STDERR, "env_get(): lib_malloc().");
                }
#endif
        }
        else
        {
                log_printf(LOG_STDERR, "env_get(): name is NULL.");
        }

        return NULL;
}

/******************************************************************************
 * env_put()                                                                  *
 *                                                                            *
 ******************************************************************************/
int
env_put(const char *name, const char *value)
{
#if __START_IF_SELECTION__
#elif defined(_WIN32)
        if (STRING_LENGTH(value) == 0)
        {
                log_printf(LOG_STDERR, "env_put(): variable value is empty.");
                return -1;
        }
        if (SetEnvironmentVariable(name, value) == 0)
        {
                log_printf(LOG_STDERR, "env_put(): SetEnvironmentVariable().");
                return -1;
        }
#elif defined(__APPLE__) || defined(__linux__)
        char *env_entry;

        if (name == NULL || value == NULL)
        {
                log_printf(LOG_STDERR, "env_put(): name and/or value are NULL.");
                return -1;
        }

        /* +1 "=", +1 terminating NUL */
        env_entry = lib_malloc(STRING_LENGTH(name) + STRING_LENGTH(value) + 2);
        if (env_entry == NULL)
        {
                log_printf(LOG_STDERR, "env_put(): lib_malloc().");
                return -1;
        }
        env_entry[0] = '\0';
        strcat(env_entry, name);
        strcat(env_entry, "=");
        strcat(env_entry, value);

        if (putenv((char *)env_entry) != 0)
        {
                lib_free(env_entry);
                env_entry = NULL;
                log_printf(LOG_STDERR, "env_put(): putenv(): %s.", strerror(errno));
                return -1;
        }
#endif

        return 0;
}

/******************************************************************************
 *                                                                            *
 *                                                                            *
 * Timing.                                                                    *
 *                                                                            *
 *                                                                            *
 ******************************************************************************/

/******************************************************************************
 * time_usleep()                                                              *
 *                                                                            *
 * nanosleep() is available also in modern versions of MinGW-w64.             *
 ******************************************************************************/
int
time_usleep(size_t us)
{
        struct timespec ts;
        int    status;

#if defined(USE_ASSERT)
        assert(us < 1000000);
#endif

        ts.tv_sec = 0;
        ts.tv_nsec = (long)(us * 1000);

        while (true)
        {
                status = nanosleep(&ts, &ts);
                if (status < 0 && errno == EINTR)
                {
                        continue;
                }
                else
                {
                        break;
                }
        }

        return status;
}

/******************************************************************************
 * time_msleep()                                                              *
 *                                                                            *
 ******************************************************************************/
int
time_msleep(size_t ms)
{
        int status;

        /*
         * Repeatedly call time_usleep() if time interval is greater than 1 s.
         */
        while (ms >= 1000)
        {
                status = time_usleep(999 * 1000);
                if (status < 0)
                {
                        break;
                }
                ms -= 999;
        }

        /*
         * If no error was flagged, consume the remaining time.
         */
        if (status < 0)
        {
                return status;
        }
        else
        {
                return time_usleep(ms * 1000);
        }
}

/******************************************************************************
 *                                                                            *
 *                                                                            *
 * Filesystem.                                                                *
 *                                                                            *
 *                                                                            *
 ******************************************************************************/

/******************************************************************************
 * file_exists()                                                              *
 *                                                                            *
 ******************************************************************************/
bool
file_exists(const char *filename)
{
        struct stat s;

        if (stat(filename, &s) != 0)
        {
                return false;
        }

        return true;
}

/******************************************************************************
 * file_length()                                                              *
 *                                                                            *
 ******************************************************************************/
size_t
file_length(const char *filename)
{
        struct stat s;

        if (stat(filename, &s) != 0)
        {
                return 0;
        }

        return s.st_size;
}

/******************************************************************************
 * file_basename_simple()                                                     *
 *                                                                            *
 ******************************************************************************/
const char *
file_basename_simple(const char *path)
{
        size_t idx;

        if (path == NULL)
        {
                return NULL;
        }

        idx = STRING_LENGTH(path);
        while (idx > 0)
        {
                char c;
                c = path[idx - 1];
                if (c == PATH_SEPARATOR)
                {
                        break;
                }
#if __START_IF_SELECTION__
#elif defined(_WIN32)
                if (c == PATH_SEPARATOR_UNIX)
                {
                        break;
                }
                /* "C:xxx.txt" is treated like a file named "xxx.txt" in */
                /* the current subdirectory of drive C: */
                if (c == ':')
                {
                        break;
                }
#endif
                --idx;
        }

        return &path[idx];
}

/******************************************************************************
 * file_extensionname()                                                       *
 *                                                                            *
 ******************************************************************************/
const char *
file_extensionname(const char *filename)
{
        size_t      string_length;
        const char *extension;
        const char *p;

        if (filename == NULL)
        {
                return NULL;
        }

        string_length = STRING_LENGTH(filename);
        extension = strrchr(filename, '.');

        if (extension == NULL)
        {
                return filename + string_length;
        }

        for (p = extension + 1; *p != '\0'; ++p)
        {
                if (isalnum(*p) == 0)
                {
                        return filename + string_length;
                }
        }

        return extension;
}

/******************************************************************************
 * file_dirname_simple()                                                      *
 *                                                                            *
 ******************************************************************************/
char *
file_dirname_simple(char *path)
{
        static const char  dot[] = ".";
        char              *last_slash;

        /* find last '/' */
        last_slash = path != NULL ? strrchr (path, PATH_SEPARATOR) : NULL;

        if (last_slash == path)
        {
                /* the last slash is the first character in the string, */
                /* we have to return "/"                                */
                ++last_slash;
        }
        else if (last_slash != NULL && last_slash[1] == '\0')
        {
                /* the '/' is the last character, we have to look further */
                last_slash = memchr (path, last_slash - path, PATH_SEPARATOR);
        }

        if (last_slash != NULL)
        {
                /* terminate the path */
                last_slash[0] = '\0';
        }
        else
        {
                /* this assignment is ill-designed but the XPG specs */
                /* require to return a string containing "." in any case no */
                /* directory part is found and so a static and constant */
                /* string is required */
                path = (char *)dot;
        }

        return path;
}

/******************************************************************************
 * file_add_path_separator()                                                  *
 *                                                                            *
 ******************************************************************************/
char *
file_add_path_separator(char *path)
{
        if (path != NULL)
        {
                char path_separator;
                path_separator = PATH_SEPARATOR;
                strncat(path, &path_separator, 1);
        }

        return path;
}

/******************************************************************************
 * symlink_create()                                                           *
 *                                                                            *
 ******************************************************************************/
int
symlink_create(const char *target_filename, const char *link_filename)
{
#if __START_IF_SELECTION__
#elif defined(_WIN32)
        return -1;
#elif defined(__APPLE__) || defined(__linux__)
        if (link_filename == NULL)
        {
                return 0;
        }

        if (symlink(target_filename, link_filename) != 0)
        {
                log_printf(
                        LOG_STDERR,
                        "error: %s symlink()ing file %s.",
                        link_filename,
                        target_filename
                        );
                return -1;
        }

        return 0;
#endif
}

/******************************************************************************
 * symlink_delete()                                                           *
 *                                                                            *
 * Error not flagged if symlink does not exist.                               *
 ******************************************************************************/
int
symlink_delete(const char *link_filename)
{
#if __START_IF_SELECTION__
#elif defined(_WIN32)
        return -1;
#elif defined(__APPLE__) || defined(__linux__)
        struct stat s;

        if (link_filename == NULL)
        {
                return 0;
        }

        if (lstat(link_filename, &s) < 0)
        {
                /* lstat() error or symlink does not exist */
                if (errno != ENOENT)
                {
                        /* lstat() error */
                        log_printf(
                                LOG_STDERR,
                                "error: stat()ing file %s.",
                                link_filename
                                );
                        return -1;
                }
                /* OK, symlink does not exist, skip w/o error */
        }
        else
        {
                /* symlink exists */
                if (S_ISLNK(s.st_mode) != 0)
                {
                        if (remove(link_filename) < 0)
                        {
                                /* error in remove() */
                                log_printf(
                                        LOG_STDERR,
                                        "error: remove()ing file %s.",
                                        link_filename
                                        );
                                return -1;
                        }
                        /* symlink removed */
                        log_printf(
                                LOG_STDOUT,
                                "symlink: %s removed",
                                link_filename
                                );
                }
                else
                {
                        /* not a symlink */
                        log_printf(
                                LOG_STDERR,
                                "error: %s is not a symlink.",
                                link_filename
                                );
                        return -1;
                }
        }

        return 0;
#endif
}

/******************************************************************************
 *                                                                            *
 *                                                                            *
 * "argv-like" arrays.                                                        *
 *                                                                            *
 *                                                                            *
 ******************************************************************************/

/******************************************************************************
 * argv_append()                                                              *
 *                                                                            *
 ******************************************************************************/
void
argv_append(const char **argv, const char *argument)
{
        int idx;

        /* find the end of current argv array */
        idx = 0;
        while (argv[idx] != NULL)
        {
                ++idx;
        }

        /* append argument */
        argv[idx] = argument;
        argv[idx + 1] = NULL;
}

/******************************************************************************
 *                                                                            *
 *                                                                            *
 * Logging.                                                                   *
 *                                                                            *
 *                                                                            *
 ******************************************************************************/

static int         log_mode_enable = 0;
static FILE       *log_file = NULL;
static const char *log_programname = "<>";
#define LOG_BUFFER_SIZE 1024
static char        log_buffer[LOG_BUFFER_SIZE];

/******************************************************************************
 * log_print()                                                                *
 *                                                                            *
 * Print the log buffer previously filled by log_vsnprintf().                 *
 ******************************************************************************/
void
log_print(int mode)
{
        if (((mode & log_mode_enable) & LOG_STDOUT) != 0)
        {
                fprintf(stdout, "%s: %s\n", log_programname, log_buffer);
                fflush(stdout);
        }
        if (((mode & log_mode_enable) & LOG_STDERR) != 0)
        {
                fprintf(stderr, "%s: %s\n", log_programname, log_buffer);
                fflush(stderr);
        }
        if (((mode & log_mode_enable) & LOG_FILE) != 0)
        {
                if (log_file != NULL)
                {
                        fprintf(log_file, "%s: %s\n", log_programname, log_buffer);
                        fflush(log_file);
                }
        }
}

/******************************************************************************
 * log_vsnprintf()                                                            *
 *                                                                            *
 * Perform a log to the buffer, without physical output.                      *
 ******************************************************************************/
int
log_vsnprintf(const char *format, va_list ap)
{
        return vsnprintf(log_buffer, LOG_BUFFER_SIZE, format, ap);
}

/******************************************************************************
 * log_printf()                                                               *
 *                                                                            *
 * Perform a printf in the log buffer.                                        *
 ******************************************************************************/
int
log_printf(int mode, const char *format, ...)
{
        int ncharacters;

        va_list args;

        va_start(args, format);
        ncharacters = vsnprintf(log_buffer, LOG_BUFFER_SIZE, format, args);
        va_end(args);

        log_print(mode);

        return ncharacters;
}

/******************************************************************************
 * log_argv_print()                                                           *
 *                                                                            *
 ******************************************************************************/
void
log_argv_print(int mode, char **argv, const char *prefix)
{
        int         idx;
        const char *p;

        if (prefix == NULL)
        {
                prefix = "";
        }

        /* print until the end of the current argv array */
        idx = 0;
        while ((p = argv[idx]) != NULL)
        {
                /* EXEC_COMMAND_NARGV and EXEC_COMMAND_NENVP both have 1024 */
                /* items maximum, use 4 digits of padding */
                if (STRING_LENGTH(p) == 0)
                {
                        p = "<EMPTY>";
                }
                (void)log_printf(mode, "%sargv[%4d] = %s", prefix, idx, p);
                ++idx;
        }
}

/******************************************************************************
 * log_mode_set()                                                             *
 *                                                                            *
 * Enable one or more output log channels.                                    *
 ******************************************************************************/
void
log_mode_set(int mode)
{
        log_mode_enable = mode;
}

/******************************************************************************
 * log_mode_get()                                                             *
 *                                                                            *
 * Return the current log mode.                                               *
 ******************************************************************************/
int
log_mode_get(void)
{
        return log_mode_enable;
}

/******************************************************************************
 * log_close()                                                                *
 *                                                                            *
 ******************************************************************************/
void
log_close(void)
{
        if (log_file != NULL)
        {
                fclose(log_file);
                log_file = NULL;
        }
}

/******************************************************************************
 * log_init()                                                                 *
 *                                                                            *
 * log_init() can be called more than once:                                   *
 * - if logprogramname does exist, it gets changed                            *
 * - logfilename = NULL   --> keep the current one                            *
 * - logfilename = ""     --> current gets closed                             *
 * - logfilename = <name> --> a new file will be opened                       *
 * LOG_STDERR defaults to enable; thus we could detect an error in the        *
 * initialization phase; in order to disable it, call log_setmode() at once   *
 * after log_init().                                                          *
 ******************************************************************************/
int
log_init(const char *logprogramname, const char *logfilename, const char *logfilemode)
{
        log_buffer[0] = '\0';

        /*
         * We do not use LOG_FILE:
         * - if an error shows up, it is useless to write something since the
         *   file does not exist
         * - if everything went OK, we have nothing to write
         */
        log_mode_set(LOG_STDERR);

        if (logprogramname != NULL)
        {
                log_programname = logprogramname;
        }

        if (logfilename != NULL)
        {
                if (log_file != NULL)
                {
                        /* close previously opened file */
                        fclose(log_file);
                        log_file = NULL;
                }
                if (STRING_LENGTH(logfilename) > 0)
                {
                        log_file = fopen(logfilename, logfilemode);
                        if (log_file == NULL)
                        {
                                log_printf(LOG_STDERR, "fopen()ing file \"%s\".", logfilename);
                                return -1;
                        }
                }
        }

        return 0;
}

/******************************************************************************
 *                                                                            *
 *                                                                            *
 * Executing.                                                                 *
 *                                                                            *
 *                                                                            *
 ******************************************************************************/

#define EXECUTE_NARGV 1024
#define EXECUTE_NENVP 1024

struct _execute {
        const char *filename;
        const char *directory;
        const char *argv[EXECUTE_NARGV];
        const char *envp[EXECUTE_NENVP];
        int         current_argv_idx;
        int         current_envp_idx;
        int         flags;
        pid_t       child_pid;
#if __START_IF_SELECTION__
#elif defined(_WIN32)
        DWORD       child_exit_status;
#elif defined(__APPLE__) || defined(__linux__)
        int         child_exit_status;
#endif
        int         log_mode;        /* only for EXEC_PRINT_CPID/EXEC_PRINT_ARGV */
        const char *log_argv_prefix; /* only for EXEC_PRINT_CPID/EXEC_PRINT_ARGV */
        };

/******************************************************************************
 * createblockstring()                                                        *
 *                                                                            *
 * Build either a single string or a Windows-style NUL-terminated "block of   *
 * strings" from an array of strings arguments. The caller should free the    *
 * blockstring memory once it is no longer required.                          *
 * flags: ARGV_SEPARATOR_NUL: build a NUL-terminated block of strings         *
 ******************************************************************************/
#if defined(_WIN32)
#define ARGS_NUL_BLOCK (1 << 0) /* make a "Windows-style" block of strings */
static char *
createblockstring(const char **argv, int flags)
{
        int     idx;
        size_t  blockstring_length;
        size_t  argument_size;
        char   *blockstring;
        char   *p;

        /*
         * Compute total blockstring length.
         * Add a separator/terminator for each argument. If the blockstring is
         * a normal string, then the 1st..nth-1 separator is a true space
         * separator character and the last is the terminating NUL, else
         * the separator is a NUL with a final block-ending NUL.
         */
        idx = 0;
        blockstring_length = 0;
        while (true)
        {
                if (argv[idx] == NULL)
                {
                        break;
                }
                argument_size = STRING_LENGTH(argv[idx]);
                /* concatenate argument */
                blockstring_length += argument_size;
                if ((flags & ARGS_NUL_BLOCK) != 0)
                {
                        /* add a NUL terminator, always */
                        ++blockstring_length;
                }
                else
                {
                        /* add a space separator, i.e. when this is not the */
                        /* first item */
                        if (idx > 0)
                        {
                                ++blockstring_length;
                        }
                        /* starting/ending double quotes */
                        blockstring_length += 2;
                }
                /* add a space/NUL separator */
                ++blockstring_length;
                ++idx;
        }
        ++blockstring_length; /* block-terminator NUL */

        /*
         * Initialize the blockstring.
         */
        blockstring = lib_malloc(blockstring_length);
        p = blockstring;

        /*
         * Copy every item.
         */
        if ((flags & ARGS_NUL_BLOCK) != 0)
        {
                idx = 0;
                while (true)
                {
                        if (argv[idx] == NULL)
                        {
                                break;
                        }
                        strcpy(p, argv[idx]);
                        p += (STRING_LENGTH(argv[idx]) + 1);
                        ++idx;
                }
                *p = '\0';
        }
        else
        {
                *p = '\0';
                idx = 0;
                while (true)
                {
                        if (argv[idx] == NULL)
                        {
                                break;
                        }
                        if (idx > 0)
                        {
                                strcat(p, " ");
                        }
                        strcat(p, "\"");
                        strcat(p, argv[idx]);
                        strcat(p, "\"");
                        ++idx;
                }
        }

        return blockstring;
}
#endif

/******************************************************************************
 * execute_create()                                                           *
 *                                                                            *
 ******************************************************************************/
execute_t
execute_create(void)
{
        execute_t execute;
        int       idx;

        /*
         * Allocate an execute descriptor.
         */
        execute = lib_malloc(sizeof(struct _execute));
        if (execute == NULL)
        {
                return NULL;
        }

        execute->filename = NULL;
        execute->directory = NULL;

        for (idx = 0; idx < EXECUTE_NARGV; ++idx)
        {
                execute->argv[idx] = NULL;
        }
        /* argv[0] is reserved, it will be filled by execute_exec() */
        execute->current_argv_idx = 1;

        for (idx = 0; idx < EXECUTE_NENVP; ++idx)
        {
                execute->envp[idx] = NULL;
        }
        execute->current_envp_idx = 0;

        execute->flags = 0;
        execute->child_pid = PID_INVALID;
#if __START_IF_SELECTION__
#elif defined(_WIN32)
        execute->child_exit_status = ~ERROR_SUCCESS;
#elif defined(__APPLE__) || defined(__linux__)
        execute->child_exit_status = EXIT_FAILURE;
#endif
        execute->log_mode = 0;
        execute->log_argv_prefix = NULL;

        return execute;
}

/******************************************************************************
 * execute_filename_set()                                                     *
 *                                                                            *
 ******************************************************************************/
void
execute_filename_set(execute_t this, const char *filename)
{
        this->filename = filename;
}

/******************************************************************************
 * execute_filename_get()                                                     *
 *                                                                            *
 ******************************************************************************/
const char *
execute_filename_get(execute_t this)
{
        return this->filename;
}

/******************************************************************************
 * execute_directory_set()                                                    *
 *                                                                            *
 ******************************************************************************/
void
execute_directory_set(execute_t this, const char *directory)
{
        this->directory = directory;
}

/******************************************************************************
 * execute_directory_get()                                                    *
 *                                                                            *
 ******************************************************************************/
const char *
execute_directory_get(execute_t this)
{
        return this->directory;
}

/******************************************************************************
 * execute_argv_add()                                                         *
 *                                                                            *
 ******************************************************************************/
int
execute_argv_add(execute_t this, const char *argument)
{
        if (this->current_argv_idx >= EXECUTE_NARGV - 1)
        {
                log_printf(
                        LOG_STDERR,
                        "execute_argv_add(): space exhausted."
                        );
                return -1;
        }

        this->argv[this->current_argv_idx++] = argument;

        return 0;
}

/******************************************************************************
 * execute_argv_get()                                                         *
 *                                                                            *
 ******************************************************************************/
const char **
execute_argv_get(execute_t this)
{
        return this->argv;
}

/******************************************************************************
 * execute_envp_add()                                                         *
 *                                                                            *
 ******************************************************************************/
int
execute_envp_add(execute_t this, const char *argument)
{
        if (this->current_argv_idx >= EXECUTE_NENVP - 1)
        {
                log_printf(
                        LOG_STDERR,
                        "execute_envp_add(): space exhausted."
                        );
                return -1;
        }

        this->envp[this->current_envp_idx++] = argument;

        return 0;
}

/******************************************************************************
 * execute_envp_get()                                                         *
 *                                                                            *
 ******************************************************************************/
const char **
execute_envp_get(execute_t this)
{
        return this->envp;
}

/******************************************************************************
 * execute_flags_set()                                                        *
 *                                                                            *
 ******************************************************************************/
void
execute_flags_set(execute_t this, int flags)
{
        this->flags = flags;
}

/******************************************************************************
 * execute_flags_get()                                                        *
 *                                                                            *
 ******************************************************************************/
int
execute_flags_get(execute_t this)
{
        return this->flags;
}

/******************************************************************************
 * execute_log_set()                                                          *
 *                                                                            *
 ******************************************************************************/
void
execute_log_set(execute_t this, int mode, const char *prefix)
{
        this->log_mode        = mode;
        this->log_argv_prefix = prefix;
}

/******************************************************************************
 * execute_exec()                                                             *
 *                                                                            *
 ******************************************************************************/
int
execute_exec(execute_t this)
{
#if __START_IF_SELECTION__
#elif defined(_WIN32)
        STARTUPINFO         StartupInfo;
        PROCESS_INFORMATION ProcessInformation;
        LPCSTR              lpApplicationName;
        LPSTR               lpCommandLine;
        DWORD               dwCreationFlags;
        LPVOID              lpEnvironment;
        BOOL                bRes;
        int                 exit_status;

        if (this->filename == NULL)
        {
                log_printf(
                        LOG_STDERR,
                        "execute_exec(): no executable filename supplied."
                        );
                return -1;
        }

        if (!file_exists(this->filename))
        {
                log_printf(
                        LOG_STDERR,
                        "execute_exec(): \"%s\" does not exist.",
                        this->filename
                        );
                return -1;
        }

        /*
         * Initialize process structures.
         */
        ZeroMemory(&StartupInfo, sizeof StartupInfo);
        StartupInfo.cb = sizeof StartupInfo;
        ZeroMemory(&ProcessInformation, sizeof ProcessInformation);

        /*
         * Define Application Name.
         */
        lpApplicationName = (LPCSTR)this->filename;

        /*
         * Build a command line string from arguments.
         * The string must carry the full executable path as prologue.
         */
        this->argv[0] = lib_strdup(this->filename);
        lpCommandLine = (LPSTR)createblockstring(this->argv, 0);

        /*
         * Creation flags.
         */
        dwCreationFlags = 0;
        if ((this->flags & EXEC_FORK) != 0)
        {
                dwCreationFlags |= CREATE_NEW_CONSOLE;
        }

        /*
         * Build process environment.
         * Note that, unlike argv, the envp string block has a different
         * nature.
         */
        if (this->envp[0] != NULL && strcmp(this->envp[0], "*") == 0)
        {
                /* use the environment of the calling process */
                lpEnvironment = NULL;
        }
        else
        {
                /* build a NUL-terminated block of strings from the array */
                lpEnvironment = (LPVOID)createblockstring(this->envp, ARGS_NUL_BLOCK);
        }

        if ((this->flags & EXEC_PRINT_ARGV) != 0)
        {
                log_argv_print(this->log_mode, (char **)this->argv, this->log_argv_prefix);
        }

        /*
         * Start the child process.
         */
        bRes = CreateProcess(
                        lpApplicationName,
                        lpCommandLine,
                        NULL,                /* process handle not inheritable */
                        NULL,                /* thread handle not inheritable */
                        FALSE,               /* set handle inheritance to FALSE */
                        dwCreationFlags,
                        lpEnvironment,
                        this->directory,
                        &StartupInfo,
                        &ProcessInformation
                        );

        if (!bRes)
        {
                /* free variables created previously */
                lib_free(lpCommandLine);
                lpCommandLine = NULL;
                lib_free(lpEnvironment);
                lpEnvironment = NULL;
                this->child_exit_status = GetLastError();
                log_printf(
                        LOG_STDERR,
                        "execute_exec(): CreateProcess() error %"EXITSTATUS_FORMAT".",
                        this->child_exit_status
                        );
                return -1;
        }

        this->child_pid = (pid_t)ProcessInformation.dwProcessId;
        CloseHandle(ProcessInformation.hThread);
        exit_status = 0;

        if ((this->flags & EXEC_PRINT_CPID) != 0)
        {
                log_printf(this->log_mode, "CPID = %"PID_FORMAT, this->child_pid);
        }

        /*
         * Wait until child process exits.
         */
        if ((this->flags & EXEC_FORK) == 0)
        {
                if (WaitForSingleObject(ProcessInformation.hProcess, INFINITE) != WAIT_OBJECT_0)
                {
                        log_printf(
                                LOG_STDERR,
                                "execute_exec(): WaitForSingleObject() error."
                                );
                        exit_status = -1;
                }
                else
                {
                        (void)GetExitCodeProcess(ProcessInformation.hProcess, &this->child_exit_status);
                        if (this->child_exit_status != ERROR_SUCCESS)
                        {
                                exit_status = -1;
                        }
                }
                /* free variables created previously */
                lib_free(lpCommandLine);
                lpCommandLine = NULL;
                lib_free(lpEnvironment);
                lpEnvironment = NULL;
        }

        /*
         * NOTE: if a "fork" is being performed we do not free memory linked
         * with lpCommandLine and lpEnvironment, since the child process seems
         * to possibly reference it until it will be completely initialized;
         * it is not simple to detect this case, so we suffer a memory leak
         * here.
         */

        CloseHandle(ProcessInformation.hProcess);

        return exit_status;
#elif defined(__APPLE__) || defined(__linux__)
        pid_t pid;
        int   exit_status;

        if (this->filename == NULL)
        {
                log_printf(
                        LOG_STDERR,
                        "execute_exec(): no executable filename supplied."
                        );
                return -1;
        }

        if (!file_exists(this->filename))
        {
                log_printf(
                        LOG_STDERR,
                        "execute_exec(): \"%s\" does not exist.",
                        this->filename
                        );
                return -1;
        }

        this->argv[0] = lib_strdup(this->filename);

        if ((this->flags & EXEC_PRINT_ARGV) != 0)
        {
                log_argv_print(this->log_mode, (char **)this->argv, this->log_argv_prefix);
        }

        pid = fork();
        if (pid == (pid_t)-1)
        {
                log_printf(
                        LOG_STDERR,
                        "execute_exec(): fork() error."
                        );
                return -1;
        }
        else if (pid != 0)
        {
                /*
                 * Parent.
                 */
                int wstatus;
                pid_t waitpid_status;
                /*
                 * Register child pid.
                 */
                this->child_pid = pid;
                /*
                 * Print out the PID in order to allow a parsing of external
                 * tools.
                 */
                if ((this->flags & EXEC_PRINT_CPID) != 0)
                {
                        log_printf(this->log_mode, "CPID = %"PID_FORMAT, this->child_pid);
                }
                if ((this->flags & EXEC_FORK) != 0)
                {
                        return 0;
                }
                /*
                 * Wait for child.
                 * The while loop exists only as a continue target.
                 * Note that we are in the parent process, and the child exit
                 * status (the child_exit_status field) can be one of:
                 * 0      exited normally
                 * != 0   exited with errors (value is child''s decision)
                 * 126    command found but not executable (Bash convention)
                 * 127    command not found
                 * >= 128 terminated abnormally by a signal
                 * This function by itself returns only 0/-1 values.
                 */
                while (true)
                {
                        wstatus = 0; /* required for waitpid() */
                        waitpid_status = waitpid(pid, &wstatus, 0);
                        if (waitpid_status == PID_INVALID)
                        {
                                if (errno == EINTR)
                                {
                                        /*
                                         * This calling process (the parent)
                                         * got a signal during waitpid(). The
                                         * signal handler must deliver a
                                         * signal to the child so that we can
                                         * restart the waitpid() again.
                                         */
                                        //log_printf(
                                        //        LOG_STDERR,
                                        //        "execute(): waitpid(): EINTR on PID %"PID_FORMAT".",
                                        //        pid
                                        //        );
                                        continue;
                                }
                                log_printf(
                                        LOG_STDERR,
                                        "execute_exec(): waitpid() on PID %"PID_FORMAT" error: %s.",
                                        pid,
                                        strerror(errno)
                                        );
                                return -1;
                        }
                        else if (waitpid_status != pid)
                        {
                                log_printf(
                                        LOG_STDERR,
                                        "execute_exec(): waitpid() on PID %"PID_FORMAT" returns erronueos value.",
                                        pid
                                        );
                                return -1;
                        }
                        /*
                         * This is not a true loop, force exit anyway.
                         */
                        break;
                }
                /*
                 * Child terminated (normally or not).
                 */
                if (WIFEXITED(wstatus))
                {
                        /*
                         * Child terminated normally by means of either a call
                         * to exit()/_exit() or a return from main() (but
                         * maybe it could have detected some error and its
                         * exit status is not 0).
                         */
                        this->child_exit_status = WEXITSTATUS(wstatus);
                        switch (this->child_exit_status)
                        {
                                case 0:
                                        /* exited cleanly */
                                        return 0;
                                        break;
                                case 127:
                                        /* no executable found */
                                        log_printf(
                                                LOG_STDERR,
                                                "execute_exec(): command not found."
                                                );
                                        return -1;
                                        break;
                                default:
                                        /* exited with error(s) */
                                        if ((this->flags & EXEC_NO_EXIT_ERRORS) == 0)
                                        {
                                                log_printf(
                                                        LOG_STDERR,
                                                        "execute_exec(): child pid %"PID_FORMAT" exited with status: %"EXITSTATUS_FORMAT".",
                                                        pid,
                                                        this->child_exit_status
                                                        );
                                        }
                                        return -1;
                                        break;
                        }
                }
                else if (WIFSIGNALED(wstatus))
                {
                        /*
                         * Child terminated abnormally (e.g.: SIGABRT) because
                         * it received a signal that was not handled.
                         */
                        this->child_exit_status = 128 + WTERMSIG(wstatus);
                        log_printf(
                                LOG_STDERR,
                                "execute_exec(): child pid %"PID_FORMAT" got unhandled signal %d (%s).",
                                pid,
                                WTERMSIG(wstatus),
                                strsignal(WTERMSIG(wstatus))
                                );
                        return -1;
                }
                /* CANNOTOCCUR */
                log_printf(
                        LOG_STDERR,
                        "execute_exec(): child pid %"PID_FORMAT" anomalous exit, unknown reason.",
                        pid
                        );
                return -1;
        }

        /*
         * Child continues.
         *
         * NOTE: SYSTEM(3) advises the use of EXEC(3) functions, but it seems
         * OK to use execve(), which is the base of all these functions.
         *
         * If we have specified a "*" as the first string of the envp argument
         * array, then use the whole environment of the current process.
         */

        /*
         * Close log file.
         */
        log_close();

        exit_status = 0;

        if (this->directory != NULL)
        {
                exit_status = chdir(this->directory);
        }

        if (exit_status == 0)
        {
                /*
                 * Build process environment and execute.
                 */
                if (this->envp[0] != NULL && strcmp(this->envp[0], "*") == 0)
                {
                        extern char **environ;
                        execve(this->filename, (char * const *)this->argv, environ);
                }
                else
                {
                        execve(this->filename, (char * const *)this->argv, (char * const *)this->envp);
                }
        }

        _exit(127); /* 127 is "command not found" */

        /*
         * NOTREACHED, avoid compiler warning
         */

        return -1;
#endif
}

/******************************************************************************
 * execute_child_pid()                                                        *
 *                                                                            *
 ******************************************************************************/
pid_t
execute_child_pid(execute_t this)
{
        return this->child_pid;
}

/******************************************************************************
 * execute_child_exit_status()                                                *
 *                                                                            *
 ******************************************************************************/
#if __START_IF_SELECTION__
#elif defined(_WIN32)
DWORD
#elif defined(__APPLE__) || defined(__linux__)
int
#endif
execute_child_exit_status(execute_t this)
{
        return this->child_exit_status;
}

/******************************************************************************
 * execute_destroy()                                                          *
 *                                                                            *
 * Destroy an execute_t object.                                               *
 ******************************************************************************/
execute_t
execute_destroy(execute_t this)
{
        lib_free((void *)this->argv[0]);
        this->argv[0] = NULL;
        lib_free(this);
        this = NULL;

        return this;
}

/******************************************************************************
 * execute_system()                                                           *
 *                                                                            *
 * Execute a command by calling system().                                     *
 * argv[0] is the program executable.                                         *
 ******************************************************************************/
int
execute_system(int argc, char **argv)
{
        char command_line[4096];
        int  idx;

        /* "open" empty string */
        strcpy(command_line, "");

        /*
         * "To launch a batch script with spaces in the Program Path requiring
         * "quotes""
         */
#if __START_IF_SELECTION__
#elif defined(_WIN32)
        strcat(command_line, "\"");
#endif

        for (idx = 0; idx < argc; ++idx)
        {
                if (idx > 0)
                {
                        strcat(command_line, " ");
                }
                strcat(command_line, "\"");
                strcat(command_line, argv[idx]);
                strcat(command_line, "\"");
        }

#if __START_IF_SELECTION__
#elif defined(_WIN32)
        strcat(command_line, "\"");
#endif

        return system(command_line);
}

/******************************************************************************
 * process_terminate()                                                        *
 *                                                                            *
 * Terminate a process.                                                       *
 ******************************************************************************/
bool
process_terminate(pid_t pid)
{
        bool exit_status;

        exit_status = false;

        if (pid != PID_INVALID)
        {
#if __START_IF_SELECTION__
#elif defined(_WIN32)
                HANDLE ProcessHandle;
                DWORD dwError;
                DWORD ExitCode;
                ProcessHandle = OpenProcess(
                                        PROCESS_TERMINATE | PROCESS_QUERY_INFORMATION,
                                        FALSE,
                                        pid
                                        );
                if (ProcessHandle == NULL)
                {
                        log_printf(
                                LOG_STDERR,
                                "OpenProcess() error: serial port handler PID %"PID_FORMAT" code 0x%x",
                                pid,
                                GetLastError()
                                );
                        return false;
                }
                dwError = GetExitCodeProcess(ProcessHandle, &ExitCode);
                if (dwError == 0)
                {
                        log_printf(
                                LOG_STDERR,
                                "GetExitCodeProcess() error: handler PID %"PID_FORMAT" code %u",
                                pid,
                                GetLastError()
                                );
                        exit_status = false;
                }
                else
                {
                        if (TerminateProcess(ProcessHandle, 0) != 0)
                        {
                                log_printf(
                                        LOG_STDOUT,
                                        "handler PID %"PID_FORMAT" terminated",
                                        pid
                                        );
                                exit_status = true;
                        }
                        else
                        {
                                log_printf(
                                        LOG_STDERR,
                                        "TerminateProcess() error: handler PID %"PID_FORMAT" code 0x%x",
                                        pid,
                                        GetLastError()
                                        );
                                exit_status = false;
                        }
                }
                CloseHandle(ProcessHandle);
#elif defined(__APPLE__) || defined(__linux__)
                if (kill(pid, 0) != 0 && errno == ESRCH)
                {
                        /* already terminated */
                        log_printf(
                                LOG_STDOUT,
                                "handler PID %"PID_FORMAT" terminated",
                                pid
                                );
                        return true;
                }
                if (kill(pid, SIGTERM) != 0)
                {
                        int errno_sigterm;
                        errno_sigterm = errno;
                        if (kill(pid, 0) != 0 && errno == ESRCH)
                        {
                                /* maybe terminated in between */
                                exit_status = true;
                        }
                        else
                        {
                                /* kill() failed */
                                log_printf(
                                        LOG_STDERR,
                                        "kill(): error on handler PID %"PID_FORMAT": %s",
                                        pid,
                                        strerror(errno_sigterm)
                                        );
                                exit_status = false;
                        }
                }
                else
                {
                        /* kill() succeeded */
                        log_printf(
                                LOG_STDOUT,
                                "handler PID %"PID_FORMAT" terminated",
                                pid
                                );
                        exit_status = true;
                }
#endif
        }

        return exit_status;
}

/******************************************************************************
 *                                                                            *
 *                                                                            *
 * Library handling.                                                          *
 *                                                                            *
 *                                                                            *
 ******************************************************************************/

#if !defined(NO_DLL_HANDLING)
void *
dll_load(const char *library_filename)
{
#if __START_IF_SELECTION__
#elif defined(_WIN32)
        return (void *)LoadLibrary(library_filename);
#elif defined(__APPLE__) || defined(__linux__)
        return dlopen(library_filename, 0);
#endif
}
#endif


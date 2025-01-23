
/*
 * gcc-wrapper.c
 *
 * Copyright (C) 2020-2025 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

/*
 * Arguments:
 * $@ = GCC command line
 *
 * Environment variables:
 * GCC_WRAPPER_ASSEMBLER_OUTPUT
 * GCC_WRAPPER_TIMESTAMP_FILENAME
 * SWEETADA_PATH
 * OBJECT_DIRECTORY
 */

/******************************************************************************
 * Standard C headers.                                                        *
 ******************************************************************************/

#include <errno.h>
#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/******************************************************************************
 * System headers.                                                            *
 ******************************************************************************/

#include <fcntl.h>
#include <unistd.h>

/******************************************************************************
 * Application headers.                                                       *
 ******************************************************************************/

#include "library.h"

/******************************************************************************
 * Private definitions.                                                       *
 ******************************************************************************/

#define GCC_WRAPPER_VERSION "1.0"

struct switch_descriptor {
        const char *name;
        int         flags;
        };

#define EXACT_MATCH     (1 << 0)
#define HAS_ARGUMENT    (1 << 1)
#define TRANSLATE_BS    (1 << 2)
#define OUTPUT_FILENAME (1 << 3)
#define GNAT_FLAG       (1 << 4)

static struct switch_descriptor switches[] = {
        { "D",             EXACT_MATCH | HAS_ARGUMENT                   },
        { "G",             EXACT_MATCH | HAS_ARGUMENT                   },
        { "I",             EXACT_MATCH | HAS_ARGUMENT                   },
        { "MF",            EXACT_MATCH | HAS_ARGUMENT                   },
        { "MMD",           EXACT_MATCH | HAS_ARGUMENT                   },
        { "MT",            EXACT_MATCH | HAS_ARGUMENT                   },
        { "auxbase",       EXACT_MATCH | HAS_ARGUMENT                   },
        { "auxbase-strip", EXACT_MATCH | HAS_ARGUMENT                   },
        { "dumpbase",      EXACT_MATCH | HAS_ARGUMENT                   },
        { "dumpbase-ext",  EXACT_MATCH | HAS_ARGUMENT                   },
        { "dumpdir",       EXACT_MATCH | HAS_ARGUMENT | TRANSLATE_BS    },
        { "fRTS=",                                      TRANSLATE_BS    },
        { "gnatG",         EXACT_MATCH                | GNAT_FLAG       },
        { "gnatO",         EXACT_MATCH | HAS_ARGUMENT                   },
        { "imultilib",     EXACT_MATCH | HAS_ARGUMENT                   },
        { "iprefix",       EXACT_MATCH | HAS_ARGUMENT                   },
        { "isystem",       EXACT_MATCH | HAS_ARGUMENT                   },
        { "o",             EXACT_MATCH | HAS_ARGUMENT | OUTPUT_FILENAME },
        { "plugin",        EXACT_MATCH | HAS_ARGUMENT                   },
        { NULL, 0 }
        };

/******************************************************************************
 * execute_setup()                                                            *
 *                                                                            *
 ******************************************************************************/
static int
execute_setup(execute_t execute, int argc, char **argv)
{
        int idx;

        execute_filename_set(execute, argv[1]);

        /* fill arguments (but not argv[0], which will be created by the */
        /* execute_exec() function) */
        for (idx = 1; idx < (argc - 1); ++idx) /* -1 because argv[1] is discarded */
        {
                /* +1 start from source argv[2] */
                if (execute_argv_add(execute, argv[idx + 1]) < 0)
                {
                        return -1;
                }
        }

        /* standard envp */
        if (execute_envp_add(execute, "*") < 0)
        {
                return -1;
        }

        return 0;
}

/******************************************************************************
 * main()                                                                     *
 *                                                                            *
 * Main loop.                                                                 *
 ******************************************************************************/
int
main(int argc, char **argv)
{
        int         exit_status;
        char        program_name[PATH_MAX + 1];
        bool        cc1_or_gnat1;
        bool        as;
        bool        collect2;
        bool        objcopy;
        const char *source_filename;
        const char *output_filename;
        bool        error_flag;
        int         number_of_arguments; /* avoid modifying argc */
        bool        gcc_gnatg_flag;
        bool        plain_token_flag;
        int         idx;
        execute_t   execute;
        const char *as_listing_options;
        char       *as_listing_string;
        const char *timestamp_filename;

        exit_status = EXIT_FAILURE;
        cc1_or_gnat1 = false;
        as = false;
        collect2 = false;
        objcopy = false;
        source_filename = NULL;
        output_filename = NULL;
        execute = NULL;
        as_listing_options = NULL;
        as_listing_string = NULL;
        timestamp_filename = NULL;

        /*
         * Extract the program name.
         */
        strcpy(program_name, file_basename_simple(argv[0]));

        /*
         * Check for enough arguments.
         */
        if (argc < 2)
        {
                fprintf(stderr, "%s: *** Error: no arguments.\n", program_name);
                goto main_exit;
        }
        /*
         * Check for "-v", which should be the first argument (usable only for
         * diagnostics).
         */
        if (strcmp(argv[1], "-v") == 0)
        {
                fprintf(stdout, "%s: version %s\n", program_name, GCC_WRAPPER_VERSION);
                exit_status = EXIT_SUCCESS;
                goto main_exit;
        }

        /*
         * Check requested executable filename.
         */
#if __START_IF_SELECTION__
#elif defined(_WIN32)
        if (
            strcmp(&argv[1][STRING_LENGTH(argv[1]) - 7], "cc1.exe") == 0   ||
            strcmp(&argv[1][STRING_LENGTH(argv[1]) - 9], "gnat1.exe") == 0
           )
#else
        if (
            strcmp(&argv[1][STRING_LENGTH(argv[1]) - 3], "cc1") == 0   ||
            strcmp(&argv[1][STRING_LENGTH(argv[1]) - 5], "gnat1") == 0
           )
#endif
        {
                cc1_or_gnat1 = true;
        }
#if __START_IF_SELECTION__
#elif defined(_WIN32)
        else if (strcmp(&argv[1][STRING_LENGTH(argv[1]) - 6], "as.exe") == 0)
#else
        else if (strcmp(&argv[1][STRING_LENGTH(argv[1]) - 2], "as") == 0)
#endif
        {
                as = true;
        }
#if __START_IF_SELECTION__
#elif defined(_WIN32)
        else if (strcmp(&argv[1][STRING_LENGTH(argv[1]) - 12], "collect2.exe") == 0)
#else
        else if (strcmp(&argv[1][STRING_LENGTH(argv[1]) - 8], "collect2") == 0)
#endif
        {
                collect2 = true;
        }
#if __START_IF_SELECTION__
#elif defined(_WIN32)
        else if (strcmp(&argv[1][STRING_LENGTH(argv[1]) - 11], "objcopy.exe") == 0)
#else
        else if (strcmp(&argv[1][STRING_LENGTH(argv[1]) - 7], "objcopy") == 0)
#endif
        {
                objcopy = true;
        }
        else
        {
                fprintf(stderr, "%s: *** Error: executable not recognized.\n", program_name);
                goto main_exit;
        }

        /*
         * Argument parsing.
         */
        if (objcopy)
        {
                /* skip parsing */
                goto no_parsing;
        }
        error_flag = false;
        number_of_arguments = argc;
        gcc_gnatg_flag = false;
        plain_token_flag = false;
        idx = 0;
        if (number_of_arguments > 0)
        {
                /* skip argv[0] */
                --number_of_arguments;
                ++idx;
        }
        if (number_of_arguments > 0)
        {
                /* skip argv[1] */
                --number_of_arguments;
                ++idx;
        }
        while (!error_flag && number_of_arguments > 0)
        {
                --number_of_arguments;
                if (argv[idx][0] == '-')
                {
                        int idx_switches;
                        const char *switch_name;
                        idx_switches = 0;
                        while ((switch_name = switches[idx_switches].name) != NULL)
                        {
                                int flags;
                                bool match;
                                flags = switches[idx_switches].flags;
                                match = false;
                                if ((flags & EXACT_MATCH) != 0)
                                {
                                        match = strcmp(&argv[idx][1], switch_name) == 0;
                                }
                                else
                                {
                                        match = strncmp(&argv[idx][1], switch_name, STRING_LENGTH(switch_name)) == 0;
                                }
                                if (match)
                                {
                                        if ((flags & HAS_ARGUMENT) != 0)
                                        {
                                                --number_of_arguments;
                                                ++idx;
                                        }
                                        if ((flags & TRANSLATE_BS) != 0)
                                        {
#if __START_IF_SELECTION__
#elif defined(_WIN32)
                                                if (argv[idx][STRING_LENGTH(argv[idx]) - 1] == '\\')
                                                {
                                                        argv[idx][STRING_LENGTH(argv[idx]) - 1] = '/';
                                                }
#endif
                                        }
                                        if ((flags & OUTPUT_FILENAME) != 0)
                                        {
                                                output_filename = argv[idx];
                                        }
                                        if ((flags & GNAT_FLAG) != 0)
                                        {
                                                gcc_gnatg_flag = true;
                                        }
                                }
                                ++idx_switches;
                        }
                }
                else if (argv[idx][0] == '@')
                {
                        /* reference */
                        /* __NOP__ */
                }
                else
                {
                        /* an argument without "-" is a token */
                        if (plain_token_flag == false)
                        {
                                /* if only one token accepted */
                                plain_token_flag = true;
                                source_filename = argv[idx];
                        }
                        else
                        {
                                /* if only one token accepted */
                                error_flag = true;
                                {
                                        fprintf(stderr, "%s: *** Error: parsing error.\n", program_name);
                                }
                        }
                }
                if (!error_flag)
                {
                        ++idx; /* next argument index */
                }
        }
        if (error_flag)
        {
                exit_status = EXIT_FAILURE;
                goto main_exit;
        }
no_parsing:

        /*
         * Setup execution.
         */
        if (!(cc1_or_gnat1 || as || collect2 || objcopy))
        {
                fprintf(stderr, "%s: *** Error: executable not recognized.\n", program_name);
                goto main_exit;
        }
        if ((execute = execute_create()) == NULL)
        {
                fprintf(stderr, "%s: *** Error: execute_create().\n", program_name);
                goto main_exit;
        }
        if (execute_setup(execute, argc, argv) < 0)
        {
                fprintf(stderr, "%s: *** Error: execute_setup().\n", program_name);
                goto exec_end;
        }
        execute_flags_set(execute, EXEC_NO_EXIT_ERRORS);
        if (cc1_or_gnat1)
        {
                bool stdout_redirect;
                int stdout_fd;
                int stdout_current;
                stdout_redirect = false;
                if (gcc_gnatg_flag)
                {
                        stdout_redirect = true;
                }
                if (stdout_redirect)
                {
                        bool redirect_ok;
                        const char *sweetada_path;
                        const char *object_directory;
                        char stdout_filename[PATH_MAX + 1];
                        redirect_ok = false;
                        /* build filename */
                        stdout_filename[0] = '\0';
                        /* first, prefix with SWEETADA_PATH and OBJECT_DIRECTORY */
                        sweetada_path = env_get("SWEETADA_PATH");
                        object_directory = env_get("OBJECT_DIRECTORY");
                        if (sweetada_path != NULL)
                        {
                                strcpy(stdout_filename, sweetada_path);
                        }
                        if (object_directory != NULL)
                        {
                                if (STRING_LENGTH(stdout_filename) != 0)
                                {
                                        file_add_path_separator(stdout_filename);
                                        strcat(stdout_filename, object_directory);
                                }
                                else
                                {
                                        strcpy(stdout_filename, object_directory);
                                }
                        }
                        /* else, prefix with "." */
                        if (STRING_LENGTH(stdout_filename) == 0)
                        {
                                strcpy(stdout_filename, ".");
                        }
                        file_add_path_separator(stdout_filename);
                        strcat(stdout_filename, file_basename_simple(source_filename));
                        if (gcc_gnatg_flag)
                        {
                                strcat(stdout_filename, ".expand");
                        }
                        stdout_fd = open(stdout_filename, O_RDWR | O_CREAT, 0644);
                        if (stdout_fd < 0)
                        {
                                fprintf(stderr, "%s: *** Error: open()ing \"%s\".\n", program_name, stdout_filename);
                        }
                        else
                        {
                                stdout_current = dup(fileno(stdout));
                                if (stdout_current < 0)
                                {
                                        fprintf(stderr, "%s: *** Error: dup().\n", program_name);
                                }
                                else if (dup2(stdout_fd, fileno(stdout)) < 0)
                                {
                                        fprintf(stderr, "%s: *** Error: dup2().\n", program_name);
                                }
                                else
                                {
                                        redirect_ok = true;
                                }
                        }
                        lib_free((void *)object_directory);
                        object_directory = NULL;
                        lib_free((void *)sweetada_path);
                        sweetada_path = NULL;
                        if (!redirect_ok)
                        {
                                goto exec_end;
                        }
                }
                /* execute */
                exit_status = execute_exec(execute);
                if (stdout_redirect)
                {
                        fflush(stdout);
                        close(stdout_fd);
                        if (dup2(stdout_current, fileno(stdout)) < 0)
                        {
                                fprintf(stderr, "%s: *** Error: dup2().\n", program_name);
                                goto exec_end;
                        }
                        close(stdout_current);
                }
        }
        else if (as)
        {
                /*
                 * Check for GCC_WRAPPER_ASSEMBLER_OUTPUT specification.
                 */
                as_listing_options = env_get("GCC_WRAPPER_ASSEMBLER_OUTPUT");
                if (as_listing_options != NULL && strncmp(as_listing_options, "-a", 2) == 0)
                {
                        size_t as_listing_string_size;
                        /* terminating NUL */
                        as_listing_string_size = 1;
                        /* "=" + ".lst" */
                        as_listing_string_size += 5;
                        as_listing_string_size += STRING_LENGTH(as_listing_options);
                        as_listing_string_size += STRING_LENGTH(output_filename);
                        as_listing_string = lib_malloc(as_listing_string_size);
                        if (as_listing_string == NULL)
                        {
                                fprintf(stderr, "%s: *** Error: lib_malloc().\n", program_name);
                                goto exec_end;
                        }
                        as_listing_string[0] = '\0';
                        strcat(as_listing_string, as_listing_options);
                        strcat(as_listing_string, "=");
                        strcat(as_listing_string, output_filename);
                        strcat(as_listing_string, ".lst");
                        if (execute_argv_add(execute, as_listing_string) < 0)
                        {
                                fprintf(stderr, "%s: *** Error: execute_argv_add().\n", program_name);
                                goto exec_end;
                        }
                }
                /* execute */
                exit_status = execute_exec(execute);
        }
        else if (collect2)
        {
                /* execute */
                exit_status = execute_exec(execute);
        }
        else if (objcopy)
        {
                /* execute */
                exit_status = execute_exec(execute);
        }
        else
        {
                /* __DNO__ */
        }

        /*
         * Generate a timestamp output file which describes the output file.
         */
        if (as)
        {
                timestamp_filename = env_get("GCC_WRAPPER_TIMESTAMP_FILENAME");
                if (timestamp_filename != NULL && STRING_LENGTH(timestamp_filename) > 0)
                {
                        if (execute_child_exit_status(execute) == 0)
                        {
                                FILE *fp;
                                fp = fopen(timestamp_filename, "w");
                                if (fp == NULL)
                                {
                                        fprintf(stderr, "%s: *** Error: unable to open \"%s\".\n", program_name, timestamp_filename);
                                        exit_status = EXIT_FAILURE;
                                }
                                else
                                {
                                        if (output_filename != NULL)
                                        {
                                                fprintf(fp, "%s\n", output_filename);
                                        }
                                        fclose(fp);
                                }
                        }
                }
        }
exec_end:

        /*
         * Invalidate.
         */
        execute = execute_destroy(execute);

main_exit:

        /*
         * Cleanup.
         */
        lib_free((void *)as_listing_options);
        as_listing_options = NULL;
        lib_free((void *)as_listing_string);
        as_listing_string = NULL;
        lib_free((void *)timestamp_filename);
        timestamp_filename = NULL;

        exit(exit_status);
}


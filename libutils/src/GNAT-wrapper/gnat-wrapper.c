
/*
 * gnat-wrapper.c
 *
 * Copyright (C) 2020-2023 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

/*
 * Arguments:
 * $@ = GCC command line
 *
 * Environment variables:
 * GNAT_WRAPPER_GCC_EXECUTABLE
 * GNAT_WRAPPER_VERBOSE
 * GNAT_WRAPPER_GCC_BRIEFTEXT
 * GNAT_WRAPPER_TIMESTAMP_FILENAME
 */

/******************************************************************************
 * Standard C headers.                                                        *
 ******************************************************************************/

#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/******************************************************************************
 * System headers.                                                            *
 ******************************************************************************/

#include <fcntl.h>
#include <unistd.h>

/******************************************************************************
 * Private definitions.                                                       *
 ******************************************************************************/

#include "library.h"

#define GNAT_WRAPPER_VERSION "1.0"

struct switch_descriptor {
        const char *name;
        int         flags;
        };

#define EXACT_MATCH     (1 << 0)
#define HAS_ARGUMENT    (1 << 1)
#define TRANSLATE_BS    (1 << 2)
#define OUTPUT_FILENAME (1 << 3)
#define COMPILER_MODE   (1 << 4)
#define BINDER_MODE     (1 << 5)
#define LINKER_MODE     (1 << 6)

static struct switch_descriptor switches[] = {
        { "I",                                    TRANSLATE_BS    },
        { "b",       EXACT_MATCH                | BINDER_MODE     },
        { "c",       EXACT_MATCH                | COMPILER_MODE   },
        { "l",       EXACT_MATCH                | LINKER_MODE     },
        { "o",       EXACT_MATCH | HAS_ARGUMENT | OUTPUT_FILENAME },
        { "wrapper", EXACT_MATCH | HAS_ARGUMENT                   },
        { "x",       EXACT_MATCH | HAS_ARGUMENT                   },
        { NULL, 0 }
        };

/******************************************************************************
 * execute_setup()                                                            *
 *                                                                            *
 ******************************************************************************/
static int
execute_setup(execute_t execute, int argc, char **argv, char *executable)
{
        int idx;

        execute_filename_set(execute, executable);

        /* fill arguments (but not argv[0], which will be created by the */
        /* execute_exec() function) */
        for (idx = 1; idx < argc; ++idx)
        {
                execute_argv_add(execute, argv[idx]);
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
        const char *gcc_executable_env;
        char        gcc_executable[PATH_MAX + 1];
        bool        error_flag;
        bool        compile_mode;
        bool        bind_mode;
        bool        link_mode;
        const char *input_filename;
        const char *output_filename;
        int         number_of_arguments; /* avoid modifying argc */
        bool        plain_token_flag;
        int         idx;
        execute_t   execute;
        const char *verbose;
        const char *brieftext;
        const char *timestamp_filename;

        exit_status = EXIT_FAILURE;
        compile_mode = false;
        bind_mode = false;
        link_mode = false;
        input_filename = NULL;
        output_filename = NULL;
        verbose = NULL;
        brieftext = NULL;
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
                fprintf(stdout, "%s: version %s\n", program_name, GNAT_WRAPPER_VERSION);
                exit_status = EXIT_SUCCESS;
                goto main_exit;
        }

        /*
         * GNAT_WRAPPER_GCC_EXECUTABLE.
         */
        gcc_executable_env = env_get("GNAT_WRAPPER_GCC_EXECUTABLE");
        if (gcc_executable_env == NULL)
        {
                fprintf(stderr, "%s: *** Error: no GNAT_WRAPPER_GCC_EXECUTABLE.\n", program_name);
                goto main_exit;
        }
        strcpy(gcc_executable, gcc_executable_env);
        lib_free((void *)gcc_executable_env);
        gcc_executable_env = NULL;

        /*
         * Argument parsing.
         */
        error_flag = false;
        number_of_arguments = argc;
        plain_token_flag = false;
        idx = 0;
        if (number_of_arguments > 0)
        {
                /* skip argv[0] */
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
                                        if ((flags & BINDER_MODE) != 0)
                                        {
                                                bind_mode = true;
                                        }
                                        if ((flags & COMPILER_MODE) != 0)
                                        {
                                                compile_mode = true;
                                        }
                                        if ((flags & LINKER_MODE) != 0)
                                        {
                                                link_mode = true;
                                        }
                                }
                                ++idx_switches;
                        }
                }
                else
                {
                        /* an argument without "-" is a token */
                        if (plain_token_flag == false)
                        {
                                /* if only one token accepted */
                                plain_token_flag = true;
                                input_filename = argv[idx];
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

        /* avoid warnings */
        (void)output_filename;
        (void)bind_mode;
        (void)link_mode;
        (void)compile_mode;

        /*
         * We specified --GCC and no --GNATBIND/--GNATLINK.
         */
        if (!compile_mode || bind_mode || link_mode)
        {
                fprintf(stderr, "%s: *** Error: gnat-wrapper needs GCC mode ('-c' switch).\n", program_name);
                goto main_exit;
        }

        /*
         * Setup GCC execution.
         */
        if ((execute = execute_create()) == NULL)
        {
                fprintf(stderr, "%s: *** Error: execute_create().\n", program_name);
                goto main_exit;
        }
        if (execute_setup(execute, argc, argv, gcc_executable) < 0)
        {
                fprintf(stderr, "%s: *** Error: execute_setup().\n", program_name);
                goto exec_end;
        }
        execute_flags_set(execute, EXEC_NO_EXIT_ERRORS);
        /*
         * Check for GNAT_WRAPPER_VERBOSE and GNAT_WRAPPER_GCC_BRIEFTEXT.
         */
        verbose = env_get("GNAT_WRAPPER_VERBOSE");
        if (verbose == NULL || (verbose != NULL && strcmp(verbose, "Y") != 0))
        {
                /*
                 * No verbosity, use GNAT_WRAPPER_GCC_BRIEFTEXT.
                 */
                brieftext = env_get("GNAT_WRAPPER_GCC_BRIEFTEXT");
                if (brieftext != NULL)
                {
                        /*
                         * Print brief text with input filename.
                         */
                        fprintf(stdout, "%s %s\n", brieftext, file_basename_simple(input_filename));
                }
        }

        /*
         * Wrapper execution.
         */
        exit_status = execute_exec(execute);

        /*
         * Generate a timestamp output file which describes the output file.
         */
        timestamp_filename = env_get("GNAT_WRAPPER_TIMESTAMP_FILENAME");
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
exec_end:

        /*
         * Invalidate.
         */
        execute = execute_destroy(execute);

main_exit:

        /*
         * Cleanup.
         */
        lib_free((void *)verbose);
        verbose = NULL;
        lib_free((void *)brieftext);
        brieftext = NULL;
        lib_free((void *)timestamp_filename);
        timestamp_filename = NULL;

        exit(exit_status);
}


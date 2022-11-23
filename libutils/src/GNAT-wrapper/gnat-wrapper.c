
/*
 * gnat-wrapper.c
 *
 * Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
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

#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <unistd.h>

#include "library.h"

/******************************************************************************
 *                                                                            *
 ******************************************************************************/

#define GNAT_WRAPPER_VERSION "1.0"

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
        bool        compile_only;
        bool        bind_only;
        bool        link_only;
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
        compile_only = false;
        bind_only = false;
        link_only = false;
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
         * Check for "-v".
         */
        if (argc < 2)
        {
                fprintf(stderr, "%s: *** Error: no arguments.\n", program_name);
                goto main_exit;
        }
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
                        if (strcmp(&argv[idx][1], "wrapper") == 0)
                        {
                                --number_of_arguments;
                                ++idx;
                        }
                        else
                        {
                                char c;
                                c = argv[idx][1];
                                switch (c)
                                {
#if __START_IF_SELECTION__
#elif defined(_WIN32)
                                        case 'I': /* -I */
                                                if (argv[idx][strlen(argv[idx]) - 1] == '\\')
                                                {
                                                        argv[idx][strlen(argv[idx]) - 1] = '/';
                                                }
                                                break;
#endif
                                        case 'b': /* -b */
                                                bind_only = true;
                                                break;
                                        case 'c': /* -c */
                                                compile_only = true;
                                                break;
                                        case 'l': /* -l */
                                                link_only = true;
                                                break;
                                        case 'o': /* -o <output_filename> */
                                                --number_of_arguments;
                                                ++idx;
                                                output_filename = argv[idx];
                                                break;
                                        case 'x': /* -x <language_specification> */
                                                --number_of_arguments;
                                                ++idx;
                                                break;
                                        default:
                                                break;
                                }
                        }
                }
                else
                {
                        /* an option without "-" is a token */
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
        (void)bind_only;
        (void)link_only;
        (void)compile_only;

        /*
         * We specified --GCC and no --GNATBIND/--GNATLINK.
         */
        if (!compile_only)
        {
                fprintf(stderr, "%s: *** Error: gnat-wrapper needs GCC mode ('-c' switch).\n", program_name);
                goto main_exit;
        }

        /*
         * Setup GCC execution.
         */
        execute = execute_create();
        execute_flags_set(execute, EXEC_NO_EXIT_ERRORS);
        execute_filename_set(execute, gcc_executable);
        /* fill arguments (but not argv[0], which will be created by the */
        /* execute_exec() function) */
        for (idx = 1; idx < argc; ++idx)
        {
                execute_argv_add(execute, argv[idx]);
        }
        execute_envp_add(execute, "*"); /* standard envp */

        /*
         * Check for GNAT_WRAPPER_VERBOSE and GNAT_WRAPPER_GCC_BRIEFTEXT.
         */
        verbose = env_get("GNAT_WRAPPER_VERBOSE");
        if (verbose != NULL && strcmp(verbose, "Y") == 0)
        {
                /* __NOP__ */
        }
        else
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

        /*
         * Invalidate.
         */
        execute_destroy(execute);
        execute = NULL;

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



/*
 * gcc-wrapper.c
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
 * GCC_WRAPPER_ASSEMBLER_OUTPUT
 * GCC_WRAPPER_TIMESTAMP_FILENAME
 * SWEETADA_PATH
 * OBJECT_DIRECTORY
 */

#include "library.h"
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

/******************************************************************************
 * execute_setup()                                                            *
 *                                                                            *
 ******************************************************************************/
void
execute_setup(execute_t execute, int argc, char **argv)
{
        int idx;

        execute_filename_set(execute, argv[1]);
        /* fill arguments (but not argv[0], which will be created by the */
        /* execute_exec() function) */
        for (idx = 1; idx < (argc - 1); ++idx) /* - 1 because argv[1] is discarded */
        {
                execute_argv_add(execute, argv[idx + 1]); /* + 1 start from source argv[2] */
        }
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
         * Check requested executable filename.
         */
#if __START_IF_SELECTION__
#elif defined(_WIN32)
        if (
            strcmp(&argv[1][strlen(argv[1]) - 7], "cc1.exe") == 0 ||
            strcmp(&argv[1][strlen(argv[1]) - 9], "gnat1.exe") == 0
           )
#else
        if (
            strcmp(&argv[1][strlen(argv[1]) - 3], "cc1") == 0 ||
            strcmp(&argv[1][strlen(argv[1]) - 5], "gnat1") == 0
           )
#endif
        {
                cc1_or_gnat1 = true;
        }
#if __START_IF_SELECTION__
#elif defined(_WIN32)
        else if (strcmp(&argv[1][strlen(argv[1]) - 6], "as.exe") == 0)
#else
        else if (strcmp(&argv[1][strlen(argv[1]) - 2], "as") == 0)
#endif
        {
                as = true;
        }
#if __START_IF_SELECTION__
#elif defined(_WIN32)
        else if (strcmp(&argv[1][strlen(argv[1]) - 12], "collect2.exe") == 0)
#else
        else if (strcmp(&argv[1][strlen(argv[1]) - 8], "collect2") == 0)
#endif
        {
                collect2 = true;
        }
#if __START_IF_SELECTION__
#elif defined(_WIN32)
        else if (strcmp(&argv[1][strlen(argv[1]) - 11], "objcopy.exe") == 0)
#else
        else if (strcmp(&argv[1][strlen(argv[1]) - 7], "objcopy") == 0)
#endif
        {
                objcopy = true;
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
                        if      (cc1_or_gnat1 && strcmp(&argv[idx][1], "auxbase") == 0)
                        {
                                --number_of_arguments;
                                ++idx;
                        }
                        else if (cc1_or_gnat1 && strcmp(&argv[idx][1], "auxbase-strip") == 0)
                        {
                                --number_of_arguments;
                                ++idx;
                        }
                        else if (cc1_or_gnat1 && strcmp(&argv[idx][1], "dumpdir") == 0)
                        {
                                --number_of_arguments;
                                ++idx;
#if __START_IF_SELECTION__
#elif defined(_WIN32)
                                if (argv[idx][strlen(argv[idx]) - 1] == '\\')
                                {
                                        argv[idx][strlen(argv[idx]) - 1] = '/';
                                }
#endif
                        }
                        else if (cc1_or_gnat1 && strcmp(&argv[idx][1], "dumpbase") == 0)
                        {
                                --number_of_arguments;
                                ++idx;
                        }
                        else if (cc1_or_gnat1 && strcmp(&argv[idx][1], "dumpbase-ext") == 0)
                        {
                                --number_of_arguments;
                                ++idx;
                        }
                        else if (cc1_or_gnat1 && strcmp(&argv[idx][1], "imultilib") == 0)
                        {
                                --number_of_arguments;
                                ++idx;
                        }
                        else if (cc1_or_gnat1 && strcmp(&argv[idx][1], "iprefix") == 0)
                        {
                                --number_of_arguments;
                                ++idx;
                        }
                        else if (cc1_or_gnat1 && strcmp(&argv[idx][1], "isystem") == 0)
                        {
                                --number_of_arguments;
                                ++idx;
                        }
                        else if (cc1_or_gnat1 && strcmp(&argv[idx][1], "gnatG") == 0)
                        {
                                /* trigger generation of additional files */
                                gcc_gnatg_flag = true;
                        }
                        else if (cc1_or_gnat1 && strcmp(&argv[idx][1], "gnatO") == 0)
                        {
                                --number_of_arguments;
                                ++idx;
                        }
                        else if (cc1_or_gnat1 && strcmp(&argv[idx][1], "plugin") == 0)
                        {
                                --number_of_arguments;
                                ++idx;
                        }
#if __START_IF_SELECTION__
#elif defined(_WIN32)
                        else if (cc1_or_gnat1 && strncmp(&argv[idx][1], "fRTS=", 5) == 0)
                        {
                                if (argv[idx][strlen(argv[idx]) - 1] == '\\')
                                {
                                        argv[idx][strlen(argv[idx]) - 1] = '/';
                                }
                        }
#endif
                        else
                        {
                                char c;
                                c = argv[idx][1];
                                switch (c)
                                {
                                        case '-': /* "--" option */
                                                break;
                                        case 'D': /* -D <definition> */
                                                if (strcmp(&argv[idx][1], "D") == 0)
                                                {
                                                        --number_of_arguments;
                                                        ++idx;
                                                }
                                                break;
                                        case 'G': /* -G <number> */
                                                if (strcmp(&argv[idx][1], "G") == 0)
                                                {
                                                        --number_of_arguments;
                                                        ++idx;
                                                }
                                                break;
                                        case 'I': /* -I <include_directory> */
                                                --number_of_arguments;
                                                ++idx;
                                                break;
                                        case 'o': /* -o <output_filename> */
                                                --number_of_arguments;
                                                ++idx;
                                                output_filename = argv[idx];
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
        if (cc1_or_gnat1)
        {
                bool stdout_redirect;
                int stdout_fd;
                int stdout_current;
                stdout_redirect = false;
                execute = execute_create();
                execute_flags_set(execute, EXEC_NO_EXIT_ERRORS);
                execute_setup(execute, argc, argv);
                execute_envp_add(execute, "*"); /* standard envp */
                if (gcc_gnatg_flag)
                {
                        stdout_redirect = true;
                }
                if (stdout_redirect)
                {
                        const char *sweetada_path;
                        const char *object_directory;
                        char stdout_filename[PATH_MAX + 1];
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
                                if (strlen(stdout_filename) != 0)
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
                        if (strlen(stdout_filename) == 0)
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
                                log_printf(LOG_STDERR, "error open()ing \"%s\".", stdout_filename);
                                stdout_redirect = false;
                        }
                        else
                        {
                                stdout_current = dup(fileno(stdout));
                                dup2(stdout_fd, fileno(stdout));
                        }
                        lib_free((void *)object_directory);
                        object_directory = NULL;
                        lib_free((void *)sweetada_path);
                        sweetada_path = NULL;
                }
                /* execute */
                exit_status = execute_exec(execute);
                if (stdout_redirect)
                {
                        fflush(stdout);
                        close(stdout_fd);
                        dup2(stdout_current, fileno(stdout));
                        close(stdout_current);
                }
        }
        else if (as)
        {
                execute = execute_create();
                execute_flags_set(execute, EXEC_NO_EXIT_ERRORS);
                execute_setup(execute, argc, argv);
                execute_envp_add(execute, "*"); /* standard envp */
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
                        as_listing_string_size += strlen(as_listing_options);
                        as_listing_string_size += strlen(output_filename);
                        as_listing_string = lib_malloc(as_listing_string_size);
                        as_listing_string[0] = '\0';
                        strcat(as_listing_string, as_listing_options);
                        strcat(as_listing_string, "=");
                        strcat(as_listing_string, output_filename);
                        strcat(as_listing_string, ".lst");
                        execute_argv_add(execute, as_listing_string);
                }
                /* execute */
                exit_status = execute_exec(execute);
        }
        else if (collect2)
        {
                execute = execute_create();
                execute_flags_set(execute, EXEC_NO_EXIT_ERRORS);
                execute_setup(execute, argc, argv);
                execute_envp_add(execute, "*"); /* standard envp */
                /* execute */
                exit_status = execute_exec(execute);
        }
        else if (objcopy)
        {
                execute = execute_create();
                execute_flags_set(execute, EXEC_NO_EXIT_ERRORS);
                execute_setup(execute, argc, argv);
                execute_envp_add(execute, "*"); /* standard envp */
                /* execute */
                exit_status = execute_exec(execute);
        }
        else
        {
                fprintf(stderr, "%s: *** Error: executable not recognized.\n", program_name);
        }

        /*
         * Generate a timestamp output file which describes the output file.
         */
        if (as)
        {
                timestamp_filename = env_get("GCC_WRAPPER_TIMESTAMP_FILENAME");
                if (timestamp_filename != NULL && strlen(timestamp_filename) > 0)
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
        }

        /*
         * Invalidate.
         */
        execute_destroy(execute);
        execute = NULL;

main_exit:

        /*
         * Close logging.
         */
        log_close();

        /*
         * Cleanup.
         */
        lib_free((void *)as_listing_options);
        as_listing_string = NULL;
        lib_free((void *)as_listing_string);
        as_listing_string = NULL;
        lib_free((void *)timestamp_filename);
        timestamp_filename = NULL;

        exit(exit_status);
}


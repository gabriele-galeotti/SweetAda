
/*
 * exe-wrapper.c
 *
 * Copyright (C) 2020-2026 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

/*
 * Arguments:
 * $@ = executable command line
 *
 * Environment variables:
 * none
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

#define EXE_WRAPPER_VERSION "1.0"

struct switch_descriptor {
        const char *name;
        int         flags;
        };

#define EXE_WRAPPER     (1 << 0)
#define EXACT_MATCH     (1 << 1)
#define HAS_ARGUMENT    (1 << 2)
#define TRANSLATE_BS    (1 << 3)
#define OUTPUT_FILENAME (1 << 4)
#define GNAT_FLAG       (1 << 5)

static struct switch_descriptor switches[] = {
        { "-RTS=",                                      TRANSLATE_BS    },
        { "D",             EXACT_MATCH | HAS_ARGUMENT                   },
        { "D_exewrapper",                               EXE_WRAPPER     },
        { "G",             EXACT_MATCH | HAS_ARGUMENT                   },
        { "I",             EXACT_MATCH | HAS_ARGUMENT                   },
        { "I",                                          TRANSLATE_BS    },
        { "MF",            EXACT_MATCH | HAS_ARGUMENT                   },
        { "MQ",            EXACT_MATCH | HAS_ARGUMENT                   },
        { "MT",            EXACT_MATCH | HAS_ARGUMENT                   },
        { "auxbase",       EXACT_MATCH | HAS_ARGUMENT                   },
        { "auxbase-strip", EXACT_MATCH | HAS_ARGUMENT                   },
        { "c",             EXACT_MATCH                                  },
        { "dumpbase",      EXACT_MATCH | HAS_ARGUMENT                   },
        { "dumpbase-ext",  EXACT_MATCH | HAS_ARGUMENT                   },
        { "dumpdir",       EXACT_MATCH | HAS_ARGUMENT | TRANSLATE_BS    },
        { "gnatG",         EXACT_MATCH                | GNAT_FLAG       },
        { "gnatO",         EXACT_MATCH | HAS_ARGUMENT                   },
        { "imultilib",     EXACT_MATCH | HAS_ARGUMENT                   },
        { "iprefix",       EXACT_MATCH | HAS_ARGUMENT                   },
        { "isystem",       EXACT_MATCH | HAS_ARGUMENT                   },
        { "o",             EXACT_MATCH | HAS_ARGUMENT | OUTPUT_FILENAME },
        { "plugin",        EXACT_MATCH | HAS_ARGUMENT                   },
        { "x",             EXACT_MATCH | HAS_ARGUMENT                   },
        { NULL, 0 }
        };

/******************************************************************************
 * execute_setup()                                                            *
 *                                                                            *
 ******************************************************************************/
static int
execute_setup(execute_t execute, const char *executable_filename, int argc, char **argv, int idx_start)
{
        int idx;

        execute_filename_set(execute, executable_filename);

        /* fill arguments (but not argv[0], which will be created by the */
        /* execute_exec() function) */
        for (idx = idx_start; idx < argc; ++idx)
        {
                if (strncmp(argv[idx], "-D_exewrapper", 13) == 0)
                {
                        continue;
                }
                if (execute_argv_add(execute, argv[idx]) < 0)
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
        const char *input_filename;
        const char *output_filename;
        bool        error_flag;
        int         number_of_arguments; /* avoid modifying argc */
        bool        plain_token_flag;
        int         idx;
        execute_t   execute;
        const char *executable_filename;
        const char *timestamp_filename;
        const char *use_basename;
        const char *verbose;
        const char *brieftext;

        exit_status = EXIT_FAILURE;
        executable_filename = NULL;
        input_filename = NULL;
        (void)output_filename;
        output_filename = NULL;
        execute = NULL;
        timestamp_filename = NULL;
        use_basename = NULL;
        verbose = NULL;
        brieftext = NULL;

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
                fprintf(stdout, "%s: version %s\n", program_name, EXE_WRAPPER_VERSION);
                exit_status = EXIT_SUCCESS;
                goto main_exit;
        }

        /*
         * Argument parsing.
         */
        error_flag = false;
        number_of_arguments = argc;
        plain_token_flag = false;
        idx = 0;
        /* skip argv[0] */
        --number_of_arguments;
        ++idx;
        while (!error_flag && number_of_arguments > 0)
        {
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
                                                        argv[idx][STRING_LENGTH(argv[idx]) - 1] = '\0';
                                                }
#endif
                                        }
                                        if ((flags & OUTPUT_FILENAME) != 0)
                                        {
                                                output_filename = argv[idx];
                                        }
                                        if ((flags & EXE_WRAPPER) != 0)
                                        {
                                                if (strncmp(&argv[idx][13], "executable=", 11) == 0)
                                                {
                                                        if (executable_filename == NULL)
                                                        {
                                                                executable_filename = lib_strdup(&argv[idx][13 + 11]);
                                                        }
                                                        else
                                                        {
                                                                fprintf(stderr, "%s: *** Error: duplicate argument 'executable'.\n", program_name);
                                                        }
                                                }
                                                else if (strncmp(&argv[idx][13], "verbose=", 8) == 0)
                                                {
                                                        if (verbose == NULL)
                                                        {
                                                                verbose = lib_strdup(&argv[idx][13 + 8]);
                                                        }
                                                        else
                                                        {
                                                                fprintf(stderr, "%s: *** Error: duplicate argument 'verbose'.\n", program_name);
                                                                error_flag = true;
                                                        }
                                                }
                                                else if (strncmp(&argv[idx][13], "brieftext=", 10) == 0)
                                                {
                                                        if (brieftext == NULL)
                                                        {
                                                                brieftext = lib_strdup(&argv[idx][13 + 10]);
                                                        }
                                                        else
                                                        {
                                                                fprintf(stderr, "%s: *** Error: duplicate argument 'brieftext'.\n", program_name);
                                                                error_flag = true;
                                                        }
                                                }
                                                else if (strncmp(&argv[idx][13], "tmfname=", 8) == 0)
                                                {
                                                        if (timestamp_filename == NULL)
                                                        {
                                                                timestamp_filename = lib_strdup(&argv[idx][13 + 8]);
                                                        }
                                                        else
                                                        {
                                                                fprintf(stderr, "%s: *** Error: duplicate argument 'tmfname'.\n", program_name);
                                                                error_flag = true;
                                                        }
                                                }
                                                else if (strncmp(&argv[idx][13], "basename=", 9) == 0)
                                                {
                                                        if (use_basename == NULL)
                                                        {
                                                                use_basename = lib_strdup(&argv[idx][13 + 9]);
                                                        }
                                                        else
                                                        {
                                                                fprintf(stderr, "%s: *** Error: duplicate argument 'basename'.\n", program_name);
                                                                error_flag = true;
                                                        }
                                                }
                                                else
                                                {
                                                                fprintf(stderr, "%s: *** Error: unknown argument for 'exewrapper'.\n", program_name);
                                                                error_flag = true;
                                                }
                                        }
                                        break;
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
                if (error_flag)
                {
                        break;
                }
                --number_of_arguments;
                ++idx;
        }
        if (error_flag)
        {
                exit_status = EXIT_FAILURE;
                goto main_exit;
        }

        /*
         * Check if an executable was provided.
         */
        if (executable_filename == NULL || STRING_LENGTH(executable_filename) == 0)
        {
                if (executable_filename == NULL || STRING_LENGTH(executable_filename) == 0)
                {
                        goto main_exit;
                }
        }

        /*
         * Setup execution.
         */
        if ((execute = execute_create()) == NULL)
        {
                fprintf(stderr, "%s: *** Error: execute_create().\n", program_name);
                goto main_exit;
        }
        if (execute_setup(execute, executable_filename, argc, argv, 1) < 0)
        {
                fprintf(stderr, "%s: *** Error: execute_setup().\n", program_name);
                goto exec_end;
        }
        execute_flags_set(execute, EXEC_USE_PATH | EXEC_NO_EXIT_ERRORS);

        /*
         * Check for verbosity.
         */
        if (verbose == NULL || (verbose != NULL && strcmp(verbose, "Y") != 0))
        {
                /*
                 * No verbosity, use a brief text.
                 */
                if (brieftext != NULL && STRING_LENGTH(brieftext) > 0)
                {
                        /*
                         * Print brief text with input filename.
                         */
                        fprintf(stdout, "%s %s\n", brieftext, file_basename_simple(input_filename));
                }
        }

        /*
         * Execution.
         */
        exit_status = execute_exec(execute);

        /*
         * Generate a timestamp file.
         */
        if (timestamp_filename != NULL && STRING_LENGTH(timestamp_filename) > 0)
        {
                const char *filename;
                if (use_basename != NULL && strcmp(use_basename, "Y") == 0)
                {
                        filename = file_basename_simple(timestamp_filename);
                }
                else
                {
                        filename = timestamp_filename;
                }
                if (execute_child_exit_status(execute) == 0)
                {
                        FILE *fp;
                        fp = fopen(filename, "w");
                        if (fp == NULL)
                        {
                                fprintf(stderr, "%s: *** Error: unable to open \"%s\".\n", program_name, filename);
                                exit_status = EXIT_FAILURE;
                        }
                        else
                        {
                                if (input_filename != NULL)
                                {
                                        fprintf(fp, "%s\n", input_filename);
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
        lib_free((void *)executable_filename);
        executable_filename = NULL;
        lib_free((void *)verbose);
        verbose = NULL;
        lib_free((void *)brieftext);
        brieftext = NULL;
        lib_free((void *)timestamp_filename);
        timestamp_filename = NULL;
        lib_free((void *)use_basename);
        use_basename = NULL;

        exit(exit_status);
}


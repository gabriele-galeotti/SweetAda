
/*
 * elftool.c - Utility to work with ELF object files.
 *
 * Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

/*
 * Arguments:
 * $1 = object file
 * $2 = command
 * $3 = argument ...
 * commands:
 * dumpsections
 * objectsizes
 * findsymbol=<symbol>
 * setgdbstubflag=<value>
 *
 * Environment variables:
 * VERBOSE
 */

#include "library.h"
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <libelf/libelf.h>
#include <libelf/gelf.h>
#include "elftool.h"

/******************************************************************************
 *                                                                            *
 ******************************************************************************/

static Application_t application;

#define TAB_SIZE 8

/******************************************************************************
 * compute_tabs()                                                             *
 *                                                                            *
 ******************************************************************************/
static int
compute_tabs(const char *string, size_t maximum_string_length)
{
        int    ntabs;
        size_t string_length;

        string_length = strlen(string);

        if (string_length < maximum_string_length)
        {
                ntabs = 0;
                while (string_length <= maximum_string_length)
                {
                        string_length = ((string_length + TAB_SIZE) / TAB_SIZE) * TAB_SIZE;
                        ++ntabs;
                }
        }
        else
        {
                ntabs = 1;
        }

        return ntabs;
}

/******************************************************************************
 * fprint_tabstospaces()                                                      *
 *                                                                            *
 ******************************************************************************/
static void
fprint_tabstospaces(FILE *fp, const char *input_string)
{
        char output_string[1024];
        int  idx1;
        int  idx2;
        char c;

        idx1 = 0;
        idx2 = 0;
        do
        {
                c = input_string[idx1];
                if (c == '\t')
                {
                        int nspaces;
                        int idx3;
                        nspaces = TAB_SIZE - (idx2 % TAB_SIZE);
                        if (nspaces == 0)
                        {
                                nspaces = TAB_SIZE;
                        }
                        for (idx3 = 0; idx3 < nspaces; ++idx3)
                        {
                                output_string[idx2] = ' ';
                                ++idx2;
                        }
                }
                else
                {
                        output_string[idx2] = c;
                        ++idx2;
                }
                ++idx1;
        } while (c != '\0');

        fprintf(fp, output_string);
}

/******************************************************************************
 * shstrtab_getname()                                                         *
 *                                                                            *
 * Return a string from the ".shstrtab" section.                              *
 ******************************************************************************/
static char *
shstrtab_getname(size_t string_index)
{
        return elf_strptr(application.pelf, application.index_shstrtab, string_index);
}

/******************************************************************************
 * strtab_getname()                                                           *
 *                                                                            *
 * Return a string from the ".strtab" section.                                *
 ******************************************************************************/
static char *
strtab_getname(size_t string_index)
{
        return elf_strptr(application.pelf, application.index_strtab, string_index);
}

/******************************************************************************
 * command_dumpsections()                                                     *
 *                                                                            *
 ******************************************************************************/
static int
command_dumpsections(void)
{
        Elf_Scn   *pscn;
        GElf_Shdr  shdr;
        int        nsections;
        int        nsections_ndigits;
        char       printf_nsections_format[16];
        size_t     max_string_length;
        size_t     string_length;
        int        ntabs;
        char       tmp_string_buffer[1024];
        char       output_string_buffer[1024];

        /* find the number of sections and the longest section name */
        pscn = NULL;
        nsections = 0;
        max_string_length = strlen("Name");
        while ((pscn = elf_nextscn(application.pelf, pscn)) != NULL)
        {
                char *name;
                if (gelf_getshdr(pscn, &shdr) != &shdr)
                {
                        log_printf(LOG_STDERR | LOG_FILE, "*** Error: gelf_getshdr(): %s.", elf_errmsg(-1));
                        return -1;
                }
                if ((name = shstrtab_getname(shdr.sh_name)) == NULL)
                {
                        log_printf(LOG_STDERR | LOG_FILE, "*** Error: shstrtab_getname(): %s.", elf_errmsg(-1));
                        return -1;
                }
                ++nsections;
                string_length = strlen(name);
                if (string_length > max_string_length)
                {
                        max_string_length = string_length;
                }
        }

        output_string_buffer[0] = '\0';
        sprintf(tmp_string_buffer, "%s\t%s", "Index", "Name");
        strcat(output_string_buffer, tmp_string_buffer);
        ntabs = compute_tabs("Name", max_string_length);
        while (ntabs-- > 0)
        {
                sprintf(tmp_string_buffer, "\t");
                strcat(output_string_buffer, tmp_string_buffer);
        }
        switch (application.elf_class)
        {
                case ELFCLASS32:
                        sprintf(tmp_string_buffer, "%s\t\t%s\n", "Address", "Size");
                        strcat(output_string_buffer, tmp_string_buffer);
                        break;
                case ELFCLASS64:
                        sprintf(tmp_string_buffer, "%s\t\t\t%s\n", "Address", "Size");
                        strcat(output_string_buffer, tmp_string_buffer);
                        break;
                default:
                        break;
        }
        fprint_tabstospaces(stdout, output_string_buffer);

        /* synthesize the format string to print the section number */
        if (nsections < 10)
        {
                nsections_ndigits = 1;
        }
        else if (nsections < 100)
        {
                nsections_ndigits = 2;
        }
        else if (nsections < 1000)
        {
                nsections_ndigits = 3;
        }
        else
        {
                nsections_ndigits = 6;
        }
#if __START_IF_SELECTION__
#elif defined(_WIN32)
        /* e.g., 2 digits: "%02I64u:\t%s" */
        sprintf(printf_nsections_format, "%%0%1dI64u:\t%%s", nsections_ndigits);
#elif defined(__APPLE__)
        /* e.g., 2 digits: "%02lu:\t%s" */
        sprintf(printf_nsections_format, "%%0%1dlu:\t%%s", nsections_ndigits);
#else
        /* e.g., 2 digits: "%02lu:\t%s" */
        sprintf(printf_nsections_format, "%%0%1dlu:\t%%s", nsections_ndigits);
#endif

        pscn = NULL;
        while ((pscn = elf_nextscn(application.pelf, pscn)) != NULL)
        {
                Elf_Data *pdata;
                size_t d_size;
                char *name;
                output_string_buffer[0] = '\0';
                pdata = elf_getdata(pscn, NULL);
                if (pdata != NULL)
                {
                        d_size = pdata->d_size;
                }
                else
                {
                        d_size = 0;
                }
                if (gelf_getshdr(pscn, &shdr) != &shdr)
                {
                        log_printf(LOG_STDERR | LOG_FILE, "*** Error: gelf_getshdr(): %s.", elf_errmsg(-1));
                        return -1;
                }
                if ((name = shstrtab_getname(shdr.sh_name)) == NULL)
                {
                        log_printf(LOG_STDERR | LOG_FILE, "*** Error: shstrtab_getname(): %s.", elf_errmsg(-1));
                        return -1;
                }
                sprintf(tmp_string_buffer, printf_nsections_format, elf_ndxscn(pscn), name);
                strcat(output_string_buffer, tmp_string_buffer);
                ntabs = compute_tabs(name, max_string_length);
                while (ntabs-- > 0)
                {
                        sprintf(tmp_string_buffer, "\t");
                        strcat(output_string_buffer, tmp_string_buffer);
                }
                switch (application.elf_class)
                {
                        case ELFCLASS32:
                                sprintf(
                                        tmp_string_buffer,
#if __START_IF_SELECTION__
#elif defined(_WIN32)
                                        "0x%08I64X\t0x%08I64X\n",
#elif defined(__APPLE__)
                                        "0x%08llX\t0x%08lX\n",
#else
                                        "0x%08lX\t0x%08lX\n",
#endif
                                        shdr.sh_addr,
                                        d_size
                                        );
                                strcat(output_string_buffer, tmp_string_buffer);
                                fprint_tabstospaces(stdout, output_string_buffer);
                                break;
                        case ELFCLASS64:
                                sprintf(
                                        tmp_string_buffer,
#if __START_IF_SELECTION__
#elif defined(_WIN32)
                                        "0x%016I64X\t0x%016I64X\n",
#elif defined(__APPLE__)
                                        "0x%016llX\t0x%016lX\n",
#else
                                        "0x%016lX\t0x%016lX\n",
#endif
                                        shdr.sh_addr,
                                        d_size
                                        );
                                strcat(output_string_buffer, tmp_string_buffer);
                                fprint_tabstospaces(stdout, output_string_buffer);
                                break;
                        default:
                                break;
                }
        }

        return 0;
}

/******************************************************************************
 * command_objectsizes()                                                      *
 *                                                                            *
 ******************************************************************************/
static int
command_objectsizes(void)
{
        Elf_Scn   *pscn;
        GElf_Shdr  shdr;
        size_t     symtab_nentries;
        Elf_Data  *pdata;
        size_t     n;
        GElf_Sym   symbol;
        GElf_Sym  *psymbol;

        /* work on .symtab */
        pscn = elf_getscn(application.pelf, application.index_symtab);
        gelf_getshdr(pscn, &shdr);
        //fprintf(stdout, ".symtab size:    %u\n", shdr.sh_size);
        //fprintf(stdout, ".symtab address: %lX\n", shdr.sh_addr);

        symtab_nentries = shdr.sh_size / shdr.sh_entsize;

        pdata = NULL;
        pdata = elf_getdata(pscn, pdata);
        //fprintf(stdout, ".symtab data size: 0x%lX\n", pdata->d_size);

        n = 0;
        while (n < symtab_nentries)
        {
                // compute manually
                //psymbol = (GElf_Sym *)((char *)pdata->d_buf + sizeof(GElf_Sym) * n);
                // with libelf appropriate function
                psymbol = gelf_getsym(pdata, n, &symbol);
                if (psymbol->st_name != 0)
                {
                        fprintf(
                                stdout,
#if __START_IF_SELECTION__
#elif defined(_WIN32)
                                "value: 0x%08I64X size: 0x%08I64X info: 0x%02X name: %s\n",
#elif defined(__APPLE__)
                                "value: 0x%0llX size: 0x%08llX info: 0x%02X name: %s\n",
#else
                                "value: 0x%08lX size: 0x%08lX info: 0x%02X name: %s\n",
#endif
                                psymbol->st_value,
                                psymbol->st_size,
                                psymbol->st_info,
                                strtab_getname(psymbol->st_name)
                                );
                }
                else
                {
                        //fprintf(stdout, "name: -\n");
                }
                ++n;
        }

        return 0;
}

/******************************************************************************
 * command_findsymbol()                                                       *
 *                                                                            *
 ******************************************************************************/
static int
command_findsymbol(void)
{
        Elf_Scn   *pscn;
        GElf_Shdr  shdr;

        /* work on .symtab */

        if (application.index_symtab == (size_t)-1)
        {
                log_printf(LOG_STDERR | LOG_FILE, "*** Error: no .symtab section found.");
                return -1;
        }

        pscn = elf_getscn(application.pelf, application.index_symtab);
        gelf_getshdr(pscn, &shdr);
        {
                size_t symtab_nentries;
                Elf_Data *pdata;
                size_t n;
                GElf_Sym symbol;
                GElf_Sym *psymbol;
                //fprintf(stdout, ".symtab size:    %u\n", shdr.sh_size);
                //fprintf(stdout, ".symtab address: %lX\n", shdr.sh_addr);
                symtab_nentries = shdr.sh_size / shdr.sh_entsize;
                pdata = NULL;
                pdata = elf_getdata(pscn, pdata);
                //fprintf(stdout, ".symtab data size: 0x%lX\n", pdata->d_size);
                n = 0;
                while (n < symtab_nentries)
                {
                        // compute manually
                        //psymbol = (GElf_Sym *)((char *)pdata->d_buf + sizeof(GElf_Sym) * n);
                        // with libelf specific function
                        psymbol = gelf_getsym(pdata, n, &symbol);
                        if (psymbol->st_name != 0)
                        {
                                //fprintf(stdout, "value: 0x%08lX name: %s\n", psymbol->st_value, strtab_getname(psymbol->st_name));
                                if (strcmp(application.symbol_name, strtab_getname(psymbol->st_name)) == 0)
                                {
                                        application.symbol_value = (uint64_t)psymbol->st_value;
                                        return 0;
                                }
                        }
                        else
                        {
                                //fprintf(stdout, "name: -\n");
                        }
                        ++n;
                }
        }

        return -1;
}

/******************************************************************************
 * find_gdbstub_flag()                                                        *
 *                                                                            *
 * Helper function for command_setgdbstubflag().                              *
 ******************************************************************************/
static bool
find_gdbstub_flag(uint64_t *pgdbstub_flag)
{
        Elf_Scn   *pscn;
        GElf_Shdr  shdr;

        /* work on .symtab */

        if (application.index_symtab == (size_t)-1)
        {
                log_printf(LOG_STDERR | LOG_FILE, "*** Error: no .symtab section found.");
                goto find_gdbstub_flag_exit;
        }

        pscn = elf_getscn(application.pelf, application.index_symtab);
        gelf_getshdr(pscn, &shdr);
        {
                size_t symtab_nentries;
                Elf_Data *pdata;
                size_t n;
                GElf_Sym symbol;
                GElf_Sym *psymbol;
                //fprintf(stdout, ".symtab size:    %u\n", shdr.sh_size);
                //fprintf(stdout, ".symtab address: %lX\n", shdr.sh_addr);
                symtab_nentries = shdr.sh_size / shdr.sh_entsize;
                pdata = NULL;
                pdata = elf_getdata(pscn, pdata);
                //fprintf(stdout, ".symtab data size: 0x%lX\n", pdata->d_size);
                n = 0;
                while (n < symtab_nentries)
                {
                        // compute manually
                        //psymbol = (GElf_Sym *)((char *)pdata->d_buf + sizeof(GElf_Sym) * n);
                        // with libelf specific function
                        psymbol = gelf_getsym(pdata, n, &symbol);
                        if (psymbol->st_name != 0)
                        {
                                //fprintf(stdout, "value: 0x%08lX name: %s\n", psymbol->st_value, strtab_getname(psymbol->st_name));
                                if (strcmp("_gdbstub_enable_flag", strtab_getname(psymbol->st_name)) == 0)
                                {
                                        *pgdbstub_flag = (uint64_t)psymbol->st_value;
                                        return true;
                                }
                        }
                        else
                        {
                                //fprintf(stdout, "name: -\n");
                        }
                        ++n;
                }
        }

find_gdbstub_flag_exit:

        return false;
}

/******************************************************************************
 * command_setgdbstubflag()                                                   *
 *                                                                            *
 ******************************************************************************/
static int
command_setgdbstubflag(void)
{
        Elf_Scn   *pscn;
        GElf_Shdr  shdr;
        uint64_t   gdbstub_flag; /* offset into text section */

        if (find_gdbstub_flag(&gdbstub_flag))
        {
                /* _gdbstub_flag is always resident in the .text section */
                pscn = elf_getscn(application.pelf, application.index_text);
                if (gelf_getshdr(pscn, &shdr) != &shdr)
                {
                        log_printf(LOG_STDERR | LOG_FILE, "*** Error: gelf_getshdr(): %s.", elf_errmsg(-1));
                        return -1;
                }
                else
                {
                        Elf_Data *pdata;
                        size_t object_text_offset;
                        uint8_t *pobject;
                        uint8_t object_value;
                        //uint8_t given_value;
                        pdata = elf_getdata(pscn, NULL);
                        if (pdata != NULL)
                        {
                                object_text_offset = (size_t)(gdbstub_flag - shdr.sh_addr);
                                pobject = (uint8_t *)pdata->d_buf + object_text_offset;
                                object_value = *pobject;
                                //fprintf(stdout, "0x%lX: 0x%02X\n", object_text_offset, object_value);
                                //given_value = strtoul(argv[3], NULL, 16);
                                //if (object_value != given_value)
                                if (object_value != application.gdbstub_flag_value)
                                {
                                        *pobject = application.gdbstub_flag_value;
                                        elf_flagscn(pscn, ELF_C_SET, ELF_F_DIRTY);
                                        application.flag_update = true;
                                }
                        }
                        else
                        {
                                log_printf(LOG_STDERR | LOG_FILE, "*** Error: elf_getdata(): %s.", elf_errmsg(-1));
                                return -1;
                        }
                }
        }
        else
        {
                /* it is not an error because the kernel could be built */
                /* without the definition of this symbol, so exit cleanly */
                if (application.flag_verbose)
                {
                        log_printf(LOG_STDOUT | LOG_FILE, "symbol \"_gdbstub_enable_flag\" not found, skipping.");
                }
        }

        return 0;
}

/******************************************************************************
 * update_elf()                                                               *
 *                                                                            *
 ******************************************************************************/
static int
update_elf(void)
{
        if (elf_update(application.pelf, ELF_C_WRITE) < 0)
        {
                log_printf(LOG_STDERR | LOG_FILE, "*** Error: elf_update(): %s.", elf_errmsg(-1));
                return -1;
        }
        if (application.flag_verbose)
        {
                log_printf(LOG_STDOUT | LOG_FILE, "done updating ELF file \"%s\".", application.input_filename);
        }

        return 0;
}

/******************************************************************************
 * process_arguments()                                                        *
 *                                                                            *
 ******************************************************************************/
static int
process_arguments(int argc, char **argv, Application_t *p, const char **error_message)
{
        bool error_flag;
        int  number_of_arguments;
        bool plain_token_flag;
        int  idx;

        error_flag = false;
        number_of_arguments = argc;
        plain_token_flag = false;
        idx = 0;

        if (number_of_arguments > 0)
        {
                --number_of_arguments;
                ++idx;
        }

        while (!error_flag && number_of_arguments > 0)
        {
                --number_of_arguments;
                if (argv[idx][0] == '-')
                {
                        char c;
                        if (strlen(argv[idx]) != 2)
                        {
                                error_flag = true;
                                if (error_message != NULL)
                                {
                                        *error_message = "bad switch";
                                }
                        }
                        c = argv[idx][1];
                        switch (c)
                        {
                                case 'c':
                                        --number_of_arguments;
                                        ++idx;
                                        if (strcmp(argv[idx], "dumpsections") == 0)
                                        {
                                                p->command = COMMAND_DUMPSECTIONS;
                                        }
                                        else if (strcmp(argv[idx], "objectsizes") == 0)
                                        {
                                                p->command = COMMAND_OBJECTSIZES;
                                        }
                                        /* strlen("findsymbol=") = 11 */
                                        else if (strncmp(argv[idx], "findsymbol=", 11) == 0)
                                        {
                                                p->command = COMMAND_FINDSYMBOL;
                                                p->symbol_name = argv[idx] + 11;
                                        }
                                        /* strlen("setgdbstubflag=") = 15 */
                                        else if (strncmp(argv[idx], "setgdbstubflag=", 15) == 0)
                                        {
                                                p->command = COMMAND_SETGDBSTUBFLAG;
                                                p->gdbstub_flag_value = (uint8_t)strtoul(argv[idx] + 15, NULL, 16);
                                        }
                                        else
                                        {
                                                error_flag = true;
                                                if (error_message != NULL)
                                                {
                                                        *error_message = "unknown command";
                                                }
                                        }
                                        break;
                                default:
                                        error_flag = true;
                                        if (error_message != NULL)
                                        {
                                                *error_message = "unknown switch";
                                        }
                                        break;
                        }
                }
                else
                {
                        if (plain_token_flag == false)
                        {
                                plain_token_flag = true;
                                p->input_filename = argv[idx];
                        }
                        else
                        {
                                error_flag = true;
                                if (error_message != NULL)
                                {
                                        *error_message = "more than one filename specified";
                                }
                        }
                }
                if (!error_flag)
                {
                        ++idx;
                }
        }

        return error_flag ? -1 : 0;
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
        int         fd;
        char       *verbose_string;
        const char *process_arguments_error_message;
        Elf_Scn    *pscn;
        GElf_Shdr   shdr;

        exit_status = EXIT_FAILURE;
        fd = -1;

        application.input_filename = NULL;
        application.command        = COMMAND_NONE;
        application.pelf           = NULL;
        application.index_shstrtab = (size_t)-1;
        application.index_text     = (size_t)-1;
        application.index_strtab   = (size_t)-1;
        application.index_symtab   = (size_t)-1;
        application.flag_verbose   = false;
        application.flag_update    = false;

        /*
         * Extract the program name.
         */
        strcpy(program_name, file_basename_simple(argv[0]));

        /*
         * Initialize logging.
         */
        log_init(program_name, NULL, NULL);
        log_mode_set(LOG_STDOUT | LOG_STDERR);

        /*
         * Verbose mode.
         */
        verbose_string = (char *)env_get("VERBOSE");
        if (verbose_string != NULL)
        {
                if (strcmp(verbose_string, "Y") == 0)
                {
                        application.flag_verbose = true;
                }
                lib_free(verbose_string);
                verbose_string = NULL;
        }

        /*
         * Argument processing.
         */
        if (process_arguments(argc, argv, &application, &process_arguments_error_message) < 0)
        {
                log_printf(LOG_STDERR | LOG_FILE, "*** Error: %s.", process_arguments_error_message);
                goto main_exit;
        }
        if (application.input_filename == NULL)
        {
                log_printf(LOG_STDERR | LOG_FILE, "*** Error: no input file.");
                goto main_exit;
        }
        if (application.command == COMMAND_NONE)
        {
                log_printf(LOG_STDERR | LOG_FILE, "*** Error: no command supplied.");
                goto main_exit;
        }

        /*
         * Open input file.
         */
#if __START_IF_SELECTION__
#elif defined(_WIN32)
        fd = open(application.input_filename, O_RDWR | O_BINARY);
#elif defined(__APPLE__) || defined(__linux__)
        fd = open(application.input_filename, O_RDWR);
#endif
        if (fd < 0)
        {
                log_printf(LOG_STDERR | LOG_FILE, "*** Error: open(): %s: %s.", application.input_filename, strerror(errno));
                goto main_exit;
        }

        /*
         * Initialize libelf.
         */
        if (elf_version(EV_CURRENT) == EV_NONE)
        {
                log_printf(LOG_STDERR | LOG_FILE, "*** Error: elf_version(): %s.", elf_errmsg(-1));
                goto main_exit;
        }

        /*
         * Build the ELF descriptor.
         */
        application.pelf = elf_begin(fd, ELF_C_RDWR, NULL);
        if (application.pelf == NULL)
        {
                log_printf(LOG_STDERR | LOG_FILE, "*** Error: elf_begin(): %s.", elf_errmsg(-1));
                goto main_exit;
        }

        if (elf_flagelf(application.pelf, ELF_C_SET, ELF_F_LAYOUT) != ELF_F_LAYOUT)
        {
                log_printf(LOG_STDERR | LOG_FILE, "*** Error: elf_flagelf(): %s.", elf_errmsg(-1));
                goto main_exit;
        }

        application.elf_class = gelf_getclass(application.pelf);
        if (application.elf_class == ELFCLASSNONE)
        {
                log_printf(LOG_STDERR | LOG_FILE, "*** Error: wrong ELF class.");
                goto main_exit;
        }

        /*
         * Read essential informations from input file.
         */
        if (elf_getshdrstrndx(application.pelf, &application.index_shstrtab) != 0)
        {
                log_printf(LOG_STDERR | LOG_FILE, "*** Error: elf_getshdrstrndx(): %s.", elf_errmsg(-1));
                goto main_exit;
        }
        pscn = NULL;
        while ((pscn = elf_nextscn(application.pelf, pscn)) != NULL)
        {
                char *name;
                if (gelf_getshdr(pscn, &shdr) != &shdr)
                {
                        log_printf(LOG_STDERR | LOG_FILE, "*** Error: gelf_getshdr(): %s.", elf_errmsg(-1));
                        goto main_exit;
                }
                if ((name = shstrtab_getname(shdr.sh_name)) == NULL)
                {
                        log_printf(LOG_STDERR | LOG_FILE, "*** Error: shstrtab_getname(): %s.", elf_errmsg(-1));
                        goto main_exit;
                }
                //fprintf(stdout, "Section: %d %s\n", elf_ndxscn(pscn), name);
                /* ok, interesting section indexes are memorized */
                if (strcmp(name, ".text") == 0)
                {
                        application.index_text = elf_ndxscn(pscn);
                }
                else if (strcmp(name, ".strtab") == 0)
                {
                        application.index_strtab = elf_ndxscn(pscn);
                }
                else if (strcmp(name, ".symtab") == 0)
                {
                        application.index_symtab = elf_ndxscn(pscn);
                }
        }

        /*
         * Process command.
         */
        switch (application.command)
        {
                case COMMAND_DUMPSECTIONS:
                        if (command_dumpsections() < 0)
                        {
                                goto main_exit;
                        }
                        break;
                case COMMAND_OBJECTSIZES:
                        if (command_objectsizes() < 0)
                        {
                                goto main_exit;
                        }
                        break;
                case COMMAND_FINDSYMBOL:
                        if (command_findsymbol() < 0)
                        {
                                goto main_exit;
                        }
                        switch (application.elf_class)
                        {
                                case ELFCLASS32:
                                        fprintf(
                                                stdout,
#if __START_IF_SELECTION__
#elif defined(_WIN32)
                                                "0x%08I64X\n",
#elif defined(__APPLE__)
                                                "0x%08X\n",
#else
                                                "0x%08X\n",
#endif
                                                (uint32_t)application.symbol_value
                                                );
                                        break;
                                case ELFCLASS64:
                                        fprintf(
                                                stdout,
#if __START_IF_SELECTION__
#elif defined(_WIN32)
                                                "0x%016I64X\n",
#elif defined(__APPLE__)
                                                "0x%016llX\n",
#else
                                                "0x%016lX\n",
#endif
                                                application.symbol_value
                                                );
                                default:
                                        break;
                        }
                        break;
                case COMMAND_SETGDBSTUBFLAG:
                        if (command_setgdbstubflag() < 0)
                        {
                                goto main_exit;
                        }
                        break;
                default:
                        /* __DNO__ */
                        break;
        }

        if (application.flag_update)
        {
                if (update_elf() < 0)
                {
                        goto main_exit;
                }
        }

        exit_status = EXIT_SUCCESS;

main_exit:

        if (application.pelf != NULL)
        {
                elf_end(application.pelf);
        }

        if (fd >= 0)
        {
                close(fd);
        }

        /*
         * Close logging.
         */
        log_close();

        exit(exit_status);
}


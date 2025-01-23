
/*
 * elftool.c
 *
 * Copyright (C) 2020-2025 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

/*
 * Arguments:
 * $1 = -c | -v
 * if $1 = "-c":
 * $2 = command
 * $3 = ELF filename
 * commands:
 * dumpsections
 * sectionvaddr=<section>
 * sectionsize=<section>
 * findsymbol=<symbol>
 * setdebugflag=<value>
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

#include "elf.h"
#include "library.h"

/******************************************************************************
 * Private definitions.                                                       *
 ******************************************************************************/

/******************************************************************************
 *                                                                            *
 *                                                                            *
 * libelf - start                                                             *
 *                                                                            *
 *                                                                            *
 ******************************************************************************/

typedef enum {
        NONE = 0,
        AR,
        COFF,
        ELF
        } Filetype_t;

typedef struct _Elf_Scn {
        union {
                Elf64_Shdr u_shdr64;
                Elf32_Shdr u_shdr32;
                } s_uhdr;
        } Elf_Scn_t;

typedef struct _Elf_Data {
        void   *d_buf;
        size_t  d_size;
        } Elf_Data_t;

typedef struct _Elf {
        int           fd;                       /* file descriptor */
        size_t        idlen;                    /* identifier size */
        unsigned int  class;                    /* ELF class */
        uint8_t      *data;                     /* file/member data */
        size_t        base;                     /* base */
        unsigned int  encoding;                 /* ELF data encoding */
        unsigned int  version;                  /* ELF version */
        uint8_t      *ehdr;                     /* ELF header */
        off_t         phoff;
        off_t         shoff;
        size_t        shnum;                    /* number of section headers */
        size_t        shentsize;
        int           shstrndx;
        off_t         scn_shstrtab_offset;
        off_t         scn_strtab_offset;
        off_t         scn_symtab_offset;
        size_t        scn_symtab_size;
        off_t         scn_text_offset;
        uint64_t      scn_text_addr;
        } Elf_t;

enum {
        ERROR_NOERROR,
        ERROR_UNKNOWN_ERROR,
        ERROR_UNIMPLEMENTED,
        ERROR_ARGUMENT,
        ERROR_IO,
        ERROR_NOMEM,
        ERROR_UNKNOWN_CLASS,
        ERROR_NOSUCHSCN
        };

/******************************************************************************
 *                                                                            *
 *                                                                            *
 * libelf - end                                                               *
 *                                                                            *
 *                                                                            *
 ******************************************************************************/

#define ELFTOOL_VERSION "1.0"

typedef struct {
        const char *input_filename;
        int         command;
        Elf_t      *pelf;
        bool        endianness_swap;
        size_t      scn_max_string_length;
        const char *symbol_name;
        uint64_t    symbol_value;
        uint8_t     debug_flag_value;
        } Application_t;

static Application_t application;

#define TAB_SIZE 8
static char tabspaces[TAB_SIZE + 1];

uint16_t SWAP16(uint16_t x) { if (application.endianness_swap) { return swap16(x); } return x; }
uint32_t SWAP32(uint32_t x) { if (application.endianness_swap) { return swap32(x); } return x; }
uint64_t SWAP64(uint64_t x) { if (application.endianness_swap) { return swap64(x); } return x; }

#define COMMAND_NONE         0
#define COMMAND_VERSION      1
#define COMMAND_DUMPSECTIONS 2
#define COMMAND_SECTIONVADDR 3
#define COMMAND_SECTIONSIZE  4
#define COMMAND_FINDSYMBOL   5
#define COMMAND_SETDEBUGFLAG 6

#define SECTION_VADDR 1
#define SECTION_SIZE  2

#define ERROR_ERROR     -1
#define ERROR_NO_SYMBOL -2

/******************************************************************************
 * print_value()                                                              *
 *                                                                            *
 ******************************************************************************/
static void
print_value(void)
{
        switch (application.pelf->class)
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
}

/******************************************************************************
 * compute_tabs()                                                             *
 *                                                                            *
 ******************************************************************************/
static int
compute_tabs(const char *string, size_t maximum_string_length)
{
        int    ntabs;
        size_t string_length;

        string_length = STRING_LENGTH(string);

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
 * fprintf_tab2spaces()                                                       *
 *                                                                            *
 ******************************************************************************/
static void
fprintf_tab2spaces(FILE *fp, const char *input_string)
{
        int  idx;
        int  idx_out;
        char c;

        idx = 0;
        idx_out = 0;
        while ((c = input_string[idx]) != '\0')
        {
                if (c == '\t')
                {
                        int nspaces;
                        nspaces = TAB_SIZE - (idx_out % TAB_SIZE);
                        if (nspaces == 0)
                        {
                                nspaces = TAB_SIZE;
                        }
                        fprintf(fp, "%s", &tabspaces[TAB_SIZE - nspaces]);
                        idx++;
                        idx_out += nspaces;
                }
                else
                {
                        char *p;
                        p = strchr(input_string + idx, '\t');
                        if (p != NULL)
                        {
                                size_t ncharacters;
                                /* ncharacters cannot be 0 because this is */
                                /* a non-'\t' character */
                                ncharacters = p - (input_string + idx);
                                {
                                        char tmp[ncharacters + 1];
                                        snprintf(tmp, ncharacters + 1, "%s", input_string + idx);
#if __START_IF_SELECTION__
#elif defined(_WIN32)
                                        /* win/MinGW bug */
                                        tmp[ncharacters] = '\0';
#endif
                                        fprintf(fp, "%s", tmp);
                                        idx += ncharacters;
                                        idx_out += ncharacters;
                                }
                        }
                        else
                        {
                                fprintf(fp, "%s", input_string + idx);
                                break;
                        }
                }
        }
}

/******************************************************************************
 * data_read()                                                                *
 *                                                                            *
 ******************************************************************************/
static int
data_read(int fd, void *buffer, size_t length)
{
        size_t datacount;
        size_t n;

        datacount = 0;
        while (datacount < length)
        {
                n = read(fd, (void *)((uint8_t *)buffer + datacount), length - datacount);
                if (n == 0)
                {
                        /* no data available */
                        return ERROR_ERROR;
                }
                else if (n != (size_t)-1)
                {
                        /* read ok, continue */
                        datacount += n;
                }
                else if (errno != EAGAIN && errno != EINTR)
                {
                        /* error */
                        return ERROR_ERROR;
                }
        }

        return 0;
}

/******************************************************************************
 * elf_read()                                                                 *
 *                                                                            *
 ******************************************************************************/
static void *
elf_read(Elf_t *pelf, void *buffer, off_t offset, size_t length)
{
        if (length != 0)
        {
                void *t_buffer;
                offset += pelf->base;
                if (lseek(pelf->fd, offset, SEEK_SET) != offset)
                {
                        // ERROR_IO
                }
                else if ((t_buffer = buffer) == NULL && (t_buffer = lib_malloc(length)) == NULL)
                {
                        // ERROR_NOMEM
                }
                else if (data_read(pelf->fd, t_buffer, length) < 0)
                {
                        // ERROR_IO
                        if (t_buffer != buffer)
                        {
                                lib_free((void *)t_buffer);
                                t_buffer = NULL;
                        }
                }
                else
                {
                        return t_buffer;
                }
        }

        return NULL;
}

/******************************************************************************
 * elf_begin()                                                                *
 *                                                                            *
 ******************************************************************************/
static Elf_t *
elf_begin(int fd)
{
        Elf_t  *pelf;
        off_t   fd_offset;
        size_t  size;
        int     endian_detect;

        fd_offset = lseek(fd, (off_t)0, SEEK_END);
        if (fd_offset == (off_t)-1)
        {
                // ERROR_IO
                return NULL;
        }
        size = fd_offset;

        pelf = lib_malloc(sizeof(Elf_t));
        if (pelf == NULL)
        {
                // ERROR_NOMEM
                return NULL;
        }
        pelf->fd = fd;
        pelf->base = 0;

        pelf->data = elf_read(pelf, NULL, 0, size);
        if (pelf->data == NULL)
        {
                // ERROR_IO
                lib_free((void *)pelf);
                pelf = NULL;
                return NULL;
        }
        pelf->ehdr = pelf->data;

        /*
         * Check ELF.
         */
        pelf->idlen = size;
        if (size >= EI_NIDENT && memcmp(pelf->data, ELFMAGIC, ELFMAGIC_SIZE) == 0)
        {
                pelf->idlen = EI_NIDENT;
                pelf->class = pelf->data[EI_CLASS];
                pelf->encoding = pelf->data[EI_DATA];
                pelf->version = pelf->data[EI_VERSION];
                /*
                 * ELFDATA2LSB == 1 2's complement, little endian
                 * ELFDATA2MSB == 2 2's complement, big endian
                 */
                endian_detect = endianness_detect();
                if (
                     (pelf->encoding == ELFDATA2LSB && endian_detect == ENDIANNESS_BIG)    ||
                     (pelf->encoding == ELFDATA2MSB && endian_detect == ENDIANNESS_LITTLE)
                   )
                {
                        application.endianness_swap = true;
                }
        }
        else
        {
                lib_free((void *)(pelf->data));
                pelf->data = NULL;
                lib_free((void *)pelf);
                pelf = NULL;
        }

        return pelf;
}

/******************************************************************************
 * elf_end()                                                                  *
 *                                                                            *
 ******************************************************************************/
static int
elf_end(Elf_t *pelf)
{
        if (pelf != NULL)
        {
                if (pelf->data != NULL)
                {
                        lib_free((void *)pelf->data);
                        pelf->data = NULL;
                }
                lib_free((void *)pelf);
                pelf = NULL;
        }

        return 0;
}

/******************************************************************************
 * elf_analyze()                                                              *
 *                                                                            *
 ******************************************************************************/
static void
elf_analyze(Elf_t *pelf)
{
        int         idx;
        off_t       name;
        off_t       offset;
        size_t      size;
        uint64_t    addr;
        const char *scn_name;

        /*
         * Start of program header table / section header table.
         */
        if (pelf->class == ELFCLASS32)
        {
                Elf32_Ehdr *ehdr;
                ehdr = (Elf32_Ehdr *)pelf->ehdr;
                pelf->phoff               = SWAP32(ehdr->e_phoff);
                pelf->shoff               = SWAP32(ehdr->e_shoff);
                pelf->shnum               = SWAP16(ehdr->e_shnum);
                pelf->shentsize           = SWAP16(ehdr->e_shentsize);
                pelf->shstrndx            = SWAP16(ehdr->e_shstrndx);
                pelf->scn_shstrtab_offset = SWAP32(((Elf32_Shdr *)(pelf->data + pelf->shoff + pelf->shstrndx * pelf->shentsize))->sh_offset);
        }
        else if (pelf->class == ELFCLASS64)
        {
                Elf64_Ehdr *ehdr;
                ehdr = (Elf64_Ehdr *)pelf->ehdr;
                pelf->phoff               = SWAP64(ehdr->e_phoff);
                pelf->shoff               = SWAP64(ehdr->e_shoff);
                pelf->shnum               = SWAP16(ehdr->e_shnum);
                pelf->shentsize           = SWAP16(ehdr->e_shentsize);
                pelf->shstrndx            = SWAP16(ehdr->e_shstrndx);
                pelf->scn_shstrtab_offset = SWAP64(((Elf64_Shdr *)(pelf->data + pelf->shoff + pelf->shstrndx * pelf->shentsize))->sh_offset);
        }
        for (idx = 0; idx < (int)pelf->shnum; idx++)
        {
                size_t scn_string_length;
                if (pelf->class == ELFCLASS32)
                {
                        Elf32_Shdr *shdr;
                        shdr = (Elf32_Shdr *)(pelf->data + pelf->shoff + idx * pelf->shentsize);
                        name   = SWAP32(shdr->sh_name);
                        offset = SWAP32(shdr->sh_offset);
                        size   = SWAP32(shdr->sh_size);
                        addr   = SWAP32(shdr->sh_addr);
                }
                else if (pelf->class == ELFCLASS64)
                {
                        Elf64_Shdr *shdr;
                        shdr = (Elf64_Shdr *)(pelf->data + pelf->shoff + idx * pelf->shentsize);
                        name   = SWAP32(shdr->sh_name);
                        offset = SWAP64(shdr->sh_offset);
                        size   = SWAP64(shdr->sh_size);
                        addr   = SWAP64(shdr->sh_addr);
                }
                /* get section name */
                scn_name = (const char *)(pelf->data + pelf->scn_shstrtab_offset + name);
                scn_string_length = STRING_LENGTH(scn_name);
                if (scn_string_length > application.scn_max_string_length)
                {
                        application.scn_max_string_length = scn_string_length;
                }
                if      (strcmp(scn_name, ".strtab") == 0)
                {
                        pelf->scn_strtab_offset = offset;
                }
                else if (strcmp(scn_name, ".symtab") == 0)
                {
                        pelf->scn_symtab_offset = offset;
                        pelf->scn_symtab_size   = size;
                }
                else if (strcmp(scn_name, ".text") == 0)
                {
                        pelf->scn_text_offset = offset;
                        pelf->scn_text_addr   = addr;
                }
        }
}

/******************************************************************************
 * elf_find_symbol()                                                          *
 *                                                                            *
 ******************************************************************************/
static int
elf_find_symbol(Elf_t *pelf, const char *symbol, uint64_t *pvalue)
{
        int         nsymbol;
        int         idx;
        off_t       name;
        size_t      shndx;
        size_t      value;
        size_t      size;
        const char *symbol_name;

        nsymbol = 0;

        if (pelf->class == ELFCLASS32)
        {
                nsymbol = pelf->scn_symtab_size / sizeof(Elf32_Sym);
        }
        else if (pelf->class == ELFCLASS64)
        {
                nsymbol = pelf->scn_symtab_size / sizeof(Elf64_Sym);
        }
        for (idx = 0; idx < nsymbol; idx++)
        {
                if (pelf->class == ELFCLASS32)
                {
                        Elf32_Sym *sym;
                        sym = (Elf32_Sym *)(pelf->data + pelf->scn_symtab_offset + idx * sizeof(Elf32_Sym));
                        name  = SWAP32(sym->st_name);
                        shndx = SWAP16(sym->st_shndx);
                        value = SWAP32(sym->st_value);
                        size  = SWAP32(sym->st_size);
                }
                else if (pelf->class == ELFCLASS64)
                {
                        Elf64_Sym *sym;
                        sym = (Elf64_Sym *)(pelf->data + pelf->scn_symtab_offset + idx * sizeof(Elf64_Sym));
                        name  = SWAP32(sym->st_name);
                        shndx = SWAP16(sym->st_shndx);
                        value = SWAP64(sym->st_value);
                        size  = SWAP64(sym->st_size);
                }
                (void)shndx;
                (void)size;
                symbol_name = (const char *)(pelf->data + pelf->scn_strtab_offset + name);
                if (strcmp(symbol_name, symbol) == 0)
                {
                        *pvalue = value;
                        return 0;
                }
        }

        return ERROR_NO_SYMBOL;
}

/******************************************************************************
 * command_dumpsections()                                                     *
 *                                                                            *
 ******************************************************************************/
static int
command_dumpsections(void)
{
        const char *heading_name;
        char        output_string_buffer[1024];
        char        tmp_string_buffer[1024];
        size_t      max_string_length;
        int         ntabs;
        int         nsections_ndigits;
        char        printf_nsections_format[16];
        int         idx;

        /* initialize TAB -> SPACES array */
        for (idx = 0; idx < TAB_SIZE; ++idx)
        {
                tabspaces[idx] = ' ';
        }
        tabspaces[idx] = '\0';

        elf_analyze(application.pelf);

        heading_name = "Name";
        output_string_buffer[0] = '\0';
        max_string_length = MAX(application.scn_max_string_length, STRING_LENGTH(heading_name));
        ntabs = compute_tabs(heading_name, max_string_length);

        sprintf(tmp_string_buffer, "%s\t%s", "Index", heading_name);
        strcat(output_string_buffer, tmp_string_buffer);
        while (ntabs-- > 0)
        {
                sprintf(tmp_string_buffer, "\t");
                strcat(output_string_buffer, tmp_string_buffer);
        }
        switch (application.pelf->class)
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
        fprintf_tab2spaces(stdout, output_string_buffer);

        /* synthesize the format string to print the section number */
        if (application.pelf->shnum < 10)
        {
                nsections_ndigits = 1;
        }
        else if (application.pelf->shnum < 100)
        {
                nsections_ndigits = 2;
        }
        else if (application.pelf->shnum < 1000)
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

        for (idx = 0; idx < (int)application.pelf->shnum; idx++)
        {
                off_t name;
                size_t size;
                uint64_t addr;
                const char *scn_name;
                name = 0;
                if (application.pelf->class == ELFCLASS32)
                {
                        Elf32_Shdr *shdr;
                        shdr = (Elf32_Shdr *)(application.pelf->data + application.pelf->shoff + idx * application.pelf->shentsize);
                        name = SWAP32(shdr->sh_name);
                        size = SWAP32(shdr->sh_size);
                        addr = SWAP32(shdr->sh_addr);
                }
                else if (application.pelf->class == ELFCLASS64)
                {
                        Elf64_Shdr *shdr;
                        shdr = (Elf64_Shdr *)(application.pelf->data + application.pelf->shoff + idx * application.pelf->shentsize);
                        name = SWAP32(shdr->sh_name);
                        size = SWAP64(shdr->sh_size);
                        addr = SWAP64(shdr->sh_addr);
                }
                /* get section name */
                scn_name = (const char *)(application.pelf->data + application.pelf->scn_shstrtab_offset + name);
                if (STRING_LENGTH(scn_name) == 0)
                {
                        scn_name = "<NULL>";
                }
                output_string_buffer[0] = '\0';
                sprintf(tmp_string_buffer, printf_nsections_format, idx, scn_name);
                strcat(output_string_buffer, tmp_string_buffer);
                ntabs = compute_tabs(scn_name, max_string_length);
                while (ntabs-- > 0)
                {
                        sprintf(tmp_string_buffer, "\t");
                        strcat(output_string_buffer, tmp_string_buffer);
                }
                switch (application.pelf->class)
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
                                        addr,
                                        size
                                        );
                                strcat(output_string_buffer, tmp_string_buffer);
                                fprintf_tab2spaces(stdout, output_string_buffer);
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
                                        addr,
                                        size
                                        );
                                strcat(output_string_buffer, tmp_string_buffer);
                                fprintf_tab2spaces(stdout, output_string_buffer);
                                break;
                        default:
                                break;
                }
        }

        return 0;
}

/******************************************************************************
 * command_section()                                                          *
 *                                                                            *
 ******************************************************************************/
static int
command_section(int vaddr_or_size)
{
        int idx;

        elf_analyze(application.pelf);

        for (idx = 0; idx < (int)application.pelf->shnum; idx++)
        {
                off_t name;
                size_t size;
                uint64_t addr;
                const char *scn_name;
                name = 0;
                if (application.pelf->class == ELFCLASS32)
                {
                        Elf32_Shdr *shdr;
                        shdr = (Elf32_Shdr *)(application.pelf->data + application.pelf->shoff + idx * application.pelf->shentsize);
                        name = SWAP32(shdr->sh_name);
                        size = SWAP32(shdr->sh_size);
                        addr = SWAP32(shdr->sh_addr);
                }
                else if (application.pelf->class == ELFCLASS64)
                {
                        Elf64_Shdr *shdr;
                        shdr = (Elf64_Shdr *)(application.pelf->data + application.pelf->shoff + idx * application.pelf->shentsize);
                        name = SWAP32(shdr->sh_name);
                        size = SWAP64(shdr->sh_size);
                        addr = SWAP64(shdr->sh_addr);
                }
                /* get section name */
                scn_name = (const char *)(application.pelf->data + application.pelf->scn_shstrtab_offset + name);
                if (strcmp(scn_name, application.symbol_name) == 0)
                {
                        switch (vaddr_or_size)
                        {
                                case SECTION_VADDR:
                                        application.symbol_value = addr;
                                        break;
                                case SECTION_SIZE:
                                        application.symbol_value = size;
                                        break;
                        }
                        print_value();
                        return 0;
                }
        }

        return ERROR_NO_SYMBOL;
}

/******************************************************************************
 * command_findsymbol()                                                       *
 *                                                                            *
 ******************************************************************************/
static int
command_findsymbol(void)
{
        int efs_status;

        elf_analyze(application.pelf);

        efs_status = elf_find_symbol(application.pelf, application.symbol_name, &application.symbol_value);
        if (efs_status == 0)
        {
                print_value();
        }

        return efs_status;
}

/******************************************************************************
 * command_setdebugflag()                                                     *
 *                                                                            *
 ******************************************************************************/
static int
command_setdebugflag(void)
{
        int     efs_status;
        off_t   offset;
        uint8_t value;

        elf_analyze(application.pelf);

        efs_status = elf_find_symbol(application.pelf, "_debug_flag", &application.symbol_value);
        if (efs_status < 0)
        {
                if (efs_status == ERROR_NO_SYMBOL)
                {
                        return ERROR_NO_SYMBOL;
                }
                else
                {
                        return ERROR_ERROR;
                }
        }

        offset = application.pelf->scn_text_offset + (application.symbol_value - application.pelf->scn_text_addr);
        lseek(application.pelf->fd, offset, SEEK_SET);
        if (read(application.pelf->fd, (void *)&value, 1) != 1)
        {
                log_printf(LOG_STDERR | LOG_FILE, "*** Error: read()ing the input file.");
                return ERROR_ERROR;
        }
        if (value != application.debug_flag_value)
        {
                lseek(application.pelf->fd, -1, SEEK_CUR);
                if (write(application.pelf->fd, (void *)&application.debug_flag_value, 1) != 1)
                {
                        log_printf(LOG_STDERR | LOG_FILE, "*** Error: write()ing the input file.");
                        return ERROR_ERROR;
                }
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
                        const char *dumpsections_option = "dumpsections";
                        const char *sectionvaddr_option = "sectionvaddr=";
                        const char *sectionsize_option = "sectionsize=";
                        const char *findsymbol_option = "findsymbol=";
                        const char *setdebugflag_option = "setdebugflag=";
                        size_t sectionvaddr_optionlength = STRING_LENGTH(sectionvaddr_option);
                        size_t sectionsize_optionlength = STRING_LENGTH(sectionsize_option);
                        size_t findsymbol_optionlength = STRING_LENGTH(findsymbol_option);
                        size_t setdebugflag_optionlength = STRING_LENGTH(setdebugflag_option);
                        if (STRING_LENGTH(argv[idx]) != 2)
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
                                        if (number_of_arguments-- > 0)
                                        {
                                                ++idx;
                                                if      (strcmp(argv[idx], dumpsections_option) == 0)
                                                {
                                                        p->command = COMMAND_DUMPSECTIONS;
                                                }
                                                else if (strncmp(argv[idx], sectionvaddr_option, sectionvaddr_optionlength) == 0)
                                                {
                                                        p->command = COMMAND_SECTIONVADDR;
                                                        p->symbol_name = argv[idx] + sectionvaddr_optionlength;
                                                }
                                                else if (strncmp(argv[idx], sectionsize_option, sectionsize_optionlength) == 0)
                                                {
                                                        p->command = COMMAND_SECTIONSIZE;
                                                        p->symbol_name = argv[idx] + sectionsize_optionlength;
                                                }
                                                else if (strncmp(argv[idx], findsymbol_option, findsymbol_optionlength) == 0)
                                                {
                                                        p->command = COMMAND_FINDSYMBOL;
                                                        p->symbol_name = argv[idx] + findsymbol_optionlength;
                                                }
                                                else if (strncmp(argv[idx], setdebugflag_option, setdebugflag_optionlength) == 0)
                                                {
                                                        p->command = COMMAND_SETDEBUGFLAG;
                                                        p->debug_flag_value = (uint8_t)strtoul(argv[idx] + setdebugflag_optionlength, NULL, 16);
                                                }
                                                else
                                                {
                                                        error_flag = true;
                                                        if (error_message != NULL)
                                                        {
                                                                        *error_message = "unknown command";
                                                        }
                                                }
                                        }
                                        else
                                        {
                                                error_flag = true;
                                                if (error_message != NULL)
                                                {
                                                        *error_message = "no command supplied";
                                                }
                                        }
                                        break;
                                case 'v':
                                        p->command = COMMAND_VERSION;
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

        return error_flag ? ERROR_ERROR : 0;
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
        const char *process_arguments_error_message;

        exit_status = EXIT_FAILURE;
        fd = -1;

        application.input_filename        = NULL;
        application.command               = COMMAND_NONE;
        application.pelf                  = NULL;
        application.endianness_swap       = false;
        application.scn_max_string_length = 0;
        application.symbol_name           = NULL;

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
         * Argument processing.
         */
        if      (process_arguments(argc, argv, &application, &process_arguments_error_message) < 0)
        {
                log_printf(LOG_STDERR | LOG_FILE, "*** Error: %s.", process_arguments_error_message);
                goto main_exit;
        }
        else if (application.command == COMMAND_NONE)
        {
                log_printf(LOG_STDERR | LOG_FILE, "*** Error: no command supplied.");
                goto main_exit;
        }
        else if (application.command == COMMAND_VERSION)
        {
                log_printf(LOG_STDOUT, "version %s", ELFTOOL_VERSION);
                exit_status = EXIT_SUCCESS;
                goto main_exit;
        }
        else if (application.input_filename == NULL)
        {
                log_printf(LOG_STDERR | LOG_FILE, "*** Error: no input file.");
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
         * Build the ELF descriptor.
         */
        application.pelf = elf_begin(fd);
        if (application.pelf == NULL)
        {
                log_printf(LOG_STDERR | LOG_FILE, "*** Error: elf_begin().");
                goto main_exit;
        }

        /*
         * Process command.
         */
        switch (application.command)
        {
                case COMMAND_DUMPSECTIONS:
                        if (command_dumpsections() < 0)
                        {
                                break;
                        }
                        exit_status = EXIT_SUCCESS;
                        break;
                case COMMAND_SECTIONVADDR:
                        if (STRING_LENGTH(application.symbol_name) == 0 || command_section(SECTION_VADDR) < 0)
                        {
                                break;
                        }
                        exit_status = EXIT_SUCCESS;
                        break;
                case COMMAND_SECTIONSIZE:
                        if (STRING_LENGTH(application.symbol_name) == 0 || command_section(SECTION_SIZE) < 0)
                        {
                                break;
                        }
                        exit_status = EXIT_SUCCESS;
                        break;
                case COMMAND_FINDSYMBOL:
                        if (STRING_LENGTH(application.symbol_name) == 0 || command_findsymbol() < 0)
                        {
                                break;
                        }
                        exit_status = EXIT_SUCCESS;
                        break;
                case COMMAND_SETDEBUGFLAG:
                        /* the kernel could be built without the definition */
                        /* of this symbol, so exit cleanly without flag an */
                        /* error */
                        if (command_setdebugflag() == ERROR_ERROR)
                        {
                                break;
                        }
                        exit_status = EXIT_SUCCESS;
                default:
                        /* __DNO__ */
                        exit_status = EXIT_SUCCESS;
                        break;
        }

main_exit:

        if (application.pelf != NULL)
        {
                elf_end(application.pelf);
                application.pelf = NULL;
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


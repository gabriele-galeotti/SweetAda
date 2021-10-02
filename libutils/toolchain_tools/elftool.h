
/*
 * elftool.h
 *
 * Copyright (C) 2020, 2021 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#ifndef _ELFTOOL_H
#define _ELFTOOL_H 1

#include <inttypes.h>
#include <stdbool.h>
#include <stddef.h>

/******************************************************************************
 *                                                                            *
 ******************************************************************************/

typedef struct {
        const char *input_filename;
        int         command;
        Elf        *pelf;
        int         elf_class;          /* ELFCLASS32/ELFCLASS64 */
        size_t      index_shstrtab;
        size_t      index_text;
        size_t      index_strtab;
        size_t      index_symtab;
        bool        flag_verbose;       /* VERBOSE environment variable */
        bool        flag_update;
        const char *symbol_name;
        uint64_t    symbol_value;
        uint8_t     gdbstub_flag_value;
        } Application_t;

#define COMMAND_NONE           0
#define COMMAND_DUMPSECTIONS   1
#define COMMAND_OBJECTSIZES    2
#define COMMAND_FINDSYMBOL     3
#define COMMAND_SETGDBSTUBFLAG 4

#endif /* _ELFTOOL_H */



/*
 * elf.h
 *
 * Copyright (C) 2020-2024 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#ifndef _ELF_H
#define _ELF_H 1

#include <stdint.h>

typedef uint16_t   Elf32_Half;
typedef uint16_t   Elf64_Half;
typedef uint32_t   Elf32_Word;
typedef int32_t    Elf32_Sword;
typedef uint32_t   Elf64_Word;
typedef int32_t    Elf64_Sword;
typedef uint64_t   Elf32_Xword;
typedef int64_t    Elf32_Sxword;
typedef uint64_t   Elf64_Xword;
typedef int64_t    Elf64_Sxword;
typedef uint32_t   Elf32_Addr;
typedef uint64_t   Elf64_Addr;
typedef uint32_t   Elf32_Off;
typedef uint64_t   Elf64_Off;
typedef uint16_t   Elf32_Section;
typedef uint16_t   Elf64_Section;
typedef Elf32_Half Elf32_Versym;
typedef Elf64_Half Elf64_Versym;

#define EI_NIDENT     16
#define ELFMAGIC      "\x7F""ELF"
#define ELFMAGIC_SIZE 4
#define ELFCLASS32    1                         // 32-bit format
#define ELFCLASS64    2                         // 64-bit format
#define ELFDATA2LSB   1                         // LE 2''s complement format
#define ELFDATA2MSB   2                         // BE 2''s complement format
#define EI_CLASS      4                         // class index
#define EI_DATA       5                         // data encoding index
#define EI_VERSION    6                         // version index

typedef struct {
        uint8_t    e_ident[EI_NIDENT];          // magic number
        Elf32_Half e_type;                      // file type
        Elf32_Half e_machine;                   // architecture
        Elf32_Word e_version;                   // file version
        Elf32_Addr e_entry;                     // entry point virtual address
        Elf32_Off  e_phoff;                     // program header table file offset
        Elf32_Off  e_shoff;                     // section header table file offset
        Elf32_Word e_flags;                     // processor specific flags
        Elf32_Half e_ehsize;                    // ELF header size in bytes
        Elf32_Half e_phentsize;                 // program header table entry size
        Elf32_Half e_phnum;                     // program header table entry count
        Elf32_Half e_shentsize;                 // section header table entry size
        Elf32_Half e_shnum;                     // section header table entry count
        Elf32_Half e_shstrndx;                  // section header string table index
        } Elf32_Ehdr;

typedef struct {
        uint8_t    e_ident[EI_NIDENT];          // magic number
        Elf64_Half e_type;                      // file type
        Elf64_Half e_machine;                   // architecture
        Elf64_Word e_version;                   // file version
        Elf64_Addr e_entry;                     // entry point virtual address
        Elf64_Off  e_phoff;                     // program header table file offset
        Elf64_Off  e_shoff;                     // section header table file offset
        Elf64_Word e_flags;                     // processor-specific flags
        Elf64_Half e_ehsize;                    // ELF header size in bytes
        Elf64_Half e_phentsize;                 // program header table entry size
        Elf64_Half e_phnum;                     // program header table entry count
        Elf64_Half e_shentsize;                 // section header table entry size
        Elf64_Half e_shnum;                     // section header table entry count
        Elf64_Half e_shstrndx;                  // section header string table index
        } Elf64_Ehdr;

typedef struct {
        Elf32_Word sh_name;                     // name
        Elf32_Word sh_type;                     // type
        Elf32_Word sh_flags;                    // flags
        Elf32_Addr sh_addr;                     // virtual address (execution)
        Elf32_Off  sh_offset;                   // file offset
        Elf32_Word sh_size;                     // size in bytes
        Elf32_Word sh_link;                     // link to another section
        Elf32_Word sh_info;                     // additional section information
        Elf32_Word sh_addralign;                // alignment
        Elf32_Word sh_entsize;                  // entry size if section holds table
        } Elf32_Shdr;

typedef struct {
        Elf64_Word  sh_name;                    // name
        Elf64_Word  sh_type;                    // type
        Elf64_Xword sh_flags;                   // flags
        Elf64_Addr  sh_addr;                    // virtual address (execution)
        Elf64_Off   sh_offset;                  // file offset
        Elf64_Xword sh_size;                    // size in bytes
        Elf64_Word  sh_link;                    // link to another section
        Elf64_Word  sh_info;                    // additional section information
        Elf64_Xword sh_addralign;               // alignment
        Elf64_Xword sh_entsize;                 // entry size if section holds table
        } Elf64_Shdr;

typedef struct {
        Elf32_Word    st_name;                  // name
        Elf32_Addr    st_value;                 // value
        Elf32_Word    st_size;                  // size
        uint8_t       st_info;                  // type and binding
        uint8_t       st_other;                 // visibility
        Elf32_Section st_shndx;                 // index
        } Elf32_Sym;

typedef struct {
        Elf64_Word    st_name;                  // name
        uint8_t       st_info;                  // type and binding
        uint8_t       st_other;                 // visibility
        Elf64_Section st_shndx;                 // index
        Elf64_Addr    st_value;                 // value
        Elf64_Xword   st_size;                  // size
        } Elf64_Sym;

#endif /* _ELF_H */


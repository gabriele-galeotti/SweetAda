
/*
 * sh.h - SuperH architecture definitions.
 *
 * Copyright (C) 2020-2024 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#ifndef _SH_H
#define _SH_H 1

#include <llutils.h>

/*
 * Assembler utility macros.
 */

/*
 * Define variable label containing a value:
 * output: "LABEL: VALUE"
 */
#define VARW(label, value)      \
                .align  1     ; \
label:          .word   value
#define VARL(label, value)      \
                .align  2     ; \
label:          .long   value

/*
 * Create a prefixed symbol name:
 * output: "r_SYMBOL"
 */
#define REF(symbol) STRCONCAT(r_, symbol)

/*
 * Define a 16-bit local reference symbol:
 * output: "r_SYMBOL: .word SYMBOL"
 */
#define DEF_LREFW(symbol)        \
                .align  1      ; \
REF(symbol):    .word   symbol

/*
 * Define a 32-bit local reference symbol:
 * output: "r_SYMBOL: .long SYMBOL"
 */
#define DEF_LREFL(symbol)        \
                .align  2      ; \
REF(symbol):    .long   symbol

/*
 * Define a 16-bit external reference symbol:
 * output: " .extern SYMBOL"
 *         "r_SYMBOL: .word SYMBOL"
 */
#define DEF_EREFW(symbol)        \
                .align  1      ; \
                .extern symbol ; \
REF(symbol):    .word   symbol

/*
 * Define a 32-bit external reference symbol:
 * output: " .extern SYMBOL"
 *         "r_SYMBOL: .long SYMBOL"
 */
#define DEF_EREFL(symbol)        \
                .align  2      ; \
                .extern symbol ; \
REF(symbol):    .long   symbol

#endif /* _SH_H */


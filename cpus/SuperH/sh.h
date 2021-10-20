
/*
 * sh.h - SuperH architecture definitions.
 *
 * Copyright (C) 2020, 2021 Gabriele Galeotti
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
#define VARW(label, value)  \
label:          .word value
#define VARL(label, value)  \
label:          .long value

/*
 * Create a prefixed symbol name:
 * output: "p_SYMBOL"
 */
#define REF(symbol) STRCONCAT(p_, symbol)

/*
 * Define a local reference symbol:
 * output: "p_SYMBOL: .long SYMBOL"
 */
#define DEF_LREF(symbol)     \
REF(symbol):    .long symbol

/*
 * Define an external reference symbol:
 * output: " .extern SYMBOL"
 *         "p_SYMBOL: .long SYMBOL"
 */
#define DEF_EREF(symbol)        \
                .extern symbol; \
REF(symbol):    .long   symbol

#endif /* _SH_H */


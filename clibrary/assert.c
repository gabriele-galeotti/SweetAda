
/*
 * assert.c - ASSERT implementation library.
 *
 * Copyright (C) 2020-2026 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#include <stdio.h>
#include <stdlib.h>

/******************************************************************************
 * __assert()                                                                 *
 *                                                                            *
 ******************************************************************************/
void
__assert(const char *file, int line, const char *function, const char *assertion)
{
        (void)printf(
                "*** ASSERT FAILED: \"%s\", file \"%s\", line %d, function %s\n",
                assertion,
                file,
                line,
                function
                );

        abort();
}


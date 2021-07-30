
/*
 * llutils.h - Low-level utility macros.
 *
 * Copyright (C) 2020, 2021 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#ifndef _LLUTILS_H
#define _LLUTILS_H 1

/*
 * Standard preprocessor utility macros.
 */

#define _tostring(s) #s
#define TOSTRING(s) _tostring(s)

#define _strconcat(a, b) a##b
#define STRCONCAT(a, b) _strconcat(a, b)

/*
 * SWAPXX macros.
 */

#define SWAP16(x) (                       \
                  (((x) << 8) & 0xFF00) | \
                  (((x) >> 8) & 0x00FF)   \
                  )

#define SWAP32(x) (                            \
                  (((x) << 24) & 0xFF000000) | \
                  (((x) << 8)  & 0x00FF0000) | \
                  (((x) >> 8)  & 0x0000FF00) | \
                  (((x) >> 24) & 0x000000FF)   \
                  )

#define SWAP64(x) (                                    \
                  (((x) << 56) & 0xFF00000000000000) | \
                  (((x) << 40) & 0x00FF000000000000) | \
                  (((x) << 24) & 0x0000FF0000000000) | \
                  (((x) << 8)  & 0x000000FF00000000) | \
                  (((x) >> 8)  & 0x00000000FF000000) | \
                  (((x) >> 24) & 0x0000000000FF0000) | \
                  (((x) >> 40) & 0x000000000000FF00) | \
                  (((x) >> 56) & 0x00000000000000FF)   \
                  )

/*
 * Various utility macros.
 */

#define ROUNDDN(value, align) ((value) & ~((align) - 1))
#define ROUNDUP(value, align) (((value) + (align) - 1) & ~((align) - 1))
#define ALIGN(value, align)   ROUNDUP(value, align)

#endif /* _LLUTILS_H */


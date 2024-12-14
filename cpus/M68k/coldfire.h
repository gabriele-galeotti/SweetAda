
/*
 * coldfire.h - ColdFire architecture definitions.
 *
 * Copyright (C) 2020-2024 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#ifndef _COLDFIRE_H
#define _COLDFIRE_H 1

#define VBR  0x801
#define MBAR 0xC0F

#define IPSBAR_DEFAULT 0x40000000

#define SCM_CWCR (IPSBAR + 0x11)
#define CCM_TEST (IPSBAR + 0x11000C)

#endif /* _COLDFIRE_H */


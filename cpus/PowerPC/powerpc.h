
/*
 * powerpc.h - PowerPC architecture definitions.
 *
 * Copyright (C) 2020-2026 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#ifndef _POWERPC_H
#define _POWERPC_H 1

/*
 * MSR
 */
#define MSR_DR (1 << 4)  /* Data address translation */
#define MSR_IR (1 << 5)  /* Instruction address translation */
#define MSR_IP (1 << 6)  /* Exception prefix */
#define MSR_EE (1 << 15) /* External interrupt enable */

#define LR  0x008 /* Link Register */
#define TBL 0x11C /* Time Base Lower */
#define TBU 0x11D /* Time Base Upper */
#define PVR 0x11F /* Processor Version Register */

/*
 * Instructions.
 */
#define NOP_INSTRUCTION             0x60000000
#define BREAKPOINT_INSTRUCTION      0x7D821008
#define BREAKPOINT_INSTRUCTION_SIZE 4

#endif /* _POWERPC_H */


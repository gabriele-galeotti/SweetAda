
                .global interrupt_vector_table
interrupt_vector_table:
                                                // #   offset

initialsp:      .long   INITIALSP               // 000 0x0000 -

initialpc:      .long   INITIALPC               // 001 0x0004 -
                .extern buserr_handler
buserr:         .long   buserr_handler          // 002 0x0008 -
                .extern addrerr_handler
addrerr:        .long   addrerr_handler         // 003 0x000C -
                .extern illinstr_handler
illinstr:       .long   illinstr_handler        // 004 0x0010 -
                .extern div0_handler
div0:           .long   div0_handler            // 005 0x0014 -
                .extern chkinstr_handler
chkinstr:       .long   chkinstr_handler        // 006 0x0018 -
                .extern trapc_handler
trapc:          .long   trapc_handler           // 007 0x001C -
                .extern privilegev_handler
privilegev:     .long   privilegev_handler      // 008 0x0020 -
                .extern trace_handler
trace:          .long   trace_handler           // 009 0x0024 -
                .extern line1010_handler
line1010:       .long   line1010_handler        // 010 0x0028 -
                .extern line1111_handler
line1111:       .long   line1111_handler        // 011 0x002C -

reserved1:      .long   0                       // 012 0x0030 -
                .extern cprotocolv_handler
cprotocolv:     .long   cprotocolv_handler      // 013 0x0034 -
                .extern formaterr_handler
formaterr:      .long   formaterr_handler       // 014 0x0038 -
                .extern uninitint_handler
uninitint:      .long   uninitint_handler       // 015 0x003C -

reserved2:      .long   0                       // 016 0x0040 -

reserved3:      .long   0                       // 017 0x0044 -

reserved4:      .long   0                       // 018 0x0048 -

reserved5:      .long   0                       // 019 0x004C -

reserved6:      .long   0                       // 020 0x0050 -

reserved7:      .long   0                       // 021 0x0054 -

reserved8:      .long   0                       // 022 0x0058 -

reserved9:      .long   0                       // 023 0x005C -
                .extern spurious_handler
spurious:       .long   spurious_handler        // 024 0x0060 -
                .extern l1autovector_handler
l1autovector:   .long   l1autovector_handler    // 025 0x0064 -
                .extern l2autovector_handler
l2autovector:   .long   l2autovector_handler    // 026 0x0068 -
                .extern l3autovector_handler
l3autovector:   .long   l3autovector_handler    // 027 0x006C -
                .extern l4autovector_handler
l4autovector:   .long   l4autovector_handler    // 028 0x0070 -
                .extern l5autovector_handler
l5autovector:   .long   l5autovector_handler    // 029 0x0074 -
                .extern l6autovector_handler
l6autovector:   .long   l6autovector_handler    // 030 0x0078 -
                .extern l7autovector_handler
l7autovector:   .long   l7autovector_handler    // 031 0x007C -
                .extern trap0_handler
trap0:          .long   trap0_handler           // 032 0x0080 -
                .extern trap1_handler
trap1:          .long   trap1_handler           // 033 0x0084 -
                .extern trap2_handler
trap2:          .long   trap2_handler           // 034 0x0088 -
                .extern trap3_handler
trap3:          .long   trap3_handler           // 035 0x008C -
                .extern trap4_handler
trap4:          .long   trap4_handler           // 036 0x0090 -
                .extern trap5_handler
trap5:          .long   trap5_handler           // 037 0x0094 -
                .extern trap6_handler
trap6:          .long   trap6_handler           // 038 0x0098 -
                .extern trap7_handler
trap7:          .long   trap7_handler           // 039 0x009C -
                .extern trap8_handler
trap8:          .long   trap8_handler           // 040 0x00A0 -
                .extern trap9_handler
trap9:          .long   trap9_handler           // 041 0x00A4 -
                .extern trap10_handler
trap10:         .long   trap10_handler          // 042 0x00A8 -
                .extern trap11_handler
trap11:         .long   trap11_handler          // 043 0x00AC -
                .extern trap12_handler
trap12:         .long   trap12_handler          // 044 0x00B0 -
                .extern trap13_handler
trap13:         .long   trap13_handler          // 045 0x00B4 -
                .extern trap14_handler
trap14:         .long   trap14_handler          // 046 0x00B8 -
                .extern trap15_handler
trap15:         .long   trap15_handler          // 047 0x00BC -

fpunordcond:    .long   0                       // 048 0x00C0 -

fpinexact:      .long   0                       // 049 0x00C4 -

fpdiv0:         .long   0                       // 050 0x00C8 -

fpundeflow:     .long   0                       // 051 0x00CC -

fpoperror:      .long   0                       // 052 0x00D0 -

fpoverflow:     .long   0                       // 053 0x00D4 -

fpsignan:       .long   0                       // 054 0x00D8 -

fpunimpdata:    .long   0                       // 055 0x00DC unassigned, reserved for MC68020

mmuconferror:   .long   0                       // 056 0x00E0 defined for MC68030 and MC68851, not used by MC68040

mmuilloperror:  .long   0                       // 057 0x00E4 defined for MC68851, not used by MC68030/MC68040

mmuacclevviol:  .long   0                       // 058 0x00E8 defined for MC68851, not used by MC68030/MC68040

reserved10:     .long   0                       // 059 0x00EC -

reserved11:     .long   0                       // 060 0x00F0 -

reserved12:     .long   0                       // 061 0x00F4 -

reserved13:     .long   0                       // 062 0x00F8 -

reserved14:     .long   0                       // 063 0x00FC -

                // User Defined Vectors (192 vectors)
                .space  192*4



//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2024 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                // S/370 locations
                .equ    exto_psw,24
                .equ    svco_psw,32
                .equ    prgo_psw,40
                .equ    mcko_psw,48
                .equ    ioo_psw,56
                .equ    extn_psw,88
                .equ    svcicode,138
                .equ    ioschn,186

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

#define ZERO %r12

.L0:
#define L(x) ((x)-.L0)

////////////////////////////////////////////////////////////////////////////////

#define SCHVALID 0x01
#define SCHENABL 0x80

// CCW
#define CCWLENGTH 8
// +00 command
// +01 address
// +04 flag
// +06 count
#define CCWCMD    0
#define CCWDADDR  1
#define CCWFLG    4
#define CCWBCNT   6

// UCB
#define UCBLENGTH 29
// +00 PSW to return to after I/O interrupt
// +08 SCSW after I/O
// +20 subchannel
// +22 control unit type
// +25 device type
// +28 I/O started flag
#define UCBPSW    0
#define UCBSCSW   8
#define UCBSCHN   20
#define UCBCUTYP  22
#define UCBDEVTY  25
#define UCBIOFLG  28

////////////////////////////////////////////////////////////////////////////////
// x3270_cls                                                                  //
////////////////////////////////////////////////////////////////////////////////

                .global x3270_cls
x3270_cls:
                stm     %r0,%r14,0(%r15)
                sr      %r12,%r12
                // setup base address register
                bras    %r13,1f
                .long   .L0
1:              l       %r13,0(%r13)
                mvc     extn_psw(40,%r12),L(extpsw)(%r13)               // install new PSWs
                stctl   %c6,%c6,L(savecr)(%r13)                         // enable I/O interrupts
                mvi     L(savecr)(%r13),0xFF
                lctl    %c6,%c6,L(savecr)(%r13)
                // enable all sub-channels that have a valid device number
                l       %r1,L(initsiw)(%r13)
1:              la      %r1,1(%r1,%r0)
                stsch   L(schib)(%r13)
                bo      L(2f)(%r13)
                tm      L(pmcw+5)(%r13),SCHVALID
                bno     L(1b)(%r13)
                oi      L(pmcw+5)(%r13),SCHENABL
                msch    L(schib)(%r13)
                xc      L(schib)(4,%r13),L(schib)(%r13)
                b       L(1b)(%r13)
2:              // branch to routine for console identification
                xc      L(ucbconsole)(UCBLENGTH,%r13),L(ucbconsole)(%r13)       // clear console UCB
                la      %r2,L(ucbconsole)(%r13)                         // R2 points to console UCB
                bal     %r14,L(conident)(%r13)                          // go to identify console
                // display message
                l       %r0,12(%r15)                                    // saved r3 = length
                l       %r1,8(%r15)                                     // saved r2 = address
                la      %r2,L(ucbconsole)(%r13)
                la      %r3,L(ccwew)(%r13)
                svc     1
                lm      %r0,%r14,0(%r15)
                br      %r14

////////////////////////////////////////////////////////////////////////////////
// x3270_write                                                                //
////////////////////////////////////////////////////////////////////////////////

                .global x3270_write
x3270_write:
                stm     %r0,%r14,0(%r15)
                sr      %r12,%r12
                // setup base address register
                bras    %r13,1f
                .long   .L0
1:              l       %r13,0(%r13)
                mvc     extn_psw(40,%r12),L(extpsw)(%r13)               // install new PSWs
                stctl   %c6,%c6,L(savecr)(%r13)                         // enable I/O interrupts
                mvi     L(savecr)(%r13),0xFF
                lctl    %c6,%c6,L(savecr)(%r13)
                // enable all sub-channels that have a valid device number
                l       %r1,L(initsiw)(%r13)
1:              la      %r1,1(%r1,%r0)
                stsch   L(schib)(%r13)
                bo      L(2f)(%r13)
                tm      L(pmcw+5)(%r13),SCHVALID
                bno     L(1b)(%r13)
                oi      L(pmcw+5)(%r13),SCHENABL
                msch    L(schib)(%r13)
                xc      L(schib)(4,%r13),L(schib)(%r13)
                b       L(1b)(%r13)
2:              // branch to routine for console identification
                xc      L(ucbconsole)(UCBLENGTH,%r13),L(ucbconsole)(%r13)       // clear console UCB
                la      %r2,L(ucbconsole)(%r13)                         // R2 points to console UCB
                bal     %r14,L(conident)(%r13)                          // go to identify console
                // display message
                l       %r0,12(%r15)                                    // saved r3 = length
                l       %r1,8(%r15)                                     // saved r2 = address
                la      %r2,L(ucbconsole)(%r13)
                la      %r3,L(ccww)(%r13)
                svc     1
                lm      %r0,%r14,0(%r15)
                br      %r14

                .align  4,0
savecr:         .long   0                                               // save area for control register

////////////////////////////////////////////////////////////////////////////////
// conident                                                                   //
////////////////////////////////////////////////////////////////////////////////

                // R2 = ucbconsole

conident:
                st      %r14,L(conir14)(%r13)                           // save R14
                stm     %r0,%r1,L(conir0)(%r13)                         // save R0,R1
                mvi     L(conidflg)(%r13),0                             // reset flag: CONSOLE UNIDENTIFIED
                mvc     UCBPSW(4,%r2),L(iopsw)(%r13)                    // prepare UCB
                la      %r6,L(conitype)(%r13)                           // next PSW to load -> conitype
                st      %r6,UCBPSW+4(%r2)
                lpsw    L(waitio)(%r13)                                 // wait for I/O
conitype:       xc      L(conibuf)(8,%r13),L(conibuf)(%r13)
                la      %r0,L(conibufl)(%r13)                           // R0: length of buffer
                la      %r1,L(conibuf)(%r13)                            // R1 -> buffer
                la      %r3,L(ccwsid)(%r13)                             // R3 -> CCW SENSE-ID
                svc     1                                               // ask for device type
                mvc     UCBCUTYP(3,%r2),L(conibuf+1)(%r13)              // save control-unit type
                mvc     UCBDEVTY(3,%r2),L(conibuf+4)(%r13)              // save device type
                clc     L(conibuf+1)(2,%r13),L(X3174)(%r13)             // control-unit type is 3174?
                be      L(conitype1)(%r13)                              // yes: OK
                clc     L(conibuf+1)(2,%r13),L(X3274)(%r13)             // control-unit type is 3274?
                be      L(conitype1)(%r13)                              // yes: OK
                // error
                lpsw    L(ioerrpsw)(%r13)                               // unsupported device type: disabled wait
conitype1:      lm      %r0,%r1,L(conir0)(%r13)                         // restore R0,R1
                l       %r14,L(conir14)(%r13)                           // restore R14
                br      %r14                                            // return

                .align  4,0
conir0:         .long   0
conir1:         .long   0
conir14:        .long   0
                .equ    conibufl,8
conibuf:        .space  8,0

////////////////////////////////////////////////////////////////////////////////
// routine for external interrupts                                            //
////////////////////////////////////////////////////////////////////////////////

extint:         stm     %r0,%r14,L(saveext)(%r13)
extintfin:      lm      %r0,%r14,L(saveext)(%r13)                       // restore R0-R14
                lpsw    exto_psw                                        // load old PSW

                .align  4,0
saveext:        .space  16*4,0                                          // savearea for R0-R15

////////////////////////////////////////////////////////////////////////////////
// SVC service routine                                                        //
////////////////////////////////////////////////////////////////////////////////

svcrtn:         cli     svcicode+1(%r12),1
                be      L(svc1)(%r13)
                // error, undefined SVC code
                lpsw    L(svcerrpsw)(%r13)

////////////////////////////////////////////////////////////////////////////////
// issue a CCW to console                                                     //
////////////////////////////////////////////////////////////////////////////////

//
// issue a CCW to console
//
// R0: length of the record to write or length of the buffer to contain the record to read
// R1: points to the record to write or to the buffer to contain the record to read
// R2: points to the UCB
// R3: points to the CCW
//

                // R2 = ucbconsole

svc1:
                st      %r14,L(svc1r14)(%r13)
                stm     %r0,%r1,L(svc1r0)(%r13)
                mvc     L(svc1ccw)(8,%r13),0(%r3)
                la      %r6,L(svc1ccw)(%r13)
                // R6 = svc1ssw (using CCW, R6 addressability)
                mvc     CCWDADDR(3,%r6),L(svc1r1+1)(%r13)
                mvc     CCWBCNT(2,%r6),L(svc1r0+2)(%r13)
                mvc     UCBPSW(4,%r2),L(iopsw)(%r13)
                la      %r6,L(svc1chk)(%r13)
                st      %r6,UCBPSW+4(%r2)
                // prepare registers to call execio
                la      %r0,L(svc1ccw)(%r13)
                sr      %r1,%r1
                // execute execio routine
                bal     %r14,L(execio)(%r13)
                lpsw    L(waitio)(%r13)
svc1chk:        lm      %r0,%r1,L(svc1r0)(%r13)
                l       %r14,L(svc1r14)(%r13)
                // return
                lpsw    svco_psw(%r12)

                .align  4,0
svc1r0:         .long   0                               // save area for R0
svc1r1:         .long   0                               // save area for R1
svc1r14:        .long   0                               // save area for R14
                .align  8,0
svc1ccw:        .long   0                               // storage for CCW
                .long   0

////////////////////////////////////////////////////////////////////////////////
// routine for I/O interrupts                                                 //
////////////////////////////////////////////////////////////////////////////////

ioint:          st      %r1,L(iointr1)(%r13)
                lh      %r1,ioschn(%r12)
                icm     %r1,0b0100,L(X01)(%r13)
                tsch    L(irb)(%r13)
                be      L(ioint1)(%r13)
                lpsw    L(ioerrpsw)(%r13)
ioint1:         l       %r1,L(iointr1)(%r13)
                tm      L(irb+8)(%r13),0b10000000
                bo      L(attn)(%r13)
                tm      L(irb+8)(%r13),0b00010000
                bo      L(busy)(%r13)
                tm      L(irb+8)(%r13),0b00001100
                bo      L(chdevend)(%r13)
                tm      L(irb+8)(%r13),0b00001000
                bo      L(chend)(%r13)
                tm      L(irb+8)(%r13),0b00000100
                bo      L(devend)(%r13)
iointfin:       lpsw    ioo_psw(%r12)

                .align  4,0
iointr1:        .long   0

////////////////////////////////////////////////////////////////////////////////
// attn                                                                       //
////////////////////////////////////////////////////////////////////////////////

attn:           st      %r2,L(attnr2)(%r13)
                la      %r2,L(ucbconsole)(%r13)
                cli     L(conidflg)(%r13),0xFF
                be      L(attn1)(%r13)
                mvc     UCBSCHN(2,%r2),ioschn(%r12)
                mvi     L(conidflg)(%r13),0xFF
                b       L(attn2)(%r13)
attn1:          clc     UCBSCHN(2,%r2),ioschn(%r12)
                bne     L(attnz)(%r13)
attn2:          mvc     L(attnpsw)(8,%r13),UCBPSW(%r2)
                mvc     UCBSCSW(4,%r2),L(irb)(%r13)
                l       %r2,L(attnr2)(%r13)
                lpsw    L(attnpsw)(%r13)
attnz:          l       %r2,L(attnr2)(%r13)
                b       L(iointfin)(%r13)

                .align  8,0
attnpsw:        .long   0
                .long   0
attnr2:         .long   0

////////////////////////////////////////////////////////////////////////////////
// branch table                                                               //
////////////////////////////////////////////////////////////////////////////////

busy:           b       L(iointfin)(%r13)
chdevend:       b       L(devend)(%r13)
chend:          b       L(iointfin)(%r13)

////////////////////////////////////////////////////////////////////////////////
// devend                                                                     //
////////////////////////////////////////////////////////////////////////////////

devend:         st      %r2,L(devendr2)(%r13)
                la      %r2,L(ucbconsole)(%r13)
                clc     UCBSCHN(2,%r2),ioschn(%r12)
                bne     L(devendz)(%r13)
                cli     UCBIOFLG(%r2),0xFF
                bne     L(devendz)(%r13)
                mvi     UCBIOFLG(%r2),0                 // clear I/O started flag
                mvc     L(devendpw)(8,%r13),UCBPSW(%r2)
                mvc     UCBSCSW(4,%r2),L(irb)(%r13)
                l       %r2,L(devendr2)(%r13)
                lpsw    L(devendpw)(%r13)
devendz:        l       %r2,L(devendr2)(%r13)
                b       L(iointfin)(%r13)

                .align  4,0
devendr2:       .long   0
                .align  8,0
devendpw:       .long   0
                .long   0

////////////////////////////////////////////////////////////////////////////////
// execute I/O                                                                //
////////////////////////////////////////////////////////////////////////////////

//
// called from svc1
//
// R0: points to the CCW to execute
// R2: points to the UCB
// R14: return address
//
// use: R1
//

                // R2 = ucbconsole

execio:         st      %r0,L(orbcpadr)(%r13)
                mvi     UCBIOFLG(%r2),0xFF
                lh      %r1,UCBSCHN(%r2)
                icm     %r1,0b0100,L(X01)(%r13)
                ssch    L(orb)(%r13)
                be      L(execioz)(%r13)
                bh      L(execio)(%r13)
                lpsw    L(ioerrpsw)(%r13)
execioz:        br      %r14

////////////////////////////////////////////////////////////////////////////////

                // PSWs installed at startup

                .align  8,0
extpsw:         .long   0x000C0000                      // external new PSW
                .long   extint
svcpsw:         .long   0x000C0000                      // SVC new PSW
                .long   svcrtn
prgpsw:         .long   0x000E0000                      // program new PSW (disabled wait)
                .long   0x00003333
chkpsw:         .long   0x000E0000                      // machine check new PSW (disabled wait)
                .long   0x00004444
iopsw:          .long   0x000C0000                      // I/O new PSW
                .long   ioint
waitio:         .long   0x030E0000                      // PSW for enabled wait
                .long   0x00005555
ioerrpsw:       .long   0x000E0000                      // PSW for ioerr (disabled wait)
                .long   0x00FFFFFF
endpsw:         .long   0x000E0000                      // PSW to load at end of program (disabled wait)
                .long   0x00006666
svcerrpsw:      .long   0x000E0000                      // PSW to load if calling an undefined SVC
                .long   0x00002222

                .align  8,0
ccwew:          .long   0x05000000                      // CCW: COMMAND=ERASE/WRITE
                .long   0x20000000                      // FLAG=SLI
ccwrm:          .long   0x06000000                      // CCW: COMMAND=READ MODIFIED
                .long   0x20000000                      // FLAG=SLI
ccww:           .long   0x01000000                      // CCW: COMMAND=WRITE
                .long   0x20000000                      // FLAG=SLI
ccwsid:         .long   0xE4000000                      // CCW: COMMAND=SENSE-ID
                .long   0x20000000                      // FLAG=SLI

                .align  4,0
initsiw:        .long   0x0000FFFF                      // initial sub-ID word for scanning
conidflg:       .byte   0
X3274:          .byte   0x32,0x74
X3174:          .byte   0x31,0x74
X01:            .byte   0x01

                .align  8,0
ucbconsole:     .space  UCBLENGTH,0

                .align  4,0
orb:
orbinprm:       .long   0                               // +00
                .byte   0,0                             // +04
orblpm:         .byte   0xFF                            // +06
                .byte   0                               // +07
orbcpadr:       .long   0                               // +08

                .align  4,0
schib:
pmcw:           .space  7*4,0                           // +00
scsw:           .space  3*4,0                           // +28
                .space  3*4,0                           // +40 model-dependent info

                .align  4,0
irb:
                .space  24*4,0                          // IRB for test subchannel instruction


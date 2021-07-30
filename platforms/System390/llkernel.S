
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020, 2021 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

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

                .global x3270_cls
x3270_cls:

                stm     %r0,%r15,saveregs
                lm      %r0,%r15,zero16
                mvc     extn_psw(40),extpsw             // install new PSWs
                stctl   %c6,%c6,savecr                  // enable I/O interrupts
                mvi     savecr,0xFF
                lctl    %c6,%c6,savecr

                //
                // Enable all sub-channels that have a valid device number.
                //
                l       %r1,initsiw
1:              la      %r1,1(%r1,%r0)
                stsch   schib
                bo      2f
                tm      pmcw+5,SCHVALID
                bno     1b
                oi      pmcw+5,SCHENABL
                msch    schib
                xc      schib(4),schib
                b       1b
2:

                //
                // Branch to routine for console identification.
                //
                xc      ucbcons(UCBLENGTH),ucbcons      // clear console UCB
                la      %r2,ucbcons                     // R2 points to console UCB
                bal     %r14,conident                   // go to identify console

                //
                // Display message.
                //
                l       %r0,saver03                     // r3 = length
                l       %r1,saver02                     // r2 = address
                la      %r2,ucbcons
                la      %r3,ccwew
                svc     1

                lm      %r0,%r15,saveregs
                br      %r14

                .global x3270_write
x3270_write:

                stm     %r0,%r15,saveregs
                lm      %r0,%r15,zero16
                mvc     extn_psw(40),extpsw             // install new PSWs
                stctl   %c6,%c6,savecr                  // enable I/O interrupts
                mvi     savecr,0xFF
                lctl    %c6,%c6,savecr

                //
                // Enable all sub-channels that have a valid device number.
                //
                l       %r1,initsiw
1:              la      %r1,1(%r1,%r0)
                stsch   schib
                bo      2f
                tm      pmcw+5,SCHVALID
                bno     1b
                oi      pmcw+5,SCHENABL
                msch    schib
                xc      schib(4),schib
                b       1b
2:

                //
                // Branch to routine for console identification.
                //
                xc      ucbcons(UCBLENGTH),ucbcons      // clear console UCB
                la      %r2,ucbcons                     // R2 points to console UCB
                bal     %r14,conident                   // go to identify console

                //
                // Display message.
                //
                l       %r0,saver03                     // r3 = length
                l       %r1,saver02                     // r2 = address
                la      %r2,ucbcons
                la      %r3,ccww
                svc     1

                lm      %r0,%r15,saveregs
                br      %r14

                .align  4,0
saveregs:       .long   0
saver01:        .long   0
saver02:        .long   0
saver03:        .long   0
saver04:        .long   0
saver05:        .long   0
saver06:        .long   0
saver07:        .long   0
saver08:        .long   0
saver09:        .long   0
saver10:        .long   0
saver11:        .long   0
saver12:        .long   0
saver13:        .long   0
saver14:        .long   0
saver15:        .long   0
savecr:         .long   0                               // save area for control register
zero16:         .space  16*4,0                          // 16 words to initialize registers

////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////

                // R2 = ucbcons (using UCB, R2 addressability)

conident:
                st      %r14,conir14                    // save GR14
                stm     %r0,%r1,conir0                  // save GR0,GR1

                mvi     conidflg,0                      // reset flag: CONSOLE UNIDENTIFIED
                mvc     UCBPSW(4,%r2),iopsw             // prepare UCB
                la      %r6,conitype                    // next PSW to load -> conitype
                st      %r6,UCBPSW+4(%r2)
                lpsw    waitio                          // wait for I/O

conitype:       xc      conibuf(8),conibuf
                la      %r0,conibufl                    // GR0: length of buffer
                la      %r1,conibuf                     // GR1 -> buffer
                la      %r3,ccwsid                      // R3 -> CCW SENSE-ID
                svc     1                               // ask for device type
                mvc     UCBCUTYP(3,%r2),conibuf+1       // save control-unit type
                mvc     UCBDEVTY(3,%r2),conibuf+4       // save device type
                clc     conibuf+1(2),X3174              // control-unit type is 3174?
                be      conitype1                       // yes: OK
                clc     conibuf+1(2),X3274              // control-unit type is 3274?
                be      conitype1                       // yes: OK
                // error
                lpsw    ioerrpsw                        // unsupported device type: disabled wait

conitype1:      lm      %r0,%r1,conir0                  // restore GR0,GR1
                l       %r14,conir14                    // restore GR14
                br      %r14                            // return

                .align  4,0
conir0:         .long   0
conir1:         .long   0
conir14:        .long   0
                .equ    conibufl,8
conibuf:        .space  8,0

////////////////////////////////////////////////////////////////////////////////
// routine for external interruptions
////////////////////////////////////////////////////////////////////////////////

extint:         stm     %r0,%r15,saveext
extintfin:      lm      %r0,%r15,saveext                // restore GR0-GR15
                lpsw    exto_psw                        // load old PSW

                .align  4,0
saveext:        .space  16*4,0                          // savearea for GR0-GR15

////////////////////////////////////////////////////////////////////////////////
// SVC service routine
////////////////////////////////////////////////////////////////////////////////

svcrtn:         cli     svcicode+1,1
                be      svc1
                // error, undefined SVC code
                lpsw    svcerrpw

////////////////////////////////////////////////////////////////////////////////
// issue a CCW to console
////////////////////////////////////////////////////////////////////////////////

//
// ISSUE A CCW TO CONSOLE
//
// R0: LENGTH OF THE RECORD TO WRITE OR LENGTH OF THE BUFFER TO CONTAIN THE RECORD TO READ
// R1: POINTS TO THE RECORD TO WRITE OR TO THE BUFFER TO CONTAIN THE RECORD TO READ
// R2: POINTS TO THE UCB
// R3: POINTS TO THE CCW TO ISSUE
//

                // R2 = ucbcons (using UCB, R2 addressability)

svc1:
                st      %r14,svc1r14
                stm     %r0,%r1,svc1r0
                mvc     svc1ccw(8),0(%r3)
                la      %r6,svc1ccw
                // R6 = svc1ssw (using CCW, R6 addressability)
                mvc     CCWDADDR(3,%r6),svc1r1+1
                mvc     CCWBCNT(2,%r6),svc1r0+2
                mvc     UCBPSW(4,%r2),iopsw
                la      %r6,svc1chk
                st      %r6,UCBPSW+4(%r2)
                // prepare registers to call execio
                la      %r0,svc1ccw
                sr      %r1,%r1
                // execute execio routine
                bal     %r14,execio
                lpsw    waitio
svc1chk:        lm      %r0,%r1,svc1r0
                l       %r14,svc1r14
                // return
                lpsw    svco_psw

                .align  4,0
svc1r0:         .long   0                               // save area for R0
svc1r1:         .long   0                               // save area for R1
svc1r14:        .long   0                               // save area for R14
                .align  8,0
svc1ccw:        .long   0                               // storage for CCW
                .long   0

////////////////////////////////////////////////////////////////////////////////
// routine for I/O interruptions
////////////////////////////////////////////////////////////////////////////////

ioint:          st      %r1,iointr1
                lh      %r1,ioschn
                icm     %r1,0b0100,X01
                tsch    irb
                be      ioint1
                lpsw    ioerrpsw
ioint1:         l       %r1,iointr1
                tm      irb+8,0b10000000
                bo      attn
                tm      irb+8,0b00010000
                bo      busy
                tm      irb+8,0b00001100
                bo      chdevend
                tm      irb+8,0b00001000
                bo      chend
                tm      irb+8,0b00000100
                bo      devend
iointfin:       lpsw    ioo_psw

                .align  4,0
iointr1:        .long   0

////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////

attn:           st      %r2,attnr2
                la      %r2,ucbcons
                cli     conidflg,0xFF
                be      attn1
                mvc     UCBSCHN(2,%r2),ioschn
                mvi     conidflg,0xFF
                b       attn2
attn1:          clc     UCBSCHN(2,%r2),ioschn
                bne     attnz
attn2:          mvc     attnpsw(8),UCBPSW(%r2)
                mvc     UCBSCSW(4,%r2),irb
                l       %r2,attnr2
                lpsw    attnpsw
attnz:          l       %r2,attnr2
                b       iointfin

                .align  8,0
attnpsw:        .long   0
                .long   0
attnr2:         .long   0

////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////

busy:           b       iointfin
chdevend:       b       devend
chend:          b       iointfin

////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////

devend:         st      %r2,devendr2
                la      %r2,ucbcons
                clc     UCBSCHN(2,%r2),ioschn
                bne     devendz
                cli     UCBIOFLG(%r2),0xFF
                bne     devendz
                mvi     UCBIOFLG(%r2),0                 // clear I/O started flag
                mvc     devendpw(8),UCBPSW(%r2)
                mvc     UCBSCSW(4,%r2),irb
                l       %r2,devendr2
                lpsw    devendpw
devendz:        l       %r2,devendr2
                b       iointfin

                .align  4,0
devendr2:       .long   0
                .align  8,0
devendpw:       .long   0
                .long   0

////////////////////////////////////////////////////////////////////////////////
// EXECUTE ONE I/O INSTR. (READ OR WRITE)
////////////////////////////////////////////////////////////////////////////////

//
// CALLED FROM SVC1 ROUTINE
//
// R0: POINTS TO THE CCW TO EXECUTE
// R2: POINTS TO THE UCB
// R14: RETURN ADDRESS
//
// MODIFIES: R1 (IF ASSEMBLED FOR ESA/390 ARCH)
//

                // R2 = ... (using UCB, R2 addressability)

execio:         st      %r0,orbcpadr
                mvi     UCBIOFLG(%r2),0xFF
                lh      %r1,UCBSCHN(%r2)
                icm     %r1,0b0100,X01
                ssch    orb
                be      execioz
                bh      execio
                lpsw    ioerrpsw
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
svcerrpw:       .long   0x000E0000                      // PSW to load if calling an undefined SVC
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
ucbcons:        .space  UCBLENGTH,0

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


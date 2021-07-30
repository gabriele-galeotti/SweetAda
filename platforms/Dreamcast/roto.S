
!
! This file is not covered by SweetAda copyright, see:
! http://www.boob.co.uk/files/roto.zip
!

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .set    CLRSCR,1
                !.set    DEBUG,1

                .align  2

                .global roto
roto:

.ifdef CLRSCR
                ! clear screen
                mov.l   VIDEO_BASE,r0
                mov     #0,r1
                mov.l   CLRCOUNT,r2
1:              mov.l   r1,@r0
                dt      r2
                bf/s    1b
                add     #4,r0
.endif

                ! generate xor-texture
                mov.l   TEXTURE,r1
                mov.l   TWIDTH,r2
xory:           mov     r2,r5
                shlr2   r5
                mov.l   TWIDTH,r3
xorx:           mov     r3,r4
                shlr2   r4
                xor     r5,r4
                mov.b   r4,@r1
                add     #1,r1
                dt      r3
                bf      xorx
                dt      r2
                bf      xory

                mov     #1,r12
.ifdef DEBUG
                mov     #127,r13
.endif
loop:           lds     r12,fpul
                float   fpul,fr4
                mov     #20,r14
                lds     r14,fpul
                float   fpul,fr5
                fdiv    fr5,fr4
                mova    PI_SCALE,r0
                fmov    @r0,fr6
                fmul    fr6,fr4
                ftrc    fr4,fpul
                fsca    fpul,dr0
                fmov    fr0,fr7
                fmov    fr1,fr8
                lds     r12,fpul
                float   fpul,fr4
                mov     #10,r14
                lds     r14,fpul
                float   fpul,fr5
                fdiv    fr5,fr4
                fmul    fr6,fr4
                ftrc    fr4,fpul
                fsca    fpul,dr0
                mova    FP_SCALE,r0
                fmov    @r0,fr2
                fmul    fr0,fr3
                mova    FP_SCALE2,r0
                fmov    @r0,fr2
                fadd    fr2,fr3
                fmul    fr3,fr7
                fmul    fr3,fr8
                ftrc    fr7,fpul
                sts     fpul,r1
                ftrc    fr8,fpul
                sts     fpul,r2
                mov.l   WIDTH,r5
                shlr    r5
                mul.l   r1,r5
                sts     macl,r3
                neg     r3,r3
                mul.l   r2,r5
                sts     macl,r4
                neg     r4,r4
                mov     r4,r5
                sub     r3,r4
                add     r5,r3
                mov.l   VIDEO_RAM,r0
                mov.l   HEIGHT,r5
yloop:
                mov.l   WIDTH,r6
                mov     r3,r7           ! sin
                mov     r4,r8           ! cos
xloop:
!               mov.l   VIDEO_RAM,r0
                mov.l   TEXTURE,r9
                mov     #0xFF,r11
                extu.b  r11,r11
                mov     r7,r10
                shlr16  r10
                and     r11,r10
                add     r10,r9
                mov     r8,r10
                shlr16  r10
                and     r11,r10
                shll8   r10
                add     r10,r9
                mov.b   @r9,r10
                mov.w   r10,@r0
                add     #2,r0
                add     r1,r7
                add     r2,r8
                dt      r6
                bf      xloop
                add     r2,r3
                sub     r1,r4
                mov.l   LINEADD,r10
                add     r10,r0
                dt      r5
                bf      yloop
                add     #1,r12
.ifdef DEBUG
                cmp/hi  r13,r12
                bf      loop
                mov.l   dcload_syscall,r0
                mov.l   @r0,r0
                jmp     @r0
                mov     #15,r4
                .align  4
dcload_syscall: .long   0x8C004008
.else
                bra     loop
                nop
.endif

                .align  4
CLRCOUNT:       .long   640*480/2
VIDEO_BASE:     .long   0xA5000000
TWIDTH:         .long   256
LINEADD:        .long   (640-320)*2
WIDTH:          .long   320
HEIGHT:         .long   240
VIDEO_RAM:      .long   VIDEO_BASE+(640-320)+240*640
TEXTURE:        .long   0x0CF00000
PI_SCALE:       .float  10430.37835     ! 32768 / PI
FP_SCALE:       .float  65536.0
FP_SCALE2:      .float  16384.0


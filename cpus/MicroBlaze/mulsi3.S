
//
// linux-4.4.14/arch/microblaze/lib/mulsi3.S
//

#define __ASSEMBLER__ 1

#
# multiply operation for 32-bit integers
#
# input:  operand1 in r5
#         operand2 in r6
# output: operand1 * operand2 in r3
#

                .sect   .text,"ax"
                .global __mulsi3
                .type   __mulsi3,@function
                .ent    __mulsi3

__mulsi3:
                .frame  r1,0,r15
                add     r3,r0,r0
                beqi    r5,zeroresult                   # operand1 is 0
                beqi    r6,zeroresult                   # operand2 is 0
                bgeid   r5,r5_positive
                xor     r4,r5,r6                        # r4 has the same sign of the result
                rsubi   r5,r5,0                         # r5 is now positive
r5_positive:    bgei    r6,r6_positive
                rsubi   r6,r6,0                         # r6 is now positive
r6_positive:    bri     $L1
$L2:            add     r5,r5,r5
$L1:            srl     r6,r6
                addc    r7,r0,r0
                beqi    r7,$L2
                bneid   r6,$L2
                add     r3,r3,r5
                blti    r4,negateresult
                rtsd    r15,8
                nop
negateresult:   rtsd    r15,8
                rsub    r3,r3,r0
zeroresult:     rtsd    r15,8
                addi    r3,r0,0

                .size   __mulsi3,.-__mulsi3
                .end    __mulsi3


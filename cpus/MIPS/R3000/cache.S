
#include <mips.h>

                .sect   .text,"ax"

////////////////////////////////////////////////////////////////////////////////
// size_cache
////////////////////////////////////////////////////////////////////////////////

                .equ    MINCACHE,128
                .equ    MAXCACHE,0x40000

                .type   size_cache,@function
                .global size_cache
size_cache:

                .set    push
                .set    noreorder
                mfc0    $t0,CP0_SR              // save current SR
                and     $t0,~SR_PE              // do not inadvertently clear PE
                or      $t1,$t0,SR_IsC          // isolate cache
                or      $a0,$t1
                mtc0    $a0,CP0_SR
                // first check if there is a cache there at all
                move    $v0,$zero
                li      $v1,0xA5A5A5A5          // distinctive pattern
                sw      $v1,K0BASE              // try to write into cache
                lw      $t1,K0BASE              // try to read from cache
                mfc0    $t2,CP0_SR
                and     $t2,SR_CM
                bne     $t2,$zero,3f            // cache miss, must be no cache
                nop
                bne     $v1,$t1,3f              // data not equal -> no cache
                nop
                // clear cache size boundaries to known state
                li      $v0,MINCACHE
1:              sw      $zero,K0BASE($v0)
                sll     $v0,1
                ble     $v0,MAXCACHE,1b
                nop
                //
                li      $v0,-1
                sw      $v0,K0BASE($zero)       // store marker in cache
                li      $v0,MINCACHE            // MIN cache size
2:              lw      $v1,K0BASE($v0)         // look for marker
                nop                             // delay slot
                bne     $v1,$zero,3f            // found marker
                nop
                sll     $v0,1                   // cache size * 2
                ble     $v0,MAXCACHE,2b         // keep looking
                nop
                move    $v0,$zero               // must be no cache
                // invalidate
3:              li      $v1,MINCACHE
4:              sb      $zero,K0BASE($v1)
                sll     $v1,1
                ble     $v1,MAXCACHE,4b
                nop
                // invalida 128, che per l'appunto è l'address del console descriptor
                //li      $t1,K0BASE
                //sb      $zero,128($t1)
                mtc0    $t0,CP0_SR              // restore SR
                jr      $ra
                nop
                .set    pop

                .size   size_cache,.-size_cache

#if 0

////////////////////////////////////////////////////////////////////////////////
// invalidate_cache
////////////////////////////////////////////////////////////////////////////////

                .type   invalidate_cache,@function
                .global invalidate_cache
invalidate_cache:

                lw t1,icache_size
                lw t2,dcache_size
                .set noreorder
                mfc0 t3,C0_SR
                # save SR
                and t3,~SR_PE
                # dont inadvertently clear PE
                nop
                nop
                li v0,SR_ISC|SR_SWC# disable intr, isolate and swap
                mtc0 v0,C0_SR
                .set reorder
                bltu t1,a1,1f
                # cache is smaller than region
                move t1,a1
1:              addu t1,a0  # ending address + 1
                move t0,a0
                sb zero,0(t0)
                sb zero,4(t0)
                sb zero,8(t0)
                sb zero,12(t0)
                sb zero,16(t0)
                sb zero,20(t0)
                sb zero,24(t0)
                addu t0,32
                sb zero,-4(t0)
                bltu t0,t1,1b
                .set noreorder
                mtc0 t3,C0_SR
                # un-isolate, enable interrupts
                .set reorder
                j ra


/*
* flush data cache
*/
                .set    noreorder
                nop
                li      $v0,SR_ISC              # isolate and swap back caches
                mtc0    $v0,C0_SR
                nop
                .set    reorder
                bltu    $t2,$a1,1f              # cache is smaller than region
                move    $t2,$a1
1:              addu    $t2,$a0                 # ending address + 1
                move    $t0,$a0
1:              sb      $zero,0($t0)
                sb      $zero,4($t0)
                sb      $zero,8($t0)
                sb      $zero,12($t0)
                sb      $zero,16($t0)
                sb      $zero,20($t0)
                sb      $zero,24($t0)
                addu    $t0,32
                sb      $zero,-4($t0)
                bltu    $t0,$t2,1b
                .set    noreorder
                mtc0    $t3,C0_SR
                # un-isolate, enable interrupts
                .set    reorder
                j       $ra

                .size   invalidate_cache,.-invalidate_cache

////////////////////////////////////////////////////////////////////////////////

#if 0
                .sect   .data

dcache_size:    .long   0
icache_size:    .long   0

#endif

#endif


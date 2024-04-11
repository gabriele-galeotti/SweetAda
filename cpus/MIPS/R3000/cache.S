
#include <mips.h>

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
                nop
                mfc0    $t2,CP0_SR
                nop
                .set    reorder
                and     $t2,SR_CM
                bne     $t2,$zero,3f            // cache miss, must be no cache
                bne     $v1,$t1,3f              // data not equal -> no cache
                // clear cache size boundaries to known state
                li      $v0,MINCACHE
1:              sw      $zero,K0BASE($v0)
                sll     $v0,1
                ble     $v0,MAXCACHE,1b
                li      $v0,-1
                sw      $v0,K0BASE($zero)       // store marker in cache
                li      $v0,MINCACHE            // MIN cache size
2:              lw      $v1,K0BASE($v0)         // look for marker
                bne     $v1,$zero,3f            // found marker
                sll     $v0,1                   // cache size * 2
                ble     $v0,MAXCACHE,2b         // keep looking
                move    $v0,$zero               // must be no cache
                .set    noreorder
3:              mtc0    $t0,CP0_SR              // restore SR
                jr      $ra
                nop
                .set    pop

                .size   size_cache,.-size_cache


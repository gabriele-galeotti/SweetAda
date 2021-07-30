
//
// linux-4.4.14/arch/arm/lib/muldi3.S
//
// __INF__ changed: ret lr --> bx lr
//

#if defined(__ARMEB__)
# define xh r0
# define xl r1
# define yh r2
# define yl r3
#else
# define xl r0
# define xh r1
# define yl r2
# define yh r3
#endif

                .syntax unified

                .global __muldi3
__muldi3:
                .global __aeabi_lmul
__aeabi_lmul:

                mul     xh,yl,xh
                mla     xh,xl,yh,xh
                mov     ip,xl,lsr #16
                mov     yh,yl,lsr #16
                bic     xl,xl,ip,lsl #16
                bic     yl,yl,yh,lsl #16
                mla     xh,yh,ip,xh
                mul     yh,xl,yh
                mul     xl,yl,xl
                mul     ip,yl,ip
                adds    xl,xl,yh,lsl #16
                adc     xh,xh,yh,lsr #16
                adds    xl,xl,ip,lsl #16
                adc     xh,xh,ip,lsr #16
#if defined(__ARM_ARCH_3__) || defined(__ARM_ARCH_4__)
                mov     pc,lr
#else
                bx      lr      // __INF__ was: ret lr
#endif



#define MMU_BLOCK_DESCRIPTOR 0x2
#define MMU_TABLE_DESCRIPTOR 0x3
#define MMU_PAGE_DESCRIPTOR  0x3

// size of memory in TTBR0_EL2
#define TCR_T0SZ_31 (0x21<<0)
// Normal memory, Inner Write-Back Read-Allocate Write-Allocate Cacheable
#define TCR_IRGN0   (1<<8)
// Normal memory, Outer Write-Back Read-Allocate Write-Allocate Cacheable
#define TCR_ORGN0   (1<<10)
// Inner Shareable
#define TCR_SH0     (0x3<<12)



#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

/* imported as procedure "Ctest" */
void
ctest(void)
{
        const char *number = "5687";
        long        n;

        n = strtol(number, NULL, 10);
        if (n == 5687)
        {
                printf("strtol() test: OK\n");
        }

        printf("%s: %ld\n", "ld 80000000", 0x80000000L);
        printf("%s: %lu\n", "lu 80000000", 0x80000000UL);
        printf("%s: %hd\n", "hd 8000", (unsigned int)0x8000);
        printf("%s: %hu\n", "hu 8000", (unsigned int)0x8000);
}


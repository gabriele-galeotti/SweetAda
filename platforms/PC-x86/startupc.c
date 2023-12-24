
#include <stdio.h>

void __attribute__((__section__(".startup")))
startup(void)
{
}

/* imported as procedure "Ctest" */
void
ctest(void)
{
        printf("C test OK.\n");
}


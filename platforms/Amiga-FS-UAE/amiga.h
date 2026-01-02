
#ifndef _AMIGA_H
#define _AMIGA_H 1

#define CIAA_PRA  0x00BFE001 // Port A
#define CIAA_DDRA 0x00BFE201 // Data Direction Port A

// Kickstart services
#define EXECBASE    4
#define SUPERSTATE  -150 // 0xFFFFFF6A
#define OPENLIBRARY -552 // 0xFFFFFDD8
#define LVODoIO     -456 // 0xFFFFFE38
#define CMD_READ    2
#define IO_COMMAND  28
#define IO_LENGTH   36
#define IO_DATA     40
#define IO_OFFSET   44

#define LVOFindConfigDev -72  // 0xFFFFFFB8
#define LVOCloseLibrary  -414 // 0xFFFFFE62

#define ER_TYPE         0
#define ER_PRODUCT      1
#define ER_FLAGS        2
#define ER_MANUFACTURER 4

#define CD_ROM       16
#define CD_BOARDADDR 32

#endif /* _AMIGA_H */


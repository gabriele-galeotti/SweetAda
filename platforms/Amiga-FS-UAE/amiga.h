
#ifndef _AMIGA_H
#define _AMIGA_H 1

#define CIAA_PRA  0x00BFE001 // Port A
#define CIAA_DDRA 0x00BFE201 // Data Direction Port A

// LVOs
#define ExecBase 4
// exec.library
#define _LVOSupervisor   -30
#define _LVOSuperState   -150
#define _LVOCloseLibrary -414
#define _LVODoIO         -456
#define   CMD_READ   2
#define   IO_COMMAND 28
#define   IO_LENGTH  36
#define   IO_DATA    40
#define   IO_OFFSET  44
#define _LVOOpenLibrary  -552

#endif /* _AMIGA_H */



proc MGC_reset {} {
    write_memory 0x40064000 8 0x04 ;# MCG_C1
    write_memory 0x40064004 8 0x00 ;# MCG_C5
    write_memory 0x40064005 8 0x00 ;# MCG_C6
    write_memory 0x40064006 8 0x10 ;# MCG_S
    write_memory 0x40064008 8 0x02 ;# MCG_SC
    write_memory 0x4006400A 8 0x00 ;# MCG_ATCVH
    write_memory 0x4006400B 8 0x00 ;# MCG_ATCVL
    write_memory 0x4006400C 8 0x00 ;# MCG_C7
    write_memory 0x4006400D 8 0x80 ;# MCG_C8
    write_memory 0x4006400E 8 0x00 ;# MCG_C9
    write_memory 0x4006400F 8 0x00 ;# MCG_C10
    }

proc SIM_reset {} {
    write_memory 0x40047004 32 0x00000000 ;# SIM_SOPT1CFG
    write_memory 0x40048004 32 0x00000000 ;# SIM_SOPT2
    write_memory 0x4004800C 32 0x00000000 ;# SIM_SOPT4
    write_memory 0x40048010 32 0x00000000 ;# SIM_SOPT5
    write_memory 0x40048018 32 0x00000000 ;# SIM_SOPT7
    write_memory 0x40048034 32 0xF0000030 ;# SIM_SCGC4
    write_memory 0x40048038 32 0x00000182 ;# SIM_SCGC5
    write_memory 0x4004803C 32 0x00000001 ;# SIM_SCGC6
    write_memory 0x40048040 32 0x00000100 ;# SIM_SCGC7
    write_memory 0x40048100 32 0x0000000C ;# SIM_COPC
    write_memory 0x40048104 32 0x00000000 ;# SIM_SRVCOP
    }

halt
MGC_reset
SIM_reset

# we specify "-noload" in configuration.in, so we have to download explicitly
# the executable in the target memory
load_image $sweetada_elf

# we specify "-noexec" in configuration.in, so we have to resume explicitly
# the target CPU (only if we do not specify "-debug")
if {$debug_mode eq 0} {
    resume $start_address
}


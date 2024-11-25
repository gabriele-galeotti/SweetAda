
debug_level 1

puts stdout ""
puts stdout "********************"
puts stdout "* starting OpenOCD *"
puts stdout "********************"
if {$debug_mode ne 0} {
    puts stdout "MODE = DEBUG"
} else {
    puts stdout "MODE = RUN"
}
puts stdout ""

puts stdout "reset/halt CPU ..."
targets bcm2837.cpu0 ; halt
targets bcm2837.cpu1 ; halt
targets bcm2837.cpu2 ; halt
targets bcm2837.cpu3 ; halt

# default CPU #0
targets bcm2837.cpu0

# mask DAIF
dict set cpsr_register cpsr [
    expr {[dict get [get_reg cpsr] cpsr] | 0x000003C0}
    ]
set_reg $cpsr_register

puts stdout [targets]

# we specify "-noload" in configuration.in, so we have to download explicitly
# the executable in the target memory
puts stdout "loading $sweetada_elf ..."
load_image $sweetada_elf
puts stdout "start address: $start_address"

# we specify "-noexec" in configuration.in, so we have to resume explicitly
# the target CPU (only if we do not specify "-debug")
if {$debug_mode eq 0} {
    puts stdout "starting CPU @ $start_address"
    targets bcm2837.cpu0 ; resume $start_address
    targets bcm2837.cpu1 ; resume $start_address
    targets bcm2837.cpu2 ; resume $start_address
    targets bcm2837.cpu3 ; resume $start_address
    targets bcm2837.cpu0
}


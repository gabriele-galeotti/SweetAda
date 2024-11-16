
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
targets

# we specify "-noload" in configuration.in, so we have to download explicitly
# the executable in the target memory
puts stdout "loading $sweetada_elf ..."
load_image $sweetada_elf
puts stdout "start address: $start_address"

# we specify "-noexec" in configuration.in, so we have to resume explicitly
# the target CPU (only if we do not specify "-debug")
if {$debug_mode eq 0} {
    puts stdout "starting CPU @ $start_address"
    resume $start_address
}


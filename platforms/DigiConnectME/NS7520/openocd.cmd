
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

# hard reset (needs complete re-initialization)
#puts stdout "reset CPU (hard reset) ..."
#reset init
# soft reset
puts stdout "reset CPU (soft reset) ..."
soft_reset_halt

puts stdout "CPU is "[NS7520.cpu curstate]
puts stdout [arm core_state]

# we specify "-noload" in configuration.in, so we have to download explicitly
# the executable in the target memory
puts stdout "loading $sweetada_elf ..."
load_image $sweetada_elf
#verify_image .../kernel.o 0
puts stdout "start address: $start_address"

# we specify "-noexec" in configuration.in, so we have to resume explicitly
# the target CPU (only if we do not specify "-debug")
if {$debug_mode eq 0} {
    puts stdout "starting CPU @ $start_address"
    resume $start_address
}


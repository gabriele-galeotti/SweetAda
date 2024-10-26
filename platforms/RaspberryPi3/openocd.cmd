
halt

# we specify "-noload" in configuration.in, so we have to download explicitly
# the executable in the target memory
load_image $sweetada_elf

# we specify "-noexec" in configuration.in, so we have to resume explicitly
# the target CPU (only if we do not specify "-debug")
if {$debug_mode eq 0} {
    resume $start_address
}


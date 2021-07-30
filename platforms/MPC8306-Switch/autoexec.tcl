
#
# This file will be sourced by ccsapi.tcl.
#

################################################################################
#                                                                              #
################################################################################

puts "Executing autoexec.tcl ..."

set COMESA_SWITCH_PATH "/root/project/technical/devices/COMESA_Switch"
set SWEETADA_PATH "/root/project/sweetada"

puts "Loading utilities.tcl ..."
source utilities.tcl

findcc utaps
# preferred USB TAP: #12022069
#config cc utap:11070407
#config cc utap:12022034
config cc utap:12022069
show cc

puts "Loading switch.tcl ..."
source [file join $COMESA_SWITCH_PATH switch.tcl]
puts "Loading kernel.rom ..."
loadbinaryfile [file join $SWEETADA_PATH kernel.rom]

ccs::display_mem 0 0x0 4 4 0x20
ccs::display_core_run_mode 0
ccs::stat
ccs::write_reg 0 iar 0
ccs::write_reg 0 iabr 0
ccs::run_core 0


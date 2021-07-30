#!/bin/sh

#
# QEMU "qemu-ifup.sh" network script.
#

#
# Arguments:
# none
#
# Environment variables:
# QEMU_IPADDRESS
# TUNTAP_NOARP
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

set -o posix
SCRIPT_FILENAME=$(basename "$0")
LOG_FILENAME=""

################################################################################
# log_print()                                                                  #
#                                                                              #
################################################################################
log_print()
{
if [ "x${LOG_FILENAME}" != "x" ] ; then
  printf "%s\n" "$1" | tee -a "${LOG_FILENAME}"
else
  printf "%s\n" "$1"
fi
return 0
}

################################################################################
# log_print_error()                                                            #
#                                                                              #
################################################################################
log_print_error()
{
if [ "x${LOG_FILENAME}" != "x" ] ; then
  printf "%s\n" "$1" | tee -a "${LOG_FILENAME}" 1>&2
else
  printf "%s\n" "$1" 1>&2
fi
return 0
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

if [ "x${QEMU_IPADDRESS}" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: QEMU_IPADDRESS is not set."
  exit 1
fi

if [ "x${TUNTAP_NOARP}" = "xY" ] ; then
  NOARP="-arp"
else
  NOARP=
fi

ifconfig $1 ${QEMU_IPADDRESS} up ${NOARP}
if [ $? -ne 0 ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: ifconfig-uring TUN/TAP interface $1 @ ${QEMU_IPADDRESS}."
  exit 1
fi

log_print "${SCRIPT_FILENAME}: TUN/TAP interface $1 @ ${QEMU_IPADDRESS}"

exit 0


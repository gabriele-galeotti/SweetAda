#!/usr/bin/env sh

#
# Raspberry™ Pi 3 boot device creation.
#
# Copyright (C) 2020-2025 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# -h            help
# -d DEVICE     block device name (without -u option)
# -u UUID       block device UUID (without -d option)
# -m MOUNTPOINT filesystem mountpoint
# <filename>    executable filename
#
# Environment variables:
# none
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

SCRIPT_FILENAME=$(basename "$0")

################################################################################
# usage()                                                                      #
#                                                                              #
################################################################################
usage()
{
printf "%s\n" "Usage:"
printf "%s\n" "createbootdevice [-h] -d DEVICE|-u UUID -m MOUNTPOINT <filename>"
printf "%s\n" "-h              help"
printf "%s\n" "-d DEVICE       block device to be used (e.g., /dev/sdcard1)"
printf "%s\n" "-u UUID         use the device UUID as shown by the \"blkid\" utility (e.g., 3FFC-F14C)"
printf "%s\n" "-m MOUNTPOINT   MOUNTPOINT is the filesystem location where the device will be mounted"
printf "%s\n" "filename        executable filename to be stored in the device"
printf "%s\n" ""
return 0
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

DEVICE=
UUID=
MOUNTPOINT=
FILENAME=

#
# Parse command line arguments.
#
token_seen=N
while [ $# -gt 0 ] ; do
  if [ "x${1:0:1}" = "x-" ] ; then
    # "-" option
    argument=${1:1}
    case ${argument} in
      "h")
        usage
        exit $?
        ;;
      "d")
        if [ "x${UUID}" != "x" ] ; then
          printf "%s\n" "*** Error: only one of -d or -u option must be specified." 1>&2
          usage
          exit 1
        fi
        shift
        DEVICE="$1"
        ;;
      "u")
        if [ "x${DEVICE}" != "x" ] ; then
          printf "%s\n" "*** Error: only one of -d or -u option must be specified." 1>&2
          usage
          exit 1
        fi
        shift
        UUID="$1"
        ;;
      "m")
        shift
        MOUNTPOINT="$1"
        ;;
      *)
        printf "%s\n" "*** Error: unknown option \"${argument}\"." 1>&2
        usage
        exit 1
        ;;
    esac
  else
    # no "-" option
    if [ "x${token_seen}" = "xN" ] ; then
      token_seen=Y
      FILENAME="$1"
    else
      printf "%s\n" "*** Error: multiple files specified." 1>&2
      usage
      exit 1
    fi
  fi
  shift
done

#
# Check parameters.
#
if [ "x${DEVICE}" = "x" ] && [ "x${UUID}" = "x" ] ; then
  printf "%s\n" "*** Error: no -d nor -u option specified." 1>&2
  usage
  exit 1
fi
if [ "x${FILENAME}" = "x" ] ; then
  printf "%s\n" "*** Error: no executable filename." 1>&2
  usage
  exit 1
fi
if [ "x${UUID}" != "x" ] ; then
  DEVICE=$(blkid                                | \
           grep -e "UUID=\"${UUID}\""           | \
           sed -e "s|^\(/dev/.*\)\(:.*\)\$|\1|"   \
          )
  if [ "x${DEVICE}" = "x" ] ; then
    printf "%s\n" "*** Error: UUID=${UUID}: no device found." 1>&2
    exit 1
  fi
fi

#
# Install an executable on FAT32 1st partition.
#

mount ${DEVICE} ${MOUNTPOINT} || exit 1

cat > ${MOUNTPOINT}/config.txt << EOF
arm_64bit=1                     # ARMv8 mode
core_freq=250                   # core clock frequency
arm_freq=250                    # ARM clock frequency
kernel=$(basename ${FILENAME})
enable_jtag_gpio=1              # enable JTAG (GPIO22..27)
EOF
if [ $? -ne 0 ] ; then
  umount ${MOUNTPOINT}
  exit 1
fi

cp -f -v ${FILENAME} ${MOUNTPOINT}/
if [ $? -ne 0 ] ; then
  umount ${MOUNTPOINT}
  exit 1
fi

sync ; sync

umount ${MOUNTPOINT} || exit 1

exit 0


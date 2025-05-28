#!/usr/bin/env sh

#
# SweetAda linker.ad[s|b] generator.
#
# Copyright (C) 2020-2025 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = linker script filename
#
# Environment variables:
# CORE_DIRECTORY
# KERNEL_PARENT_PATH
#

#
# LINKERADSB:<symbol_name>:<Ada_identifier>
#
# symbol_name: linker symbol name
# Ada_identifier: Ada identifier name
#

# shellcheck disable=SC2086,SC2268

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

SCRIPT_FILENAME=$(basename "$0")
LOG_FILENAME=""
if [ "x${LOG_FILENAME}" != "x" ] ; then
  rm -f "${LOG_FILENAME}"
  touch "${LOG_FILENAME}"
fi

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

#
# Basic input parameters check.
#
LINKER_SCRIPT="$1"
if [ "x${LINKER_SCRIPT}" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: no linker script specified."
  exit 1
fi

textlines=$(                                             \
            grep -e "LINKERADSB:" ${LD_SCRIPT}         | \
            sed -e "s|.*\(LINKERADSB:.*:[^ ]*\).*|\1|"   \
           )
if [ "x${textlines}" = "x" ] ; then
  exit 0
fi

PACKAGE=Linker
OUTPUT_FILENAME_ADS=${KERNEL_PARENT_PATH}/${CORE_DIRECTORY}/linker.ads
OUTPUT_FILENAME_ADB=${KERNEL_PARENT_PATH}/${CORE_DIRECTORY}/linker.adb

NL=$(printf "\n%s" "_") ; NL=${NL%_}

linkerads=""
linkeradb=""
indent="   "

linkerads=${linkerads}${NL}
linkerads=${linkerads}"with System.Storage_Elements;"${NL}
linkerads=${linkerads}${NL}
linkerads=${linkerads}"package ${PACKAGE}"${NL}
linkerads=${linkerads}"${indent}with Pure       => True,"${NL}
linkerads=${linkerads}"${indent}     SPARK_Mode => On"${NL}
linkerads=${linkerads}"${indent}is"${NL}
linkerads=${linkerads}${NL}
linkeradb=${linkeradb}${NL}
linkeradb=${linkeradb}"with Bits;"${NL}
linkeradb=${linkeradb}${NL}
linkeradb=${linkeradb}"package body ${PACKAGE}"${NL}
linkeradb=${linkeradb}"${indent}is"${NL}
linkeradb=${linkeradb}${NL}
linkeradb=${linkeradb}"${indent}type Symbol_Type is new Bits.Null_Object"${NL}
linkeradb=${linkeradb}"${indent}   with Convention => Asm;"${NL}
linkeradb=${linkeradb}${NL}
for t in ${textlines} ; do
  IFS=':' read -r tag symbol_name Ada_identifier << EOF
${t}
EOF
  linkerads=${linkerads}"${indent}function ${Ada_identifier}"${NL}
  linkerads=${linkerads}"${indent}   return System.Storage_Elements.Integer_Address"${NL}
  linkerads=${linkerads}"${indent}   with Inline => True;"${NL}
  linkerads=${linkerads}${NL}
  linkeradb=${linkeradb}"${indent}function ${Ada_identifier}"${NL}
  linkeradb=${linkeradb}"${indent}   return System.Storage_Elements.Integer_Address"${NL}
  linkeradb=${linkeradb}"${indent}   is"${NL}
  linkeradb=${linkeradb}"${indent}   Symbol : aliased constant Symbol_Type"${NL}
  linkeradb=${linkeradb}"${indent}      with Import    => True,"${NL}
  linkeradb=${linkeradb}"${indent}           Link_Name => \"${symbol_name}\";"${NL}
  linkeradb=${linkeradb}"${indent}begin"${NL}
  linkeradb=${linkeradb}"${indent}   return System.Storage_Elements.To_Integer (Symbol'Address);"${NL}
  linkeradb=${linkeradb}"${indent}end ${Ada_identifier};"${NL}
  linkeradb=${linkeradb}${NL}
done
linkerads=${linkerads}$(printf "%s\n" "end ${PACKAGE};")${NL}
linkeradb=${linkeradb}$(printf "%s\n" "end ${PACKAGE};")${NL}

printf "%s" "${linkerads}" > ${OUTPUT_FILENAME_ADS}
log_print "${SCRIPT_FILENAME}: linker.ads: done."

printf "%s" "${linkeradb}" > ${OUTPUT_FILENAME_ADB}
log_print "${SCRIPT_FILENAME}: linker.adb: done."

exit 0


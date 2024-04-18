#!/usr/bin/env sh

#
# SweetAda GCC defines generator.
#
# Copyright (C) 2020-2024 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1     = package name
# $2     = output filename
# $3..$n = list of GCC macro define specifications
#
# Environment variables:
# TOOLCHAIN_CC
# CC_SWITCHES_RTS
# GCC_SWITCHES_PLATFORM
#

#
# <GCC_define>:<Ada_identifier>:<type>:<specifier>
#
# GCC_define: macro name
# Ada_identifier: Ada identifier name
# type: Ada type (empty = untyped)
# specifier:
#  B - Boolean (soft): True if defined, else False
#  H - Boolean (hard): True if defined and <> 0, else False
#  N - constant/Integer: value, else -1
#  P - constant/Integer: value if > 0, else -1
#  S - String: value, else ""
#

# shellcheck disable=SC2181,SC2268

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
PACKAGE_NAME="$1"
if [ "x${PACKAGE_NAME}" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: no package name specified."
  exit 1
fi
shift
OUTPUT_FILENAME="$1"
if [ "x${OUTPUT_FILENAME}" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: no output filename specified."
  exit 1
fi
shift
if [ "x$1" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: no items specified."
  exit 1
fi

max_tmacro_length=0
max_type_length=7
for i in "$@" ; do
  IFS=":" read -r i_macro i_tmacro i_type i_spec << EOF
${i}
EOF
  if [ "x${i_macro}" = "x" ] || [ "x${i_tmacro}" = "x" ] ; then
    log_print_error "${SCRIPT_FILENAME}: *** Error: no item definition."
    exit 1
  fi
  case ${i_spec} in
    B|H|N|P|S)
      ;;
    *)
      log_print_error "${SCRIPT_FILENAME}: *** Error: no item specifier."
      exit 1
      ;;
  esac
  tm_length=${#i_tmacro}
  if [ $((tm_length)) -gt $((max_tmacro_length)) ] ; then
    max_tmacro_length=${tm_length}
  fi
  t_length=${#i_type}
  if [ $((t_length)) -gt $((max_type_length)) ] ; then
    max_type_length=${t_length}
  fi
done
if [ $((max_type_length)) -gt 0 ] ; then
  max_type_length=$((max_type_length+1))
fi

indent="   "
format_string="%-${max_tmacro_length}s : constant %-${max_type_length}s:= %s;"

gcc_output=$(                                                                             \
             printf "%s\n" "void ___(void) { }"                                         | \
             ${TOOLCHAIN_CC} ${CC_SWITCHES_RTS} ${GCC_SWITCHES_PLATFORM} -E -P -dM -c -
            )
exit_status=$?
if [ "${exit_status}" != "0" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: GCC error."
  exit ${exit_status}
fi
gcc_output=$(                                                                     \
             printf "%s" "${gcc_output}"                                        | \
             sed -e "s|^\(#define *\)\([A-Za-z_][0-9A-Za-z_]*\) *\(.*\)|\2=\3|"   \
            )

rm -f ${OUTPUT_FILENAME}
touch ${OUTPUT_FILENAME}

{                                                  \
 printf "%s\n" ""                                ; \
 printf "%s\n" "package ${PACKAGE_NAME}"         ; \
 printf "%s%s\n" "${indent}" "with Pure => True" ; \
 printf "%s%s\n" "${indent}" "is"                ; \
 printf "%s\n" ""                                ; \
} >> ${OUTPUT_FILENAME}

for i in "$@" ; do
  IFS=":" read -r i_macro i_tmacro i_type i_spec << EOF
${i}
EOF
  #printf "%s-- %s\n" "${indent}" "${i_macro}" >> ${OUTPUT_FILENAME}
  printf "%s\n" "${gcc_output}" | \
  (
   found=
   while IFS= read -r line ; do
     IFS="=" read -r macro value << EOF
${line}
EOF
     if [ "${i_macro}" = "${macro}" ] ; then
       found=Y
       case ${i_spec}${i_type} in
         BBoolean)   value="True" ;;
         HBoolean)   if [ $((value)) -ne 0 ] ; then value="True" ; else value="False" ; fi ;;
         N|NInteger) if [ "x${value}" = "x" ] ; then value="-1" ; fi ;;
         P|PInteger) if [ $((value)) -lt 1 ] ; then value="-1" ; fi ;;
         SString)    if [ "x${value}" = "x" ] ; then value="\"\"" ; fi ;;
         *)
           log_print_error "${SCRIPT_FILENAME}: *** Error: inconsistent item specification."
           exit 1
           ;;
       esac
       printf "%s${format_string}\n" "$indent" "${i_tmacro}" "${i_type}" "${value}" \
         >> ${OUTPUT_FILENAME}
       break
     fi
   done
   if [ "x${found}" = "xY" ] ; then
     exit 0
   else
     exit 1
   fi
  )
  if [ $? -ne 0 ] ; then
    case ${i_spec}${i_type} in
      BBoolean|HBoolean)     value="False" ;;
      N|NInteger|P|PInteger) value="-1" ;;
      SString)               value="\"\"" ;;
      *)
        log_print_error "${SCRIPT_FILENAME}: *** Error: inconsistent item specification."
        exit 1
        ;;
    esac
    printf "%s${format_string}\n" "$indent" "${i_tmacro}" "${i_type}" "${value}" \
      >> ${OUTPUT_FILENAME}
  fi
done

{                                   \
 printf "%s\n" ""                 ; \
 printf "%s\n" "end GCC_Defines;" ; \
} >> ${OUTPUT_FILENAME}

log_print "${SCRIPT_FILENAME}: ${OUTPUT_FILENAME}: done."

exit 0


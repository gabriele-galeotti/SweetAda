#!/usr/bin/env sh

#
# SweetAda *.gpr dependencies parser.
#
# Copyright (C) 2020-2023 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# optional starting "-u" = output sorted, not-duplicated units
# $1 = input filename
#
# Environment variables:
# OS
# MSYSTEM
#

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
if [ "x${OS}" = "xWindows_NT" ] ; then
  if [ "x${MSYSTEM}" = "x" ] ; then
    OSTYPE=cmd
  else
    OSTYPE=msys
  fi
else
  OSTYPE_UNAME=$(uname -s 2> /dev/null)
  if   [ "x${OSTYPE_UNAME}" = "xLinux" ] ; then
    OSTYPE=linux
  elif [ "x${OSTYPE_UNAME}" = "xDarwin" ] ; then
    OSTYPE=darwin
  else
    log_print_error "${SCRIPT_FILENAME}: *** Error: no valid OSTYPE."
    exit 1
  fi
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
# parse_gpr()                                                                  #
#                                                                              #
################################################################################
parse_gpr()
{
if [ ! -e $1 ] ; then
  return
fi
while IFS= read -r line ; do
  line=$(printf "%s" "${line}" | sed                \
          -e "s|^[[:blank:]]*||;s|[[:blank:]]*\$||" \
          -e "s|^[Ww][Ii][Tt][Hh]|with|"            \
        )
  case ${line} in
    --* | "")
      continue
      ;;
    with*)
      unit=$(printf "%s" "${line}" | sed -e "s|^with[[:blank:]]*\"\(.*\)\"[[:blank:]]*;.*\$|\1|")
      printf " %s.gpr" "${unit}"
      ;;
    *)
      break
      ;;
  esac
done < $1
}

################################################################################
# parse_recursive()                                                            #
#                                                                              #
################################################################################
parse_recursive()
(
for u in "$@" ; do
  units=$(parse_gpr ${u})
  if [ "${units}" != "" ] ; then
    printf "%s" " ${units}"
    parse_recursive ${units}
  fi
done
)

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

#
# Basic input parameters check.
#
if [ "x$1" = "x-u" ] ; then
  UNIQ_OUTPUT=Y
  shift
fi
INPUT_FILENAME="$1"
if [ "x${INPUT_FILENAME}" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: no input file specified."
  exit 1
fi

GPR_LIST=$(parse_recursive "${INPUT_FILENAME}")

if [ "x${UNIQ_OUTPUT}" = "xY" ] ; then
  GPR_LIST=$(printf "%s\n" "${GPR_LIST}" | tr " " "\n" | sort -u | tr "\n" " ")
fi

printf "%s\n" "${GPR_LIST}"

exit 0


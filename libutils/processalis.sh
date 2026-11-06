#!/usr/bin/env sh

#
# Process an ALI list file to remove a prefixed path.
#
# Copyright (C) 2020-2026 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = <filename>  ALI list filename
# -r <path_prefix> path prefix to be removed
#
# Environment variables:
# none
#

# shellcheck disable=SC2046,SC2086,SC2181,SC2268,SC2295,SC2329

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

ALIS_FILENAME=""
PATH_PREFIX_REMOVE=""

#
# Parse command line arguments.
#
while [ $# -gt 0 ] ; do
  argument="$1"
  if [ "x"$(printf "%.1s" "${argument}") = "x-" ] ; then
    # "-" option
    case "${argument}" in
      "-r")
        shift
        PATH_PREFIX_REMOVE="$1"
        ;;
      *)
        log_print_error "${SCRIPT_FILENAME}: *** Error: unknown option \"${argument}\"."
        exit 1
        ;;
    esac
  else
    if [ "x${ALIS_FILENAME}" = "x" ] ; then
      ALIS_FILENAME="$1"
    else
      log_print_error "${SCRIPT_FILENAME}: *** Error: too many input files."
      exit 1
    fi
  fi
  shift
done

if [ "x${ALIS_FILENAME}" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: no input file specified."
  exit 1
fi
if [ ! -e "./${ALIS_FILENAME}" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: ${ALIS_FILENAME} not found."
  exit 1
fi

NL=$(printf "\n%s" "_") ; NL=${NL%_}

alis=""

while IFS= read -r textline ; do
  if [ "x${PATH_PREFIX_REMOVE}" != "x" ] ; then
    textline=${textline#${PATH_PREFIX_REMOVE}/}
  fi
  alis=${alis}${textline}${NL}
done < "${ALIS_FILENAME}"

printf "%s" "${alis}" > ${ALIS_FILENAME}
if [ $? -ne 0 ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: in processing \"${ALIS_FILENAME}\"."
  exit 1
fi

exit 0


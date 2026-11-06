#!/usr/bin/env sh

#
# Process object filenames to create a proper list file for the linker.
#
# Copyright (C) 2020-2026 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = <filename>       object list filename
# -a <path_prefix>      prefix to be added to each object file
# -b <BUILD_MODE>       (ignored) "GNATMAKE" or "GPRBUILD"
# -i <ali_unit>         one for every ali instance
# -o <object_directory> (ignored) object directory
# -r <path_prefix>      prefix to be removed from each object file
#
# Environment variables:
# none
#

# shellcheck disable=SC2034,SC2046,SC2086,SC2181,SC2268,SC2295,SC2329

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

OBJS_FILENAME=""
PATH_PREFIX_ADD=""
BUILD_MODE=""
IMPLICIT_ALI_UNITS=""
OBJECT_DIRECTORY=""
PATH_PREFIX_REMOVE=""

#
# Parse command line arguments.
#
while [ $# -gt 0 ] ; do
  argument="$1"
  if [ "x"$(printf "%.1s" "${argument}") = "x-" ] ; then
    # "-" option
    case "${argument}" in
      "-a")
        shift
        PATH_PREFIX_ADD="$1"
        ;;
      "-b")
        shift
        BUILD_MODE="$1"
        ;;
      "-i")
        shift
        IMPLICIT_ALI_UNITS="$1 ${IMPLICIT_ALI_UNITS}"
        ;;
      "-o")
        shift
        OBJECT_DIRECTORY="$1"
        ;;
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
    if [ "x${OBJS_FILENAME}" = "x" ] ; then
      OBJS_FILENAME="$1"
    else
      log_print_error "${SCRIPT_FILENAME}: *** Error: too many input files."
      exit 1
    fi
  fi
  shift
done

if [ "x${OBJS_FILENAME}" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: no input file specified."
  exit 1
fi
if [ ! -e "./${OBJS_FILENAME}" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: ${OBJS_FILENAME} not found."
  exit 1
fi

NL=$(printf "\n%s" "_") ; NL=${NL%_}

objs=""

while IFS= read -r textline ; do
  found=
  for i in ${IMPLICIT_ALI_UNITS} ; do
    case "${textline}" in
      *${i})
        found=Y
        break
        ;;
      *)
        ;;
    esac
  done
  if [ "x${found}" = "x" ] ; then
    if [ "x${PATH_PREFIX_REMOVE}" != "x" ] ; then
      textline=${textline#${PATH_PREFIX_REMOVE}/}
    fi
    if [ "x${PATH_PREFIX_ADD}" != "x" ] ; then
      textline=${PATH_PREFIX_ADD}/${textline}
    fi
    objs=${objs}${textline}${NL}
  fi
done < "${OBJS_FILENAME}"

printf "%s" "${objs}" > ${OBJS_FILENAME}
if [ $? -ne 0 ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: in processing \"${OBJS_FILENAME}\"."
  exit 1
fi

exit 0


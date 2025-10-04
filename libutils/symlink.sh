#!/usr/bin/env sh

#
# Create a filesystem symbolic/soft link.
#
# Copyright (C) 2020-2025 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# optional initial -c (ignored)
# optional initial -m <filelist> to record symlinks
# optional initial -v for verbosity
# $1 = target filename or directory
# $2 = link name filename or directory
# every following pair is another symlink
#
# Environment variables:
# VERBOSE
#
# If the target is a directory, then link name should be a directory, and
# every file contained in the directory is made target of the correspondent
# symlink (with the same filename).
#

# shellcheck disable=SC2045,SC2046,SC2268,SC2317

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

FILELIST_FILENAME=

# parse command line arguments
while [ $# -gt 0 ] ; do
  argument="$1"
  if [ $(printf "%.1s" "${argument}") = "-" ] ; then
    # "-" option
    case "${argument}" in
      "-c")
        ;;
      "-m")
        shift
        FILELIST_FILENAME="$1"
        ;;
      "-v")
        VERBOSE=Y
        ;;
      *)
        log_print_error "${SCRIPT_FILENAME}: *** Error: unknown option \"${argument}\"."
        exit 1
        ;;
    esac
  else
    # no "-" option, start of symlink filenames
    break
  fi
  shift
done

# check environment variable or explicit argument
if [ "x${VERBOSE}" = "xY" ] ; then
  VERBOSE_OPTION="-v"
else
  VERBOSE_OPTION=""
fi

# check for at least one symlink target
if [ "x$1" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: no symlink target specified."
  exit 1
fi

# create filelist if specified
if [ "x${FILELIST_FILENAME}" != "x" ] ; then
  if [ ! -f "${FILELIST_FILENAME}" ] ; then
    printf "%s\n" "INSTALLED_FILENAMES :=" > "${FILELIST_FILENAME}"
  fi
fi

# loop as long as an argument exists
while true ; do
  TARGET="$1"
  # no initial argument of the pair, exit
  if [ "x${TARGET}" = "x" ] ; then
    break
  fi
  # then, the 2nd argument of the pair should exist
  if [ "x$2" = "x" ] ; then
    log_print_error "${SCRIPT_FILENAME}: *** Error: no symlink link name specified."
    exit 1
  fi
  # symlink file or whole directory
  if [ -f "${TARGET}" ] ; then
    LINK_NAME="$2"
    rm -f "${LINK_NAME}"
    ln -s ${VERBOSE_OPTION} "${TARGET}" "${LINK_NAME}" || exit $?
    if [ "x${FILELIST_FILENAME}" != "x" ] ; then
      printf "%s\n" "INSTALLED_FILENAMES += ${LINK_NAME}" >> "${FILELIST_FILENAME}"
    fi
  elif [ -d "${TARGET}" ] ; then
    LINK_DIRECTORY="$2"
    for f in $(ls -A "${TARGET}"/) ; do
      rm -f "${f}"
      ln -s ${VERBOSE_OPTION} "${TARGET}"/"${f}" "${LINK_DIRECTORY}"/"${f}" || exit $?
      if [ "x${FILELIST_FILENAME}" != "x" ] ; then
        printf "%s\n" "INSTALLED_FILENAMES += ${LINK_DIRECTORY}/${f}" >> "${FILELIST_FILENAME}"
      fi
    done
  else
    log_print_error "${SCRIPT_FILENAME}: *** Error: no file or directory \"${TARGET}\"."
    exit 1
  fi
  # shift to the next argument pair
  shift
  shift
done

exit 0


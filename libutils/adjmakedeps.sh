#!/usr/bin/env sh

#
# Makefile dependency file adjustment script for reverse variable reference.
#
# Copyright (C) 2020-2026 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# -kpp <path> = reverse-substitute a relative path for KERNEL_PARENT_PATH
# -obj <path> = reverse-substitute a target path for OBJ_DIRECTORY
#               ("+" force head-insertion)
# <filename>  = dependency file to adjust
#
# Environment variables:
# none
#

# shellcheck disable=SC2046,SC2268,SC2329

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

KERNEL_PARENT_PATH=""
TARGET_OBJ_PATH=""
DEP_FILENAME=""

#
# Parse command line arguments.
#
while [ $# -gt 0 ] ; do
  argument="$1"
  if [ "x"$(printf "%.1s" "${argument}") = "x-" ] ; then
    # "-" option
    case "${argument}" in
      "-kpp")
        shift
        KERNEL_PARENT_PATH="$1"
        ;;
      "-obj")
        shift
        TARGET_OBJ_PATH="$1"
        ;;
      *)
        log_print_error "${SCRIPT_FILENAME}: *** Error: unknown option \"${argument}\"."
        exit 1
        ;;
    esac
  else
    if [ "x${DEP_FILENAME}" = "x" ] ; then
      DEP_FILENAME="$1"
    else
      log_print_error "${SCRIPT_FILENAME}: *** Error: too many input files."
      exit 1
    fi
  fi
  shift
done

if [ "x${DEP_FILENAME}" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: no input filename specified."
  exit 1
fi

case "${TARGET_OBJ_PATH}" in
  "")
    cat "${DEP_FILENAME}"   \
    > "${DEP_FILENAME}.tmp"
    ;;
  +)
    cat "${DEP_FILENAME}"                          | \
    sed                                              \
      -e "s|^\(.* *: .*\)\$|\$(OBJ_DIRECTORY)/\1|"   \
    > "${DEP_FILENAME}.tmp"
    ;;
  *)
    cat "${DEP_FILENAME}"                           | \
    sed                                               \
      -e "s|${TARGET_OBJ_PATH}|\$(OBJ_DIRECTORY)|g"   \
    > "${DEP_FILENAME}.tmp"
    ;;
esac
mv -f "${DEP_FILENAME}.tmp" "${DEP_FILENAME}"
KERNEL_PARENT_PATH_SED=$(printf "%s" "${KERNEL_PARENT_PATH}" | sed -e "s|\.|\\\.|g")
case "${KERNEL_PARENT_PATH}" in
  "")
    cat "${DEP_FILENAME}"   \
    > "${DEP_FILENAME}.tmp"
    ;;
  *)
    cat "${DEP_FILENAME}"                                       | \
    sed                                                           \
      -e "s|${KERNEL_PARENT_PATH_SED}|\$(KERNEL_PARENT_PATH)|g"   \
    > "${DEP_FILENAME}.tmp"
    ;;
esac
mv -f "${DEP_FILENAME}.tmp" "${DEP_FILENAME}"

exit 0


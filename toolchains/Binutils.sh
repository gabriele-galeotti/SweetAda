#!/usr/bin/env sh

#
# SweetAda GNU/GNAT toolchain build.
#
# Copyright (C) 2020-2025 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

set -o posix
SCRIPT_FILENAME=$(basename "$0")

################################################################################
# configure()                                                                  #
#                                                                              #
################################################################################
function configure()
{
rm -f -r ${PACKAGE_BUILD_PATH}
mkdir -p ${PACKAGE_BUILD_PATH}
pushd ${PACKAGE_BUILD_PATH} > /dev/null
eval \
  "${CONFIGURE_VARS[@]}" ${PACKAGE_SOURCE_PATH}/configure "${CONFIGURE_OPTS[@]}" 2>&1 \
  | tee "${LOG_DIRECTORY}/configure.log"
exit_status=${PIPESTATUS[0]}
popd > /dev/null
return ${exit_status}
}

################################################################################
# make_a_target()                                                              #
#                                                                              #
################################################################################
function make_a_target()
{
pushd ${PACKAGE_BUILD_PATH} > /dev/null
if [ "x${MAKE_TARGET}" != "x" ] ; then
  MAKE_TARGET_NAME=${MAKE_TARGET}
else
  MAKE_TARGET_NAME="<none>"
fi
target_xform=$(printf "%s" "${MAKE_TARGET}" | sed -e "s|/|_|g")
eval \
  "${MAKE_VARS[@]}" make "${MAKE_OPTS[@]}" ${MAKE_TARGET} 2>&1 \
  | tee "${LOG_DIRECTORY}/make-${target_xform}.log"
exit_status=${PIPESTATUS[0]}
popd > /dev/null
return ${exit_status}
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

PACKAGE_NAME=binutils-2.43
PACKAGE_NAME_SIMPLE=binutils
PACKAGE_PARENT_PATH="/usr/local/src"
PACKAGE_SOURCE_PATH=${PACKAGE_PARENT_PATH}/${PACKAGE_NAME}
PACKAGE_BUILD_PATH=${PACKAGE_PARENT_PATH}/build-${PACKAGE_NAME}
PREFIX="/opt/toolchains"
DESTDIR=

BUILD_SYSTEM=$(gcc -dumpmachine 2> /dev/null)
LOG_DIRECTORY=$(pwd)

#TARGET=aarch64-elf
#TARGET=aarch64-none-linux-android
#TARGET=arm-eabi
#TARGET=armeb-eabi
#TARGET=avr-elf
#TARGET=i686-elf
#TARGET=m68k-elf
#TARGET=mips-elf
#TARGET=mips64-elf
#TARGET=microblaze-elf
#TARGET=nios2-elf
#TARGET=or1k-elf
#TARGET=powerpc-elf
#TARGET=powerpc64-linux
#TARGET=riscv32-elf
#TARGET=riscv64-elf
#TARGET=sparc-elf
#TARGET=sparc64-elf
#TARGET=sh-elf
#TARGET=sh4le-elf
#TARGET=s390-linux
#TARGET=s390x-linux
#TARGET=x86_64-elf

#phase_configure="Y"
#phase_make_all="Y"
#phase_make_install="Y"

if [ "x${phase_configure}" = "xY" ] ; then
  EXEC_PREFIX=${PREFIX}
  LIBDIR=lib
  CONFIGURE_VARS=()
  CONFIGURE_OPTS=()
  CONFIGURE_VARS+=("LEX=\"missing \"")
  CONFIGURE_VARS+=("FLEX=\"missing \"")
  CONFIGURE_VARS+=("CFLAGS=\"-g\"")
  CONFIGURE_VARS+=("CXXFLAGS=\"-g\"")
  CONFIGURE_VARS+=("LDFLAGS=\"-g\"")
  CONFIGURE_OPTS+=("--with-pkgversion='SweetAda GNU toolchain 1.0'")
  CONFIGURE_OPTS+=("--build=${BUILD_SYSTEM}")
  CONFIGURE_OPTS+=("--host=${BUILD_SYSTEM}")
  CONFIGURE_OPTS+=("--target=${TARGET}")
  CONFIGURE_OPTS+=("--prefix=${PREFIX}")
  CONFIGURE_OPTS+=("--exec-prefix=${EXEC_PREFIX}")
  CONFIGURE_OPTS+=("--bindir=${EXEC_PREFIX}/bin")
  CONFIGURE_OPTS+=("--libdir=${EXEC_PREFIX}/${LIBDIR}")
  CONFIGURE_OPTS+=("--libexecdir=${EXEC_PREFIX}/libexec")
  CONFIGURE_OPTS+=("--datarootdir=${PREFIX}/share")
  CONFIGURE_OPTS+=("--infodir=${PREFIX}/share/info")
  CONFIGURE_OPTS+=("--mandir=${PREFIX}/share/man")
  CONFIGURE_OPTS+=("--disable-shared")
  CONFIGURE_OPTS+=("--disable-nls")
  CONFIGURE_OPTS+=("--disable-win32-registry")
  CONFIGURE_OPTS+=("--enable-64-bit-bfd")
  CONFIGURE_OPTS+=("--enable-multilib")
  configure || exit $?
fi
if [ "x${phase_make_all}" = "xY" ] ; then
  MAKE_VARS=()
  MAKE_OPTS=()
  MAKE_VARS+=("V=1")
  MAKE_TARGET=all
  make_a_target || exit $?
fi
if [ "x${phase_make_install}" = "xY" ] ; then
  MAKE_VARS=()
  MAKE_OPTS=()
  MAKE_VARS+=("V=1")
  MAKE_VARS+=("DESTDIR=${DESTDIR}")
  MAKE_TARGET=install
  make_a_target || exit $?
fi

exit 0


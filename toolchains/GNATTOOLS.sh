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

PACKAGE_NAME=gcc-14.2.0
PACKAGE_NAME_SIMPLE=gcc
PACKAGE_PARENT_PATH="/usr/local/src"
PACKAGE_SOURCE_PATH=${PACKAGE_PARENT_PATH}/${PACKAGE_NAME}
PACKAGE_BUILD_PATH=${PACKAGE_PARENT_PATH}/build-${PACKAGE_NAME}-gnattools
PREFIX="/opt/toolchains"
DESTDIR=

#
# ALI versioning examples
#
# standard FSF:
# V "GNAT Lib v12"
# other toolchains:
# V "GNAT Lib v2021"
#
LIBRARY_VERSION="2021"

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

#phase_patchgnat="Y"
#phase_configure="Y"
#phase_libiberty="Y"
#phase_libbacktrace="Y"
#phase_libcpp="Y"
#phase_make_configure_gcc="Y"
#phase_make_libcommon="Y"
#phase_make_ada_files="Y"
#phase_make_cross_gnattools="Y"
#phase_make_ada_all_cross="Y"
#phase_make_gnat_install_tools="Y"
#phase_unpatchgnat="Y"

if [ "x${phase_patchgnat}" = "xY" ] ; then
  pushd ${PACKAGE_SOURCE_PATH}/gcc/ada > /dev/null
  if [ ! -e gnatvsn.ads.orig ] ; then
    cp -f gnatvsn.ads gnatvsn.ads.orig
  fi
  sed -i -e \
    "s|^\( *Library_Version : constant String := \"\)[0-9]*\(\";\)\$|\1${LIBRARY_VERSION}\2|" \
    gnatvsn.ads
  popd > /dev/null
fi
if [ "x${phase_configure}" = "xY" ] ; then
  EXEC_PREFIX=${PREFIX}
  LIBDIR=lib
  CONFIGURE_VARS=()
  CONFIGURE_OPTS=()
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
  CONFIGURE_OPTS+=("--with-gnu-as")
  CONFIGURE_OPTS+=("--with-gnu-ld")
  CONFIGURE_OPTS+=("--with-isl")
  CONFIGURE_OPTS+=("--with-system-zlib")
  CONFIGURE_OPTS+=("--disable-shared")
  CONFIGURE_OPTS+=("--disable-nls")
  CONFIGURE_OPTS+=("--disable-win32-registry")
  CONFIGURE_OPTS+=("--enable-languages=c,ada")
  CONFIGURE_OPTS+=("--disable-plugin")
  CONFIGURE_OPTS+=("--disable-werror")
  CONFIGURE_OPTS+=("--enable-multilib")
  CONFIGURE_OPTS+=("--disable-decimal-float")
  CONFIGURE_OPTS+=("--disable-fixed-point")
  CONFIGURE_OPTS+=("--disable-threads")
  CONFIGURE_OPTS+=("--disable-libstdcxx-v3")
  CONFIGURE_OPTS+=("--disable-libada")
  CONFIGURE_OPTS+=("--without-headers")
  CONFIGURE_OPTS+=("--disable-libatomic")
  CONFIGURE_OPTS+=("--disable-libcilkrts")
  CONFIGURE_OPTS+=("--disable-libgomp")
  CONFIGURE_OPTS+=("--disable-libitm")
  CONFIGURE_OPTS+=("--disable-libmudflap")
  CONFIGURE_OPTS+=("--disable-libquadmath")
  CONFIGURE_OPTS+=("--disable-libsanitizer")
  CONFIGURE_OPTS+=("--disable-libssp")
  CONFIGURE_OPTS+=("--disable-libvtv")
  CONFIGURE_OPTS+=("--disable-target-boehm-gc")
  CONFIGURE_OPTS+=("--disable-target-libada")
  CONFIGURE_OPTS+=("--disable-target-libatomic")
  CONFIGURE_OPTS+=("--disable-target-libbacktrace")
  CONFIGURE_OPTS+=("--disable-target-libcilkrts")
  CONFIGURE_OPTS+=("--disable-target-libffi")
  CONFIGURE_OPTS+=("--disable-target-libgfortran")
  CONFIGURE_OPTS+=("--disable-target-libgo")
  CONFIGURE_OPTS+=("--disable-target-libgomp")
  CONFIGURE_OPTS+=("--disable-target-libitm")
  CONFIGURE_OPTS+=("--disable-target-libjava")
  CONFIGURE_OPTS+=("--disable-target-libmpx")
  CONFIGURE_OPTS+=("--disable-target-libobjc")
  CONFIGURE_OPTS+=("--disable-target-liboffloadmic")
  CONFIGURE_OPTS+=("--disable-target-libquadmath")
  CONFIGURE_OPTS+=("--disable-target-libsanitizer")
  CONFIGURE_OPTS+=("--disable-target-libssp")
  CONFIGURE_OPTS+=("--disable-target-libvtv")
  CONFIGURE_OPTS+=("--disable-target-zlib")
  configure || exit $?
fi
if [ "x${phase_libiberty}" = "xY" ] ; then
  MAKE_VARS=()
  MAKE_OPTS=()
  MAKE_VARS+=("V=1")
  MAKE_TARGET=all-libiberty
  make_a_target || exit $?
  MAKE_TARGET=all-build-libiberty
  make_a_target || exit $?
fi
if [ "x${phase_libbacktrace}" = "xY" ] ; then
  MAKE_VARS=()
  MAKE_OPTS=()
  MAKE_VARS+=("V=1")
  MAKE_TARGET=all-libbacktrace
  make_a_target || exit $?
fi
if [ "x${phase_libcpp}" = "xY" ] ; then
  MAKE_VARS=()
  MAKE_OPTS=()
  MAKE_VARS+=("V=1")
  MAKE_TARGET=all-libcpp
  make_a_target || exit $?
  MAKE_TARGET=all-build-libcpp
  make_a_target || exit $?
fi
if [ "x${phase_make_configure_gcc}" = "xY" ] ; then
  MAKE_VARS=()
  MAKE_OPTS=()
  MAKE_VARS+=("V=1")
  MAKE_TARGET=configure-gcc
  make_a_target || exit $?
fi
if [ "x${phase_make_libcommon}" = "xY" ] ; then
  MAKE_VARS=()
  MAKE_OPTS=()
  MAKE_VARS+=("V=1")
  MAKE_OPTS=("-C" "gcc")
  MAKE_TARGET=libcommon.a
  make_a_target || exit $?
  MAKE_TARGET=libcommon-target.a
  make_a_target || exit $?
fi
if [ "x${phase_make_ada_files}" = "xY" ] ; then
  MAKE_VARS=()
  MAKE_OPTS=()
  MAKE_VARS+=("V=1")
  MAKE_OPTS+=("-C" "gcc")
  MAKE_TARGET=ada/snames.ads
  make_a_target || exit $?
  MAKE_TARGET=ada/sdefault.adb
  make_a_target || exit $?
  MAKE_TARGET=ada/sinfo-nodes.ads
  make_a_target || exit $?
  MAKE_TARGET=ada/link.o
  make_a_target || exit $?
  MAKE_TARGET=ada/targext.o
  make_a_target || exit $?
  MAKE_TARGET=ada/version.o
  make_a_target || exit $?
fi
if [ "x${phase_make_cross_gnattools}" = "xY" ] ; then
  MAKE_VARS=()
  MAKE_OPTS=()
  MAKE_VARS+=("V=1")
  MAKE_OPTS+=("-C" "gcc")
  MAKE_TARGET=cross-gnattools
  make_a_target || exit $?
fi
if [ "x${phase_make_ada_all_cross}" = "xY" ] ; then
  MAKE_VARS=()
  MAKE_OPTS=()
  MAKE_VARS+=("V=1")
  MAKE_OPTS+=("-C" "gcc")
  MAKE_TARGET=ada.all.cross
  make_a_target || exit $?
fi
if [ "x${phase_make_gnat_install_tools}" = "xY" ] ; then
  pushd ${PACKAGE_BUILD_PATH} > /dev/null
  cd gcc
  touch gnat1
  popd > /dev/null
  MAKE_VARS=()
  MAKE_OPTS=()
  MAKE_VARS+=("V=1")
  MAKE_OPTS+=("-C" "gcc")
  MAKE_OPTS+=("ADA_TOOLS=gnatmake")
  MAKE_TARGET=gnat-install-tools
  make_a_target || exit $?
fi
if [ "x${phase_unpatchgnat}" = "xY" ] ; then
  pushd ${PACKAGE_SOURCE_PATH}/gcc/ada > /dev/null
  if [ -e gnatvsn.ads.orig ] ; then
    mv -f gnatvsn.ads.orig gnatvsn.ads
  fi
  popd > /dev/null
fi

exit 0


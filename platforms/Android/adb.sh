#!/usr/bin/env sh

# ADB tool
ADB_EXECUTABLE=/opt/platform-tools/adb
# smartphone directory where to store the kernel in
DEVICE_DIRECTORY=/sdcard

${ADB_EXECUTABLE} push kernel.o ${DEVICE_DIRECTORY}
${ADB_EXECUTABLE} shell "${DEVICE_DIRECTORY}/kernel.o ; echo \"exit status = \$?\" ; exit"

exit 0


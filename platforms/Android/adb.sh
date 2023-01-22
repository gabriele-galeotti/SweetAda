#!/bin/sh

ADB_EXECUTABLE=/opt/platform-tools/adb
DEVICE_DIRECTORY=sdcard

${ADB_EXECUTABLE} push kernel.o ${DEVICE_DIRECTORY}/

RESULT=$(${ADB_EXECUTABLE} shell <<< 'cd /sdcard ; ./kernel.o ; echo $? ; exit')
printf "${RESULT}"

exit 0


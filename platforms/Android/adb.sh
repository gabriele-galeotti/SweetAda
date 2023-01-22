#!/bin/sh

ADB_EXECUTABLE=/opt/platform-tools/adb
DEVICE_DIRECTORY=/sdcard

${ADB_EXECUTABLE} push kernel.o ${DEVICE_DIRECTORY}

ADB_OUTPUT=$(
  ${ADB_EXECUTABLE} shell <<< "cd ${DEVICE_DIRECTORY} ; ./kernel.o ; echo \"exit status = \$?\" ; exit"
  )
printf "${ADB_OUTPUT}\n"

exit 0


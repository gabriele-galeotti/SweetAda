#!/usr/bin/env sh

case ${IPL_MODE} in
  "CARD_READER")
    "${PYTHON}" S360obj.py -a 0x10000 -p -l loader.rdr ${KERNEL_PARENT_PATH}/${KERNEL_ROMFILE} ${KERNEL_IPLFILE}
    #"${TCLSH}" S360obj.tcl -a 0x10000 -p -l loader.rdr ${KERNEL_PARENT_PATH}/${KERNEL_ROMFILE} ${KERNEL_IPLFILE}
    ;;
  "DASD")
    rm -f SYSRES.DSD
    "${PYTHON}" S360obj.py -a 0x10000 -p ${KERNEL_PARENT_PATH}/${KERNEL_ROMFILE} ${KERNEL_IPLFILE}
    #${TCLSH} S360obj.tcl -a 0x10000 -p ${KERNEL_PARENT_PATH}/${KERNEL_ROMFILE} ${KERNEL_IPLFILE}
    "${HERCULES_PREFIX}"/bin/dasdload -0 dasd_ctlfile.txt SYSRES.DSD 5
    ;;
  *)
    printf "%s\n" "*** Error: no valid IPL_MODE." 1>&2
    exit 1
    ;;
esac

exit $?


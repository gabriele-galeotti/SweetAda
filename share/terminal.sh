
#
# Terminal handling utilities.
#

#
# Arguments:
# -none
#
# Environment variables:
# GNATSTUDIO_PREFIX
# XDG_CONFIG_HOME
# XDG_DATA_DIRS
#

################################################################################
# terminal()                                                                   #
#                                                                              #
################################################################################
terminal()
{
case $1 in
  konsole) _TERMINAL_EXECUTABLE=konsole ; _EXECUTE_OPTION=-e ;;
  gnome)   _TERMINAL_EXECUTABLE=gnome-terminal ; _EXECUTE_OPTION=-- ;;
  xfce4)   _TERMINAL_EXECUTABLE=xfce4-terminal ; _EXECUTE_OPTION=-e ;;
  xterm)   _TERMINAL_EXECUTABLE=xterm ; _EXECUTE_OPTION=-e ;;
  *)       return 0 ;;
esac
printf "%s %s %s\n" "${_TERMINAL_EXECUTABLE}" "$2" "${_EXECUTE_OPTION}"
return 0
}

# GNAT Studio handling
case "${XDG_CONFIG_HOME}" in
  "${GNATSTUDIO_PREFIX}"*) export XDG_CONFIG_HOME= ;;
  *) ;;
esac
case "${XDG_DATA_DIRS}" in
  "${GNATSTUDIO_PREFIX}"*) export XDG_DATA_DIRS= ;;
  *) ;;
esac


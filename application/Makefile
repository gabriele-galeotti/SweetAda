
#
# Application sub-Makefile
#
# Copyright (C) 2020-2026 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

ifeq ($(KERNEL_PARENT_PATH),)
$(error Error: invalid KERNEL_PARENT_PATH)
endif

# verbose mode, "Y"/"y"/"1" = enabled
VERBOSE ?=
override VERBOSE := $(subst y,Y,$(subst 1,y,$(VERBOSE)))
export VERBOSE

include $(KERNEL_PARENT_PATH)/Makefile.os.in
include $(KERNEL_PARENT_PATH)/Makefile.ut.in
include $(KERNEL_PARENT_PATH)/Makefile.fn.in

ifneq ($(filter cmd msys,$(OSTYPE)),)
SYMLINK_MODE :=
endif

MAKEFILE_IF_IN_INCLUDED :=
-include Makefile.if.in

.PHONY: configure
configure: clean-installed-files
ifneq ($(USE_APPLICATION),)
ifneq ($(filter cmd msys,$(OSTYPE)),)
	$(SYMLINK)                                         \
                    -s $(OS_WINDOWS_SYMLINK)               \
                    -m Makefile.if.in                      \
                    $(USE_APPLICATION).ads application.ads \
                    $(USE_APPLICATION).adb application.adb
else
	$(SYMLINK)                                         \
                    -m Makefile.if.in                      \
                    $(USE_APPLICATION).ads application.ads \
                    $(USE_APPLICATION).adb application.adb
endif
endif

.PHONY: clean-installed-files
clean-installed-files:
ifeq ($(MAKEFILE_IF_IN_INCLUDED),Y)
ifneq ($(filter cmd msys,$(OSTYPE)),)
	$(RMSYMLINK)                        \
                     -s $(SYMLINK_MODE)     \
                     $(INSTALLED_FILENAMES) \
                     -o $(ORIGIN_FILENAMES)
else
	$(RM) $(INSTALLED_FILENAMES)
endif
	$(RM) Makefile.if.in
endif

.PHONY: clean
clean:
	$(RM) $(CLEAN_OBJECTS_COMMON)

.PHONY: distclean
distclean: clean-installed-files clean
	$(RM) $(DISTCLEAN_OBJECTS_COMMON)



#
# Application sub-Makefile
#
# Copyright (C) 2020-2025 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

ifeq ($(KERNEL_PARENT_PATH),)
$(error Error: invalid KERNEL_PARENT_PATH)
endif

include $(KERNEL_PARENT_PATH)/Makefile.os.in
include $(KERNEL_PARENT_PATH)/Makefile.ut.in
include $(KERNEL_PARENT_PATH)/Makefile.fn.in

-include Makefile.if.in

.PHONY: configure
configure: clean-installed-files
ifneq ($(USE_APPLICATION),)
	@$(CREATESYMLINK) -v -c -m Makefile.if.in                \
                          $(USE_APPLICATION).ads application.ads \
                          $(USE_APPLICATION).adb application.adb
endif

.PHONY: clean-installed-files
clean-installed-files:
ifneq ($(filter cmd msys,$(OSTYPE)),)
	$(RMSYMLINK) $(INSTALLED_FILENAMES) -o $(ORIGIN_FILENAMES)
else
	$(RM) $(INSTALLED_FILENAMES)
endif
	$(RM) Makefile.if.in

.PHONY: clean
clean:
	$(RM) $(CLEAN_OBJECTS_COMMON)

.PHONY: distclean
distclean: clean-installed-files clean
	$(RM) $(DISTCLEAN_OBJECTS_COMMON)


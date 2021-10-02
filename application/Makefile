
#
# Application sub-Makefile
#
# Copyright (C) 2020, 2021 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

ifeq ($(KERNEL_PARENT_PATH),)
$(error Error: invalid KERNEL_PARENT_PATH)
endif
ifeq ($(OBJECT_DIRECTORY),)
$(error Error: invalid OBJECT_DIRECTORY)
endif

include $(KERNEL_PARENT_PATH)/Makefile.fn.in
include $(KERNEL_PARENT_PATH)/Makefile.ut.in

DISTCLEAN_OBJECTS_EXTRA += application.ad*

.PHONY : configure
configure :
ifneq ($(USE_APPLICATION),)
	@$(CREATESYMLINK) $(USE_APPLICATION).ads application.ads
	@$(CREATESYMLINK) $(USE_APPLICATION).adb application.adb
endif

.PHONY : clean
clean :
	$(RM) $(CLEAN_OBJECTS_COMMON)

.PHONY : distclean
distclean : clean
	$(RM) $(DISTCLEAN_OBJECTS_EXTRA)

.PHONY : dep
dep :


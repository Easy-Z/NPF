ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NPF
NPF_FILES = Tweak.xm
NPF_EXTRA_FRAMEWORKS += Cephei
NPF_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 MobilePhone"
SUBPROJECTS += npfpref
include $(THEOS_MAKE_PATH)/aggregate.mk

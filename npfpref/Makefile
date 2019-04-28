ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = NPFPref
NPFPref_FILES = NPFRootListController.m
NPFPref_INSTALL_PATH = /Library/PreferenceBundles
NPFPref_FRAMEWORKS = UIKit
NPFPref_PRIVATE_FRAMEWORKS = Preferences
NPFPref_EXTRA_FRAMEWORKS += CepheiPrefs
NPFPref_LIBRARIES = colorpicker


include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/NPFPref.plist$(ECHO_END)

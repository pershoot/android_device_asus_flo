#
# Copyright 2012 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This contains the module build definitions for the hardware-specific
# components for this device.
#
# As much as possible, those components should be built unconditionally,
# with device-specific names to avoid collisions, to avoid device-specific
# bitrot and build breakages. Building a component unconditionally does
# *not* include it on all devices, so it is safe even with hardware-specific
# components.

ifneq ($(filter flo deb,$(TARGET_DEVICE)),)

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE       := wpa_supplicant_overlay.conf
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := $(LOCAL_MODULE)
LOCAL_MODULE_PATH  := $(TARGET_OUT_ETC)/wifi
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := p2p_supplicant_overlay.conf
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := $(LOCAL_MODULE)
LOCAL_MODULE_PATH  := $(TARGET_OUT_ETC)/wifi
include $(BUILD_PREBUILT)

# symlink tzapps in vendor/fw to /system/etc/fw
include $(CLEAR_VARS)
COMMANDS = tzapps
SYMLINKS := $(addprefix $(TARGET_OUT_EXECUTABLES)/,$(COMMANDS))
$(SYMLINKS): TZAPPS_BINARY := tzapps
$(SYMLINKS): $(LOCAL_INSTALLED_MODULE) $(LOCAL_PATH)/Android.mk
		$(hide) mkdir -p $(TARGET_OUT_ETC)/firmware
		$(hide) ln -sf /$(TARGET_COPY_OUT_VENDOR)/firmware/$(TZAPPS_BINARY).b00 $(TARGET_OUT_ETC)/firmware
		$(hide) ln -sf /$(TARGET_COPY_OUT_VENDOR)/firmware/$(TZAPPS_BINARY).b01 $(TARGET_OUT_ETC)/firmware
		$(hide) ln -sf /$(TARGET_COPY_OUT_VENDOR)/firmware/$(TZAPPS_BINARY).b02 $(TARGET_OUT_ETC)/firmware
		$(hide) ln -sf /$(TARGET_COPY_OUT_VENDOR)/firmware/$(TZAPPS_BINARY).b03 $(TARGET_OUT_ETC)/firmware
		$(hide) ln -sf /$(TARGET_COPY_OUT_VENDOR)/firmware/$(TZAPPS_BINARY).mdt $(TARGET_OUT_ETC)/firmware
ALL_DEFAULT_INSTALLED_MODULES += $(SYMLINKS)

# symlink wcd9310 fw from audio in data/misc to system/etc/fw
include $(CLEAR_VARS)
COMMANDS = wcd9310
SYMLINKS := $(addprefix $(TARGET_OUT_EXECUTABLES)/,$(COMMANDS))
$(SYMLINKS): WCD9310_BINARY := wcd9310
$(SYMLINKS): $(LOCAL_INSTALLED_MODULE) $(LOCAL_PATH)/Android.mk
		$(hide) mkdir -p $(TARGET_OUT_ETC)/firmware/wcd9310
		$(hide) ln -sf /$(TARGET_COPY_OUT_DATA)/misc/audio/$(WCD9310_BINARY)_anc.bin $(TARGET_OUT_ETC)/firmware/wcd9310
		$(hide) ln -sf /$(TARGET_COPY_OUT_DATA)/misc/audio/mbhc.bin $(TARGET_OUT_ETC)/firmware/wcd9310/$(WCD9310_BINARY)_mbhc.bin
ALL_DEFAULT_INSTALLED_MODULES += $(SYMLINKS)

include $(call first-makefiles-under,$(LOCAL_PATH))

endif

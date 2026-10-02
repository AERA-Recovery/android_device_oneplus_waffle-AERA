#
# Copyright (C) 2025 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/oneplus/waffle

# Shipping API level
BOARD_SHIPPING_API_LEVEL    := 35
PRODUCT_SHIPPING_API_LEVEL  := 35
PRODUCT_TARGET_VNDK_VERSION := 35

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Kernel
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS   := false
PRODUCT_ENABLE_UFFD_GC                          := true

PRODUCT_PACKAGES += \
    lpflash \
    lpmake \
    lpunpack

# OTA certs
PRODUCT_EXTRA_RECOVERY_KEYS += \
	$(LOCAL_PATH)/security/local_OTA \
	$(LOCAL_PATH)/security/special_OTA

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += $(LOCAL_PATH)

PRODUCT_PACKAGES += \
    aera-audio-bridge \
    aera-audio-service \
    aera-browser-jail \
    aera-gpu-probe

# Waffle's matching Adreno 750 userspace and allocator are bundled in this
# device tree. Other devices retain AERA's software-renderer fallback.
PRODUCT_VENDOR_PROPERTIES += \
    ro.hardware.egl=adreno

# AERA recovery settings
$(call inherit-product, $(LOCAL_PATH)/aera_waffle.mk)
#

#
# Copyright (C) 2025 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/oneplus/waffle

# Building with minimal manifest
ALLOW_MISSING_DEPENDENCIES                      := true
BUILD_BROKEN_DUP_RULES                          := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES    := true

BUILD_BROKEN_NINJA_USES_ENV_VARS    += RTIC_MPGEN
BUILD_BROKEN_PLUGIN_VALIDATION      := soong-libaosprecovery_defaults soong-libguitwrp_defaults soong-libminuitwrp_defaults soong-vold_defaults

# Architecture
TARGET_ARCH                 := arm64
TARGET_ARCH_VARIANT         := armv8-a
TARGET_CPU_ABI              := arm64-v8a
TARGET_CPU_VARIANT          := kryo

# A/B
AB_OTA_PARTITIONS := \
    boot \
    init_boot \
    vendor_boot \
    dtbo \
    odm \
    product \
    system \
    system_ext \
    system_dlkm \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor \
    vendor \
    vendor_dlkm

# AB partitions for oplus
AB_OTA_PARTITIONS += \
    my_bigball \
    my_carrier \
    my_company \
    my_engineering \
    my_heytap \
    my_manifest \
    my_preload \
    my_product \
    my_region \
    my_stock

# Bootloader
PRODUCT_PLATFORM                := pineapple
TARGET_BOOTLOADER_BOARD_NAME    := pineapple
TARGET_NO_BOOTLOADER            := true

# Crypto
BOARD_USES_METADATA_PARTITION   := true
BOARD_USES_QCOM_FBE_DECRYPTION  := true
AERA_INCLUDE_CRYPTO             := true
AERA_INCLUDE_CRYPTO_FBE         := true
AERA_INCLUDE_FBE_METADATA_DECRYPT := true
AERA_USE_FSCRYPT_POLICY         := 2

# Debug
TARGET_USES_LOGD                := true
AERA_INCLUDE_LOGCAT             := true
TARGET_RECOVERY_DEVICE_MODULES  += debuggerd
TARGET_RECOVERY_DEVICE_MODULES  += strace
RECOVERY_BINARY_SOURCE_FILES    += $(TARGET_OUT_EXECUTABLES)/debuggerd
RECOVERY_BINARY_SOURCE_FILES    += $(TARGET_OUT_EXECUTABLES)/strace

# File systems
TARGET_USERIMAGES_USE_F2FS := true
AERA_USE_DMCTL             := true

# Kernel
BOARD_KERNEL_IMAGE_NAME     := Image
BOARD_BOOT_HEADER_VERSION   := 4
BOARD_KERNEL_PAGESIZE       := 4096
BOARD_MKBOOTIMG_ARGS        += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS        += --pagesize $(BOARD_KERNEL_PAGESIZE)

BOARD_RAMDISK_USE_LZ4       := true

# Partitions
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED  := true
BOARD_RECOVERYIMAGE_PARTITION_SIZE      := 0x6400000

BOARD_SUPER_PARTITION_SIZE                  := 14578294784
BOARD_SUPER_PARTITION_GROUPS                := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE           := 14574100480
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := system system_dlkm system_ext product vendor vendor_dlkm odm
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST += my_bigball my_carrier my_company my_engineering my_heytap my_manifest my_preload my_product my_region my_stock

BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_ODM             := odm
TARGET_COPY_OUT_VENDOR          := vendor

# Platform
TARGET_BOARD_PLATFORM   := sm86xx
TARGET_BOARD_PLATFORM_GPU := qcom-adreno750
QCOM_BOARD_PLATFORMS    += sm86xx

# Recovery
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE    := true
TARGET_RECOVERY_PIXEL_FORMAT                := RGBX_8888
AERA_INCLUDE_FASTBOOTD                      := true
AERA_SKIP_ADDITIONAL_FSTAB                  := true
AERA_UI_ADAPTIVE_RESOLUTION                 := true

# Tool
AERA_ENABLE_ALL_PARTITION_TOOLS := true
AERA_INCLUDE_7ZA                := true
AERA_INCLUDE_LIBRESETPROP       := true
AERA_INCLUDE_LPDUMP             := true
AERA_INCLUDE_LPTOOLS            := true
AERA_INCLUDE_REPACKTOOLS        := true
AERA_INCLUDE_RESETPROP          := true
AERA_USE_TOOLBOX                := true
AERA_INCLUDE_ZSTD               := true

# AERA display
AERA_BRIGHTNESS_PATH      := /sys/class/backlight/panel0-backlight/brightness
AERA_DEFAULT_BRIGHTNESS   := 2048
AERA_FRAMERATE            := 120
# Keep Waffle on its standard 120 Hz command-mode timing in recovery. The
# preferred connector mode is 60 Hz and can enter a very slow panel update
# path; this is a fixed mode selection, not LTPO/ADFR control.
AERA_DRM_FIXED_REFRESH_RATE := 120
AERA_MAX_BRIGHTNESS       := 4095
AERA_NO_SCREEN_BLANK      := true
AERA_SCREEN_BLANK_ON_BOOT := true
AERA_THEME                := portrait_hdpi
TARGET_USES_VULKAN        := true

# AERA file system
RECOVERY_SDCARD_ON_DATA     := true
TARGET_USES_MKE2FS          := true
AERA_ENABLE_FS_COMPRESSION    := true
AERA_INCLUDE_FUSE_EXFAT       := true
AERA_INCLUDE_FUSE_NTFS        := true
AERA_INCLUDE_NTFS_3G          := true
AERA_NO_EXFAT_FUSE            := true

# Version
PLATFORM_VERSION                := 99.87.36
PLATFORM_VERSION_LAST_STABLE    := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH         := 2099-12-31
VENDOR_SECURITY_PATCH           := $(PLATFORM_SECURITY_PATCH)
AERA_DEVICE_VERSION             := OnePlus_12

# Verified Boot
BOARD_AVB_ENABLE := true

# Vibrator
AERA_SUPPORT_INPUT_AIDL_HAPTICS := true

# Other AERA configurations
TARGET_RECOVERY_QCOM_RTC_FIX            := true
AERA_CUSTOM_CPU_TEMP_PATH                 := "/sys/class/thermal/thermal_zone48/temp"
AERA_EXCLUDE_APEX                         := true
AERA_EXCLUDE_DEFAULT_USB_INIT             := true
AERA_DEFAULT_LANGUAGE                     := en
AERA_EXTRA_LANGUAGES                      := true
# Keep the ADSP loader in the early set: init uses its boot sysfs node while
# preparing firmware. Load the actual SPF/machine/codec chain post-decrypt so
# AudioPD can come online during SPF's probe window instead of after it expires.
# AERA resolves every module from the active device images, keeping it matched
# to the installed kernel.
AERA_LOAD_VENDOR_MODULES := "goodix_core.ko oplus_chg_v2.ko stm_st54se_gpio.ko nxp-nci.ko adsp_loader_dlkm.ko msm_kgsl.ko"
AERA_POST_DECRYPT_MODULES := "cnss_prealloc.ko cnss_nl.ko wlan_firmware_service.ko cnss_plat_ipc_qmi_svc.ko cnss_utils.ko cnss2.ko rfkill.ko cfg80211.ko gsim.ko rmnet_mem.ko ipam.ko qca_cld3_kiwi_v2.ko q6_pdr_dlkm.ko q6_notifier_dlkm.ko snd_event_dlkm.ko gpr_dlkm.ko spf_core_dlkm.ko audpkt_ion_dlkm.ko audio_pkt_dlkm.ko q6_dlkm.ko audio_prm_dlkm.ko pinctrl_lpi_dlkm.ko swr_dlkm.ko swr_ctrl_dlkm.ko slimbus.ko wcd_core_dlkm.ko mbhc_dlkm.ko sdca_registers_dlkm.ko wcd9xxx_dlkm.ko stub_dlkm.ko lpass_cdc_dlkm.ko lpass_cdc_wsa2_macro_dlkm.ko lpass_cdc_wsa_macro_dlkm.ko lpass_cdc_va_macro_dlkm.ko lpass_cdc_rx_macro_dlkm.ko lpass_cdc_tx_macro_dlkm.ko wsa884x_dlkm.ko wsa883x_dlkm.ko wcd937x_dlkm.ko wcd937x_slave_dlkm.ko wcd938x_dlkm.ko wcd938x_slave_dlkm.ko wcd9378_dlkm.ko wcd9378_slave_dlkm.ko wcd939x_dlkm.ko wcd939x_slave_dlkm.ko swr_dmic_dlkm.ko oplus_audio_extend.ko swr_haptics_dlkm.ko oplus_audio_tfa98xx_v6.ko oplus_audio_sipa.ko oplus_audio_sipa_tuning.ko oplus_audio_aw882xx.ko msm_ext_display.ko hdmi_dlkm.ko btpower.ko bt_fm_slim.ko machine_dlkm.ko frpc-adsprpc.ko"
AERA_LOAD_VENDOR_MODULES_EXCLUDE_GKI      := true
AERA_LOAD_PREBUILT_MODULES_AT_FIRST       := true
AERA_LOAD_VENDOR_BOOT_MODULES             := true
AERA_USE_SERIALNO_PROPERTY_FOR_DEVICE_ID  := true
AERA_INPUT_BLACKLIST                      := "hbtp_vm"
AERA_INCLUDE_OMAPI                        := true

/*
 * Copyright (C) 2026 AERA Recovery Project contributors
 * SPDX-License-Identifier: Apache-2.0
 *
 * Minimal host for Waffle's stock primary audio HAL. Opening the HAL performs
 * the device-specific PAL initialization and registers Qualcomm's AGM/PAL
 * HIDL services. The installed vendor image remains mounted read-only and no
 * audio device or raw partition is exposed to plugins.
 */
#include <android/log.h>
#include <dlfcn.h>
#include <hardware/hardware.h>
#include <hidl/HidlTransportSupport.h>
#include <unistd.h>

#include <cstdio>
#include <cstring>

namespace {

constexpr char kTag[] = "AERAAudio";
constexpr char kPrimaryHal[] =
    "/system/aera-audio-vendor/lib64/hw/audio.primary.pineapple.so";
constexpr char kAudioHardwareInterface[] = "audio_hw_if";

// The audio module ABI begins with the common hardware module structure. We
// deliberately keep only that stable prefix here so this recovery-only host
// does not need Android's full framework audio header surface.
struct AudioModule {
  hw_module_t common;
};

void Log(int priority, const char* message) {
  __android_log_write(priority, kTag, message);
  std::fprintf(stderr, "%s\n", message);
}

}  // namespace

int main(int argc, char** argv) {
  if (argc != 2 || std::strcmp(argv[1], "--waffle-stock-audio") != 0) {
    Log(ANDROID_LOG_ERROR,
        "Refusing to start without the Waffle stock-audio mode.");
    return 64;
  }
  if (getuid() != 0 || access(kPrimaryHal, R_OK) != 0) {
    Log(ANDROID_LOG_ERROR, "The read-only stock audio HAL is unavailable.");
    return 66;
  }

  android::hardware::configureRpcThreadpool(8, true);

  void* library = dlopen(kPrimaryHal, RTLD_NOW | RTLD_GLOBAL);
  if (!library) {
    __android_log_print(ANDROID_LOG_ERROR, kTag,
                        "Primary audio HAL load failed: %s", dlerror());
    return 67;
  }

  dlerror();
  auto* module = static_cast<AudioModule*>(
      dlsym(library, HAL_MODULE_INFO_SYM_AS_STR));
  const char* symbol_error = dlerror();
  if (!module || symbol_error || !module->common.methods ||
      !module->common.methods->open) {
    __android_log_print(ANDROID_LOG_ERROR, kTag,
                        "Primary audio HAL entry point is unavailable: %s",
                        symbol_error ? symbol_error : "invalid HAL module");
    dlclose(library);
    return 68;
  }

  hw_device_t* raw_device = nullptr;
  const int status = module->common.methods->open(
      &module->common, kAudioHardwareInterface, &raw_device);
  if (status != 0 || !raw_device) {
    __android_log_print(ANDROID_LOG_ERROR, kTag,
                        "Primary audio HAL initialization failed: %d", status);
    dlclose(library);
    return 69;
  }

  Log(ANDROID_LOG_INFO, "Waffle stock AGM/PAL services are ready.");
  android::hardware::joinRpcThreadpool();

  Log(ANDROID_LOG_ERROR, "Audio HIDL thread pool exited unexpectedly.");
  raw_device->close(raw_device);
  dlclose(library);
  return 70;
}

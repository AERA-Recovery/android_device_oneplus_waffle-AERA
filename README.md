# OnePlus 12 (waffle) AERA device tree

## Bring-up targets

- Display and touch
- Android 16 FBE decryption
- ADB, MTP, OTG and Fastbootd
- Backup, restore, flashing and format
- Wi-Fi
- AIDL haptics and flashlight
- Device-matched Adreno 750 graphics acceleration
- Qualcomm PAL/AGM audio for AERA media plugins

# Build

### Clone & Sync Source
```
mkdir -p ~/android/AERA_16.0
cd ~/android/AERA_16.0
repo init -u https://github.com/AERA-Recovery/android_manifest -b aera-16.0
repo sync -c -j$(nproc --all)
```
### Clone Device-tree
```
git clone <AERA waffle device-tree URL> device/oneplus/waffle
```
### BUILD!
```
cd ~/android/AERA_16.0
source build/envsetup.sh
lunch twrp_waffle-bp2a-eng
mka recoveryimage
```

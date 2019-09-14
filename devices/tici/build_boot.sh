#!/bin/bash -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
OUT=$DIR/out
ROOT=$DIR/../..
TOOLS=$ROOT/tools
IMG_TYPE=boot

if [ ! -d android_kernel_comma_sdm845 ]; then
  git clone git@github.com:commaai/android_kernel_comma_sdm845.git --depth 1
fi

export CROSS_COMPILE=$TOOLS/aarch64-linux-gnu-gcc/bin/aarch64-linux-gnu-
export ARCH=arm64

$TOOLS/extract_toolchains.sh
mkdir -p $OUT

# Compile kernel
cd android_kernel_comma_sdm845
# the DTC from the Android tree supports "-@"
# TODO: move it into the kernel for true standalone build
DTC="../android/out/host/linux-x86/bin/dtc"
UFDT="../android/out/host/linux-x86/bin/ufdt_apply_overlay_host"
make DTC_EXT=$DTC DTC_OVERLAY_TEST_EXT=$UFDT CONFIG_BUILD_ARM64_DT_OVERLAY=y sdm845_defconfig
make DTC_EXT=$DTC DTC_OVERLAY_TEST_EXT=$UFDT CONFIG_BUILD_ARM64_DT_OVERLAY=y -j$(nproc --all)
cd ..

# Assemble an unsigned boot.img
#--kernel android/out/target/product/sdm845/obj/kernel/msm-4.9/arch/arm64/boot/Image.gz-dtb \
$TOOLS/mkbootimg \
  --kernel android_kernel_comma_sdm845/arch/arm64/boot/Image.gz-dtb \
  --cmdline "console=ttyMSM0,115200n8 earlycon=msm_geni_serial,0xA84000 androidboot.hardware=qcom androidboot.console=ttyMSM0 msm_rtb.filter=0x237 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 service_locator.enable=1 swiotlb=2048 androidboot.configfs=true androidboot.usbcontroller=a600000.dwc3 androidboot.selinux=permissive buildvariant=userdebug" \
  --base 0x80000000 \
  --kernel_offset 0x8000 \
  --ramdisk_offset 0x2000000 \
  --tags_offset 0x100 \
  --pagesize 4096 \
  --ramdisk ramdisk-$IMG_TYPE.gz \
  --output unf-$IMG_TYPE.img

# Sign the boot.img
java -Xmx512M -jar $ROOT/tools/BootSignature.jar /$IMG_TYPE unf-$IMG_TYPE.img $ROOT/keys/verity.pk8 $ROOT/keys/verity.x509.pem unf-$IMG_TYPE.img
openssl dgst -sha256 -binary unf-$IMG_TYPE.img > unf-$IMG_TYPE.img.sha256
openssl rsautl -sign -in unf-$IMG_TYPE.img.sha256 -inkey $ROOT/keys/qcom.key -out unf-$IMG_TYPE.img.sig
dd if=/dev/zero of=unf-$IMG_TYPE.img.sig.padded bs=4096 count=1
dd if=unf-$IMG_TYPE.img.sig of=unf-$IMG_TYPE.img.sig.padded conv=notrunc
cat unf-$IMG_TYPE.img unf-$IMG_TYPE.img.sig.padded > $OUT/$IMG_TYPE.img

# Clean up
rm unf-$IMG_TYPE*


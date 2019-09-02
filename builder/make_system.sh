#!/bin/bash
set -e

# check that /usr is up to date
if [ ! -d usr ]; then
  git clone git@github.com:commaai/usr.git
fi
(cd usr && git pull)

FIRMWARE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p build
pushd build
  mkdir -p system/mnt
  umount system/mnt || true

  # prepare system image
  pushd system
    simg2img "$FIRMWARE_DIR"/mindroid/system/out/target/product/oneplus3/system.img system.img.raw
    mkdir -p mnt
    mount -o loop system.img.raw mnt

    # copy the usr files
    echo "doing git copy with usr repo"
    mkdir -p mnt/comma
    cp -R "$FIRMWARE_DIR"/usr mnt/comma

    echo 'replacing properties'
    sed -i 's/ro.adb.secure=1/ro.adb.secure=0/' mnt/build.prop
    sed -i 's/neos.vpn=1/neos.vpn=0/' mnt/build.prop

    # copy the home files
    cp -Rv "$FIRMWARE_DIR"/home mnt/comma/home
    chmod 600 mnt/comma/home/.ssh/*

    # set permissions
    chown root:root mnt/build.prop
    chmod 644 mnt/build.prop
    chmod 600 mnt/comma/usr/etc/ssh/*
    chmod 600 mnt/comma/home/.ssh/*
    chmod 600 mnt/comma/usr/etc/ssh/*

    if [[ $LEECO ]]; then
      echo "copying LeEco files"
      cp -vp ../../lepatch/a530_zap.mdt mnt/etc/firmware/
      cp -vp ../../lepatch/WCNSS_qcom_cfg.ini mnt/etc/wifi/
      cp -vp ../../lepatch/mixer_paths_tasha.xml mnt/etc/
      cp -vp ../../lepatch/audio_platform_info.xml mnt/etc/
    fi

    # done with system
    umount mnt
    img2simg system.img.raw ../system.good.img
  popd

popd

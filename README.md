NEOS Builder
======

This is the tool to build the operating system for your [EON Dashcam Development Kit](https://shop.comma.ai/products/eon-dashcam-devkit)

* This is a fork of [jfrux/eon-neos-builder](https://github.com/jfrux/eon-neos-builder) modified to build in a docker container on a mac. Note that this process may work on other OSes with a few tweaks, but it has not been tested.

* The goal of this fork is to develop custom EON NEOS roms for the existing as well as for other devices

What is it?
------

* A kernel built outside the Android build system
* A minified version of Android
* Userspace from termux

Changes from the original
------

* Modified to build on a mac
    * uses docker container with a mounted case-sensitive volume
* Added make targets to make executing tasks simpler
* Updated repo tool from `1.23` -> `1.25`
* Modified sync command to only do a shallow clone of the repos (this speeds up the sync process considerably)
* Added a step to build the NEOSSetup apk

### Prerequisites

* This is an experimental repo and should be considered as such.
  * **I am not responsible if you brick your phone**
* Manage your expectations! 
  * Building Android from source takes many hours to complete (it took nearly 70 hours on my machine).
* macOS (Tested on Mojave 10.14.6)
* 200GB of free space
* [Docker](https://docs.docker.com/docker-for-mac/install/)
  * Need at least 8GB of RAM allocated to Docker
* [Make](https://brewformulas.org/make)
* [Snapdragon LLVM](https://developer.qualcomm.com/download/sdllvm/snapdragon-llvm-compiler-android-linux64.tar.gz)
  * You will have to sign up for an account to download it (it's a free account)
  * Put the .tar.gz file in the `/tools` directory
* Check the bottom of this readme to see if there are any known issues

Usage
------

### Setup

```bash
make setup-env
```

### Building

```bash
make build-all
```

Images are written to the `Volumes/neos/out` directory.

### Flashing Devices

Boot device to fastboot. With an EON Gold, hold Power+Volume Down. With an EON, hold Power+Volume Up.

```bash
cd devices/eon
./flash.sh
```

### Make OTA update

```bash
cd devices/eon
./prepare_ota.sh
```

Supported Devices
------
* [OnePlus 3T](https://www.oneplus.com/3t)
* [LeEco LePro 3](https://www.cnet.com/products/leeco-lepro-3/review/)
* Hopefully more coming soon

What works
-----
- [X] **Compute**
  - [X] GPU
  - [X] OpenCL
  - [X] DSP
- [X] **Sensors**
  - [X] GPS
  - [X] IMU
  - [X] Camera with visiond
  - [X] Audio
  - [X] Touchscreen
- [X] **Connectivity**
  - [X] Ethernet
  - [X] Radio
  - [X] Wi-FI
  - [X] Bluetooth
  - [X] Tethering

Known issues
-----
When building NEOSSetup it complains about missing dependencies. There is currently a [pull request](https://github.com/commaai/android_packages_apps_NEOSSetup/pull/2) that will fix this issue.
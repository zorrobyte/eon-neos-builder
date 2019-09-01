NEOS Builder
======

This is the tool to build the operating system for your [EON Dashcam Development Kit](https://shop.comma.ai/products/eon-dashcam-devkit)

* This is a fork of [jfrux/eon-neos-builder](https://github.com/jfrux/eon-neos-builder) modified to run in a docker container on a mac. Note that this process may work on other OSes with a few tweaks, but it has not been tested.

* The docker image is an adaptation of [ziozzang/android-kernel-builder-docker](https://github.com/ziozzang/android-kernel-builder-docker)

* The goal of this fork is to develop EON NEOS roms for other devices

What is it?
------

* A kernel built outside the Android build system
* A minified version of Android
* Userspace from termux

Prerequisites
-----

* Manage your expectations! 
  * Building Android from source takes hours to complete. It took me around 24 hours
* This is an experimental repo and should be considered as such.
  * **I am not responsible if you brick your phone**
* macOS (Tested on Mojave 10.14.5)
* 200GB of free space
* git
  * You need to be setup to clone from github over ssh
  * Your private key should be at ~/.ssh/id_rsa
  * Do not use a passphrase with your key. I tried this and couldn't make it work
* make - _optional, but makes life easier_

Usage
------

 1. make setup-env (first time only)
 2. make build-all. I had to restart this process several times due to errors, but it always seemed to pick up where it left off
 3. ./builder/flash_oneplus.sh   # change to leeco if appropriate
 4. make destroy-env - _optional if you want to recover your disk space after you're done_

Supported Phones
------
* Oneplus 3T
* LePro 3

What works
-----

* Compute
** GPU
** OpenCL
** DSP
* Sensors
** GPS
** IMU
** Camera with visiond
** Audio
** Touchscreen
* Connectivity
** Ethernet
** Radio
** Wi-FI
** Bluetooth
** Tethering


#!/usr/bin/env bash
set -e

export USER=$(whoami)
LIMIT_CORES=4

cd devices/eon
./build_ramdisks.sh
./build_all.sh
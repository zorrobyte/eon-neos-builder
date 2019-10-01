#!/bin/bash -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
ROOT=$DIR/../..
TOOLS=$ROOT/tools

cd $DIR

if [[ -z "${LIMIT_CORES}" ]]; then
  JOBS=$(nproc --all)
else
  JOBS=8
fi

# repo sync
mkdir -p $DIR/mindroid
cd $DIR/mindroid
$TOOLS/repo init --depth=1 -u git://github.com/commaai/android.git -b mindroid
$TOOLS/repo sync -c --no-clone-bundle -j$JOBS

# build NEOSSetup
cd $DIR/mindroid/packages/apps/NEOSSetup
./build.sh

# build mindroid
cd $DIR/mindroid
(source build/envsetup.sh && breakfast oneplus3 && make all -j$JOBS)

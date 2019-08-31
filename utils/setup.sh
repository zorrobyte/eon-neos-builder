#!/usr/bin/env bash

source mount_volume.sh

DIRECTORY=.git
if [ ! -d "$FILE" ]; then
    echo "cloning repo stecky/eon-neos-builder"
    git clone git@github.com:stecky/eon-neos-builder.git .
fi

cd /Volmes/android/eon-neos-builder

docker build -t stecky/eon-neos-builder ./docker
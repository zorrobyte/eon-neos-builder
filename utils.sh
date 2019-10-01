#!/bin/bash

function create-volume() {
    FILE=~/neos.dmg.sparseimage
	if [ ! -f "$FILE" ]; then
		echo "Creating case-sensitive volume $FILE"
		hdiutil create -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size 200g -volname neos ~/neos.dmg
	fi
}

function mount-volume() {
    LOCALMOUNTPOINT="/Volumes/neos"
	if mount | grep "on $LOCALMOUNTPOINT" > /dev/null; then
		echo "NEOS volume already mounted"
	else
		echo "Mounting NEOS volume at /Volumes/neos"
		hdiutil attach ~/neos.dmg.sparseimage -mountpoint /Volumes/neos;
	fi
}

function unmount-volume() {
    LOCALMOUNTPOINT="/Volumes/neos"
	if mount | grep "on $LOCALMOUNTPOINT" > /dev/null; then
		hdiutil detach /Volumes/neos;
	else \
		echo "/Volumes/neos is not currently mounted"
	fi
}

function copy-build-files-to-volume() {
    cp -R . /Volumes/neos
}

function run-in-docker() {
	current_time=$(date "+%Y.%m.%d-%H.%M.%S")
	container_name="eon-neos-builder_"$current_time
    docker run \
	-it --rm \
	--name=$container_name \
	--privileged=true \
	--volume /Volumes/neos:/tmp/eon-neos-builder \
	--entrypoint=bash \
	stecky/eon-neos-builder $1
}

if [[ "$OSTYPE" == "darwin"* ]]; then
    eval $@
else
    echo "This only works on macOS"
fi
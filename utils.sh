#!/bin/bash

function create-volume() {
    FILE=~/android.dmg.sparseimage
	if [ ! -f "$FILE" ]; then
		echo "Creating case-sensitive volume $FILE"
		hdiutil create -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size 200g -volname Android ~/android.dmg
	fi
}

function mount-volume() {
    LOCALMOUNTPOINT="/Volumes/android"
	if mount | grep "on $LOCALMOUNTPOINT" > /dev/null; then
		echo "Android volume already mounted"
	else
		echo "Mounting Android volume at /Volumes/android"
		hdiutil attach ~/android.dmg.sparseimage -mountpoint /Volumes/android;
	fi
}

function unmount-volume() {
    LOCALMOUNTPOINT="/Volumes/android"
	if mount | grep "on $LOCALMOUNTPOINT" > /dev/null; then
		hdiutil detach /Volumes/android;
	else \
		echo "/Volumes/android is not currently mounted"
	fi
}

function clone-repo() {
    cd /Volumes/android

	DIRECTORY=.git
	if [ -d "$FILE" ]; then
		echo "repo already cloned"
	else
		echo "cloning repo stecky/eon-neos-builder"
		git clone -b $1 git@github.com:stecky/eon-neos-builder.git eon-neos-builder
	fi
}

function run-in-docker() {
    docker run \
	-it --rm \
	--privileged=true \
	--volume ~/.ssh/id_rsa:/root/.ssh/id_rsa \
	--volume /Volumes/android/eon-neos-builder/builder:/builder \
	--entrypoint=bash \
	stecky/eon-neos-builder -c "zsh $1"
}

eval $@
if [ "$(uname)" == "Darwin" ]; then
    FILE=~/android.dmg.sparseimage
    if [ ! -f "$FILE" ]; then
        echo "Creating case-sensitive volume $FILE"
        hdiutil create -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size 200g -volname Android ~/android.dmg
    fi

    LOCALMOUNTPOINT="/Volumes/android"
    if mount | grep "on $LOCALMOUNTPOINT" > /dev/null; then
        echo "Android volume already mounted"
    else
        echo "Mounting Android volume at /Volumes/android"
        hdiutil attach ~/android.dmg.sparseimage -mountpoint /Volumes/android;
    fi

    cd /Volumes/Android
else
    echo "You are not running this on a mac. I make no guarantees that my process will work on other OSes"
fi

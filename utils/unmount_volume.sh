if [ "$(uname)" == "Darwin" ]; then
    LOCALMOUNTPOINT="/Volumes/android"
    if mount | grep "on $LOCALMOUNTPOINT" > /dev/null; then
        hdiutil detach /Volumes/android;
    else
        echo "/Volumes/android is not currently mounted"
    fi
else
    echo "You are not running this on a mac. I make no guarantees that my process will work on other OSes"
fi
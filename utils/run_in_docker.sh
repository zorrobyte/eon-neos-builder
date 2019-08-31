docker run \
    -it --rm \
    --privileged=true \
    --volume ~/.ssh/id_rsa:/root/.ssh/id_rsa \
    --volume /Volumes/android/eon-neos-builder/builder:/builder \
    stecky/eon-neos-builder -c "zsh $1"
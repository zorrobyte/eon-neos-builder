FROM ubuntu:18.04
LABEL Steven Barnes <stevenbarnes7814@gmail.com>

ENV PATH="/tmp/eon-neos-builder/tools:${PATH}" \
    PYTHONUNBUFFERED=1 \
    SKIP_DEPS=1

# Minimum dependencies required for android development - https://source.android.com/setup/build/initializing
RUN apt-get update && apt-get install -y \
    bison build-essential curl flex gcc-multilib g++-multilib git-core gnupg gperf \
    lib32ncurses5-dev libc6-dev-i386 libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils \
    unzip x11proto-core-dev xsltproc zip zlib1g-dev

# Frameworks and sdk's
RUN apt-get update && apt-get install -y \
    nodejs openjdk-8-jdk python

# Build libraries and tools
RUN apt-get update && apt-get install -y \
    abootimg bc ccache cpio device-tree-compiler gpg imagemagick libncurses5-dev \
    lib32readline-dev lib32z1-dev libsdl1.2-dev libssl-dev libwxgtk3.0-dev libxml2 \
    libxml2-utils liblz4-tool lzop nano pngcrush rsync schedtool simg2img squashfs-tools \
    sudo tmux u-boot-tools vboot-utils vim wget xsltproc zip zlib1g-dev zsh

# All git actions will be performed by user aosp
COPY gitconfig /root/.gitconfig

# Install nodejs and yarn
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get update && apt-get install -y nodejs \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" >> /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install -y yarn

# Android SDK
ENV ANDROID_HOME="/usr/local/android-sdk" \
    SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip" \
    ANDROID_VERSION=25 \
    ANDROID_BUILD_TOOLS_VERSION=29.0.2
RUN mkdir "$ANDROID_HOME" .android \
    && cd "$ANDROID_HOME" \
    && curl -o sdk.zip $SDK_URL \
    && unzip sdk.zip \
    && rm sdk.zip \
    && mkdir "$ANDROID_HOME/licenses" || true \
    && echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > "$ANDROID_HOME/licenses/android-sdk-license" \
    && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses
# Install Android Build Tool and Libraries
RUN $ANDROID_HOME/tools/bin/sdkmanager --update
RUN $ANDROID_HOME/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools"

# Install Oh My Zsh!
RUN sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" || true
WORKDIR /tmp/eon-neos-builder
ENTRYPOINT bash
FROM debian:12-slim

RUN \
    apt-get update -q \
    && apt-get install -y \
        curl \
        appstream \
        autoconf \
        automake \
        autopoint \
        build-essential \
        cmake \
        git \
        libass-dev \
        libbz2-dev \
        libfontconfig1-dev \
        libfreetype6-dev \
        libfribidi-dev \
        libharfbuzz-dev \
        libjansson-dev \
        liblzma-dev \
        libmp3lame-dev \
        libnuma-dev \
        libogg-dev \
        libopus-dev \
        libsamplerate-dev \
        libspeex-dev \
        libtheora-dev \
        libtool \
        libtool-bin \
        libturbojpeg0-dev \
        libvorbis-dev \
        libx264-dev \
        libxml2-dev \
        libvpx-dev \
        m4 \
        make \
        meson \
        nasm \
        ninja-build \
        patch \
        pkg-config \
        python3 \
        tar \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

ARG HANDBRAKE_GIT_TAG 'master'
RUN \
    git clone --depth 1 https://github.com/HandBrake/HandBrake.git -b "$HANDBRAKE_GIT_TAG" /HandBrake \
    && cd /HandBrake \
    && ./configure --launch-jobs=2 --launch --disable-gtk \
    && cp -v /HandBrake/build/HandBrakeCLI /usr/local/bin/HandBrakeCLI \
    && HandBrakeCLI --version \
    && rm -rf /HandBrake \
    && echo "$HANDBRAKE_GIT_TAG" > /HANDBRAKE_GIT_TAG

COPY transcode.sh /
RUN chmod +x /transcode.sh

VOLUME "/input"
VOLUME "/output"
VOLUME "/storage"

ENTRYPOINT [ "bash", "/transcode.sh" ]

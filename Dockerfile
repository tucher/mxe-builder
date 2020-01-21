FROM ubuntu:18.04

ENV BUILD_GROUPS=2
ENV BUILD_THREADS=16

RUN apt-get update && apt-get install -y  \
                autoconf \
                automake \
                autopoint \
                bash \
                bison \
                bzip2 \
                flex \
                g++ \
                g++-multilib \
                gettext \
                git \
                gperf \
                intltool \
                libc6-dev-i386 \
                libgdk-pixbuf2.0-dev \
                libltdl-dev \
                libssl-dev \
                libtool-bin \
                libxml-parser-perl \
                lzip \
                make \
                openssl \
                p7zip-full \
                patch \
                perl \
                pkg-config \
                python \
                ruby \
                sed \
                unzip \
                wget \
                xz-utils

RUN cd / && git clone https://github.com/mxe/mxe.git && cd /mxe

RUN echo "MXE_PLUGIN_DIRS += plugins/gcc9\n" > /mxe/settings.mk
#MXE_TARGETS := i686-w64-mingw32.static.posix i686-w64-mingw32.shared.posix x86_64-w64-mingw32.shared.posix x86_64-w64-mingw32.static.posix


RUN cd /mxe && make MXE_TARGETS='x86_64-w64-mingw32.shared.posix x86_64-w64-mingw32.static.posix' \
                cc \
                cmake \
                autotools \
                --jobs=$BUILD_GROUPS JOBS=$BUILD_THREADS \
                && make clean-pkg && make clean-junk
ENV PATH="/mxe/usr/bin:${PATH}"

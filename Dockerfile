FROM ubuntu:22.04

ENV BUILD_GROUPS=1
ENV BUILD_THREADS=10
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y  \
                autoconf \
                automake \
                autopoint \
                bash \
                bison \
                bzip2 \
                flex \
                g++ \
                gettext \
                git \
                gperf \
                intltool \
                libgdk-pixbuf2.0-dev \
                libltdl-dev \
                libgl-dev \
                libssl-dev \
                libtool-bin \
                libxml-parser-perl \
                lzip \
                make \
                openssl \
                p7zip-full \
                patch \
                perl \
                python3 \
                python3-mako \
                python3-pkg-resources \
                python-is-python3 \
                ruby \
                sed \
                unzip \
                wget \
                xz-utils

RUN cd / && git clone https://github.com/mxe/mxe.git && cd /mxe && git checkout 70e31e42f0584fea37aa46a74dcaa6e4eecd4304

RUN echo "MXE_PLUGIN_DIRS += plugins/gcc13\n" > /mxe/settings.mk

RUN cd /mxe && make MXE_TARGETS='x86_64-w64-mingw32.shared.posix x86_64-w64-mingw32.static.posix' \
                cc \
                cmake \
                autotools \
                --jobs=$BUILD_GROUPS JOBS=$BUILD_THREADS \
                && make clean-pkg && make clean-junk
ENV PATH="/mxe/usr/bin:${PATH}"

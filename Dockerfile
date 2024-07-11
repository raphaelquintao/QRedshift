FROM debian:12.0

WORKDIR /qredshift

RUN dpkg --add-architecture amd64
RUN dpkg --add-architecture i386
RUN dpkg --add-architecture arm64
RUN dpkg --add-architecture armhf
RUN dpkg --add-architecture armel
RUN dpkg --add-architecture mips64el
RUN dpkg --add-architecture mipsel
RUN dpkg --add-architecture ppc64el
RUN dpkg --add-architecture s390x

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install build-essential -y
RUN apt-get install gcc -y
RUN apt-get install gcc-i686-linux-gnu -y
RUN apt-get install gcc-aarch64-linux-gnu -y
RUN apt-get install gcc-arm-linux-gnueabihf -y
RUN apt-get install gcc-arm-linux-gnueabi -y
RUN apt-get install gcc-mips64el-linux-gnuabi64 -y
RUN apt-get install gcc-mipsel-linux-gnu -y
RUN apt-get install gcc-powerpc64le-linux-gnu -y
RUN apt-get install gcc-s390x-linux-gnu -y
RUN apt-get install libxrandr-dev:* libxcb1-dev:* libxcb-randr0-dev:* -y

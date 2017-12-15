FROM debian:stable

ENV LGSM_DOCKER_IMAGE LinuxGameServerManager
LABEL maintainer="jkljkl1197 on github"

ENV DEBIAN_FRONTEND noninteractive

## Ports Use can use -p port:port also
EXPOSE  27015:27015 7777:7777 7778:7778 27020:27020 443:443 80:80 \
	27015:27015/udp 7777:7777/udp 7778:7778/udp 27020:27020/udp 443:443/udp 80:80/udp

## Base System
RUN dpkg --add-architecture i386 && \
	apt-get update -y && \
	apt-get install -y --no-install-recommends apt-utils
## Dependency
RUN apt-get install -y \
	binutils \
	mailutils \
	postfix \
	bc \
	curl \
	wget \
	file \
	bzip2 \
	gzip \
	unzip \
	xz-utils \
	libmariadb2 \
	bsdmainutils \
	python \
	util-linux \
	ca-certificates \
	tmux \
	lib32gcc1 \
	libstdc++6 \
	libstdc++6:i386 \
	libstdc++5:i386 \
	libsdl1.2debian \
	default-jdk \
	lib32tinfo5 \
	speex:i386 \
	libtbb2 \
	libcurl4-gnutls-dev:i386 \
	libtcmalloc-minimal4:i386 \
	libncurses5:i386 \
	zlib1g:i386 \
	libldap-2.4-2:i386 \
	libxrandr2:i386 \
	libglu1-mesa:i386 \
	libxtst6:i386 \
	libusb-1.0-0-dev:i386 \
	libxxf86vm1:i386 \
	libopenal1:i386 \
	libgtk2.0-0:i386 \
	libdbus-glib-1-2:i386 \
	libnm-glib-dev:i386 \
 	cron \
       	procps \
 	locales \
	nano

ENV LGSM_DOCKER_VERSION 17.11.0

## UTF-8 Probleme ...
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

## lgsm.sh
RUN wget -N --no-check-certificate https://gameservermanagers.com/dl/linuxgsm.sh

## if you have a permission probleme, check uid gid with the command id of the real machine user lgsm
## you need to have the same guid and uid as your real machine storage/data folder
## for me, my real user uid is 1001 so i need to create a user for the virtual docker image with the same uid
## user config
RUN adduser --disabled-password --gecos "" --uid 1001 lgsm && \
    chown lgsm:lgsm /linuxgsm.sh && \
    chmod +x /linuxgsm.sh && \
    cp /linuxgsm.sh /home/lgsm/linuxgsm.sh && \
    usermod -G tty lgsm #solve ark script error

USER lgsm
WORKDIR /home/lgsm

#need to fake it linuxgsm
ENV TERM=xterm

## Docker Details
ENV PATH=$PATH:/home/lgsm

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

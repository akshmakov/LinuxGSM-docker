FROM debian:stable

ENV LGSM_DOCKER_IMAGE LinuxGameServerManager
LABEL maintainer="akshmakov@gmail.com"
## Edit By Jkljkl1197

#ENV DEBIAN_FRONTEND noninteractive

## Ports Use can use -p port:port also
EXPOSE 27015 7777 7778 27020

## Base System
RUN dpkg --add-architecture i386 && \
    apt-get update -y && \
    apt-get install -y \
    	 binutils \
    	 mailutils \
    	 postfix \
	 curl \
	 wget \
	 file \
	 bzip2 \
	 gzip \
	 unzip \
	 bsdmainutils \
	 python \
	 util-linux \
	 ca-certificates \
	 tmux \
	 lib32gcc1 \
	 libstdc++6 \
	 libstdc++6:i386 \
	 # ARK Dependancy/some add by me
	 lib32gcc1 \
	 cron \
         bc \
	 nano \
         procps \
	 locales

ENV LGSM_DOCKER_VERSION 17.11.0

## UTF-8 Probleme ...
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

## lgsm.sh
RUN wget -N --no-check-certificate https://gameservermanagers.com/dl/linuxgsm.sh

## if you have a permission probleme, check the with command id of the real machine user lgsm
## you need to have the same guid and uid as your real machine storage/data folder
## for me my real user is 1001 so i need to create a user for the machine with the same uid...
## user config
RUN adduser --disabled-password --gecos "" --uid 1001 lgsm && \
    chown lgsm:lgsm /linuxgsm.sh && \
    chmod +x /linuxgsm.sh && \
    cp /linuxgsm.sh /home/lgsm/linuxgsm.sh && \
    usermod -G tty lgsm

USER lgsm
WORKDIR /home/lgsm

#need to fake it linuxgsm
ENV TERM=xterm

## Docker Details

ENV PATH=$PATH:/home/lgsm

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

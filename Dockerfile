FROM debian:stable

LABEL maintainer="akshmakov@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

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
	 libstdc++6:i386

ENV LGSM_DOCKER_VERSION 17.11.0

## lgsm.sh
RUN wget -N --no-check-certificate https://gameservermanagers.com/dl/linuxgsm.sh

## user config
RUN adduser --disabled-password --gecos "" lgsm && \
    chown lgsm:lgsm /linuxgsm.sh && \
    chmod +x /linuxgsm.sh && \
    cp /linuxgsm.sh /home/lgsm/linuxgsm
    
USER lgsm
WORKDIR /home/lgsm

#need to fake it linuxgsm
ENV TERM=xterm

## Docker Details

ENV PATH=$PATH:/home/lgsm

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

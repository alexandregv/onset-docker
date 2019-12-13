FROM debian:buster

LABEL maintainer="contact@alexandregv.fr"

WORKDIR /Steam

# Set DEBIAN_FRONTEND to noninteractive during build only
ARG DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt-get update -y \
 && apt-get install -y \
      ca-certificates \
      lib32gcc1 \
      locales \
      openssl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Set locale to en_US.UTF-8
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8 \
    LANGUAGE en_US:en \ 
    LC_ALL en_US.UTF-8    

# Create and use "onset" user/group
RUN groupadd -r onset \
 && useradd --no-log-init -r -g onset onset \
 && chown -R onset:onset /Steam
USER onset:onset

# Download SteamCMD
ADD --chown=onset:onset https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz steamcmd_linux.tar.gz

# Install SteamCMD and OnsetServer
RUN tar zxvf steamcmd_linux.tar.gz \
 && chmod u+x steamcmd.sh \
 && ./steamcmd.sh +login anonymous +force_install_dir ./OnsetServer/ +app_update 1204170 validate +quit \
 && chmod u+x ./OnsetServer/start_linux.sh

EXPOSE 7777/udp 7776/udp 7775/tcp
WORKDIR ./OnsetServer/
ENTRYPOINT ./start_linux.sh

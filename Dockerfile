FROM debian:9

LABEL maintainer="contact@alexandregv.fr"

WORKDIR /Steam

# Set DEBIAN_FRONTEND to noninteractive during build only
ARG DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt-get update -y \
 && apt-get install -y \
      ca-certificates \
      lib32gcc1 \
      libmariadbclient-dev \
      locales \
      openssl \
      wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install dockerize
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
 && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
 && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Set locale to en_US.UTF-8
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8 \
    LANGUAGE en_US:en \
    LC_ALL en_US.UTF-8

# Make libmariadbclient.so.18 available in Debian buster (10)
#RUN ln -s /usr/lib/x86_64-linux-gnu/libmariadbclient.so /usr/lib/x86_64-linux-gnu/libmariadbclient.so.18

# Create and use "onset" user/group
RUN groupadd onset \
 && useradd --no-log-init -g onset onset \
 && chown -R onset:onset /Steam
USER onset:onset

# Download SteamCMD
ADD --chown=onset:onset https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz steamcmd_linux.tar.gz

# Install SteamCMD and OnsetServer
RUN tar zxvf steamcmd_linux.tar.gz \
 && chmod u+x steamcmd.sh \
 && ./steamcmd.sh +login anonymous +force_install_dir ./OnsetServer/ +app_update 1204170 validate +quit \
 && chmod u+x ./OnsetServer/start_linux.sh

WORKDIR ./OnsetServer/

# Import docker entrypoint
COPY --chown=onset:onset docker-entrypoint.sh .

# Fix start_linux.sh to handle arguments
RUN sed -i.bak 's/$/ \$@/' start_linux.sh; rm start_linux.sh.bak

EXPOSE 7777/udp 7776/udp 7775/tcp

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["./start_linux.sh"]

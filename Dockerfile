FROM alpine:latest AS builder

# Download SteamCMD
RUN wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz -O /tmp/steamcmd_linux.tar.gz && \
    mkdir -p /steamcmd && \
    tar -xvzf /tmp/steamcmd_linux.tar.gz -C /steamcmd

FROM tobix/wine:stable

RUN useradd -m -s /bin/bash steam

# Copy SteamCMD from the builder stage
COPY --from=builder --chown=steam:steam /steamcmd /home/steam/steamcmd

COPY entrypoint.sh /

USER steam

ENTRYPOINT [ "/entrypoint.sh" ]

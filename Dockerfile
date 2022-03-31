FROM ghcr.io/sdr-enthusiasts/docker-baseimage:python

RUN set -x && \
# define packages needed for installation and general management of the container:
    TEMP_PACKAGES=() && \
    KEPT_PACKAGES=() && \
    KEPT_PACKAGES+=(psmisc) && \
    KEPT_PACKAGES+=(mono-complete) && \
    # added for debugging
    KEPT_PACKAGES+=(procps nano aptitude netcat) && \
#
# Install all these packages:
    apt-get update && \
    apt-get install -o APT::Autoremove::RecommendsImportant=0 -o APT::Autoremove::SuggestsImportant=0 -o Dpkg::Options::="--force-confold" --force-yes -y --no-install-recommends  --no-install-suggests\
        ${KEPT_PACKAGES[@]} \
        ${TEMP_PACKAGES[@]} && \
#
# Clean up:
    apt-get remove -y ${TEMP_PACKAGES[@]} && \
    apt-get autoremove -o APT::Autoremove::RecommendsImportant=0 -o APT::Autoremove::SuggestsImportant=0 -y && \
    apt-get clean -y && \
    rm -rf /src/* /tmp/* /var/lib/apt/lists/*

# Copy the rootfs into place:
#
#
# Install VRS:
RUN set -x && \
   mkdir -p /opt/vrs
   pushd /opt/vrs
     curl -sL -o 1.tar.gz https://www.virtualradarserver.co.uk/Files/VirtualRadar.tar.gz && \
     curl -sL -o 2.tar.gz https://www.virtualradarserver.co.uk/Files/VirtualRadar.LanguagePack.tar.gz && \
     curl -sL -o 3.tar.gz https://www.virtualradarserver.co.uk/Files/VirtualRadar.WebAdminPlugin.tar.gz && \
     curl -sL -o 4.tar.gz https://www.virtualradarserver.co.uk/Files/VirtualRadar.DatabaseWriterPlugin.tar.gz && \
     curl -sL -o 5.tar.gz https://www.virtualradarserver.co.uk/Files/VirtualRadar.TileServerCachePlugin.tar.gz && \
     for i in *.tar.gz; do tar zxf $i; done && \
   popd && \

COPY rootfs/ /

EXPOSE 8080
EXPOSE 443

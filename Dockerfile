#FROM ghcr.io/sdr-enthusiasts/docker-baseimage:base
FROM ghcr.io/sdr-enthusiasts/docker-baseimage:base

RUN set -x && \
# define packages needed for installation and general management of the container:
    TEMP_PACKAGES=() && \
    KEPT_PACKAGES=() && \
    KEPT_PACKAGES+=(psmisc) && \
    KEPT_PACKAGES+=(unzip) && \
    KEPT_PACKAGES+=(mono-complete) && \
    # added for debugging
    KEPT_PACKAGES+=(nano netcat) && \
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
   mkdir -p /opt/vrs && \
   pushd /opt/vrs && \
     curl -sL -o 1.tar.gz https://github.com/vradarserver/vrs/releases/download/v3.0.0-preview-11-mono/VirtualRadar-3.0.0-preview-11.tar.gz && \
     curl -sL -o 2.tar.gz https://github.com/vradarserver/vrs/releases/download/v3.0.0-preview-11-mono/LanguagePack-3.0.0-preview-11.tar.gz && \
     curl -sL -o 3.tar.gz https://github.com/vradarserver/vrs/releases/download/v3.0.0-preview-11-mono/Plugin-WebAdmin-3.0.0-preview-11.tar.gz && \
     curl -sL -o 4.tar.gz https://github.com/vradarserver/vrs/releases/download/v3.0.0-preview-11-mono/Plugin-DatabaseWriter-3.0.0-preview-11.tar.gz && \
     curl -sL -o 5.tar.gz https://github.com/vradarserver/vrs/releases/download/v3.0.0-preview-11-mono/Plugin-TileServerCache-3.0.0-preview-11.tar.gz && \
     curl -sL -o 6.tar.gz https://github.com/vradarserver/vrs/releases/download/v3.0.0-preview-11-mono/Plugin-CustomContent-3.0.0-preview-11.tar.gz && \
     curl -sL -o 7.tar.gz https://github.com/vradarserver/vrs/releases/download/v3.0.0-preview-11-mono/Plugin-SqlServer-3.0.0-preview-11.tar.gz && \
     curl -sL -o 8.tar.gz https://github.com/vradarserver/vrs/releases/download/v3.0.0-preview-11-mono/Plugin-FeedFilter-3.0.0-preview-11.tar.gz && \
     curl -sL -o 9.tar.gz https://github.com/vradarserver/vrs/releases/download/v3.0.0-preview-11-mono/Plugin-DatabaseEditor-3.0.0-preview-11.tar.gz && \
     for i in *.tar.gz; do tar zxf $i; done && \
   popd && \
#
# Add some things to make it easier to debug:
echo "alias dir=\"ls -alsvH\"" >> /root/.bashrc && \
echo "alias nano=\"nano -l\"" >> /root/.bashrc

COPY rootfs/ /

EXPOSE 8080
EXPOSE 443

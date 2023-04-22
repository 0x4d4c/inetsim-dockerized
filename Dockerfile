FROM debian:10
MAINTAINER Martin Lambertz <martin@0x4d4c.xyz>

ENV INETSIM_VERSION=1.3.2 \
    INETSIM_SIGNING_KEY_ID=0xF1446B68CB026896 \
    INETSIM_SIGNING_KEY_FINGERPRINT=6D5205888B0232AADA6E5739F1446B68CB026896

#COPY ./patches /tmp/patches
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

RUN set -eu && \
    addgroup inetsim && \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        gnupg \
        libdigest-sha-perl \
        libio-socket-ssl-perl \
        libipc-shareable-perl \
        libnet-dns-perl \
        libnet-server-perl \
        perl \
        wget && \
    wget -q http://www.inetsim.org/inetsim-archive-signing-key.asc && \
    wget -q http://www.inetsim.org/downloads/inetsim-${INETSIM_VERSION}.tar.gz && \
    wget -q http://www.inetsim.org/downloads/inetsim-${INETSIM_VERSION}.tar.gz.sig && \
    gpg --import inetsim-archive-signing-key.asc && \
    test "$(gpg --with-colons --fingerprint ${INETSIM_SIGNING_KEY_ID} | sed -n 's/^fpr:\+\(\w\+\):$/\1/p')" = "${INETSIM_SIGNING_KEY_FINGERPRINT}" && \
    gpg --verify inetsim-${INETSIM_VERSION}.tar.gz.sig inetsim-${INETSIM_VERSION}.tar.gz && \
    tar -xf inetsim-${INETSIM_VERSION}.tar.gz && \
    mkdir -p /opt && \
    mv inetsim-${INETSIM_VERSION} /opt/inetsim && \
    cd /opt/inetsim && \
    cp -r data default_data && \
    mkdir -p conf/default_configs && \
    rm -rf \
        /inetsim-${INETSIM_VERSION}.tar.gz \
        /inetsim-${INETSIM_VERSION}.tar.gz.sig \
        /inetsim-archive-signing-key.asc \
        /root/.gnupg && \
    apt-get purge -y wget && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

COPY ./default_service_configs /opt/inetsim/conf/default_configs
COPY ./generate-inetsim-config.sh /usr/local/bin/generate-inetsim-config.sh
COPY ./populate-data-directory.sh /usr/local/bin/populate-data-directory.sh
VOLUME ["/opt/inetsim/conf/user_configs", \
        "/opt/inetsim/data", \
        "/opt/inetsim/log", \
        "/opt/inetsim/report"]
ENV PATH $PATH:/opt/inetsim
WORKDIR /opt/inetsim/
CMD ["inetsim"]

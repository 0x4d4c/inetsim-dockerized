FROM alpine:latest
MAINTAINER Martin Lambertz <martin@0x4d4c.xyz>

ENV INETSIM_VERSION=1.2.6 \
    INETSIM_SIGNING_KEY_ID=0x6881B9A7E9F601C8 \
    INETSIM_SIGNING_KEY_FINGERPRINT=5ADF5239D9AAAD3C455094916881B9A7E9F601C8

COPY ./patches/00-untaint-dns-port.patch /tmp/
COPY ./generate-inetsim-config.sh /usr/local/bin/generate-inetsim-config.sh
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

RUN set -eu && \
    addgroup inetsim && \
    apk add --no-cache --virtual .build-deps \
        build-base \
        gnupg \
        libidn-dev \
        openssl-dev \
        perl-dev && \
    apk --no-cache add \
        libidn \
        openssl \
        perl && \
    PERL_MM_USE_DEFAULT=1 cpan install Net::LibIDN && \
    PERL_MM_USE_DEFAULT=1 cpan install \
        Digest::SHA \
        IO::Socket::SSL \
        IPC::Shareable \
        Net::DNS \
        Net::Server && \
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
    patch -p1 < /tmp/00-untaint-dns-port.patch && \
    ./setup.sh && \
    rm -rf \
        inetsim-${INETSIM_VERSION}.tar.gz \
        inetsim-${INETSIM_VERSION}.tar.gz.sig \
        inetsim-archive-signing-key.asc \
        /root/.gnupg && \
    apk del .build-deps

ENV PATH $PATH:/opt/inetsim
WORKDIR /opt/inetsim/
CMD ["inetsim"]

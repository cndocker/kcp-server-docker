# kcp-server for Dockerfile
FROM alpine:latest
MAINTAINER cnDocker

ENV TERM=linux \
    kcptun_latest="https://github.com/xtaci/kcptun/releases/latest" \
    DATA_DIR=/usr/local/kcp-server \
    CONF_DIR="/usr/local/conf"

RUN set -x && \
    apk --update --no-cache add build-base tar wget curl bash && \
    mkdir /tmp/libsodium && \
    curl -Lk https://github.com/jedisct1/libsodium/releases/download/1.0.10/libsodium-1.0.10.tar.gz|tar xz -C /tmp/libsodium --strip-components=1 && \
    cd /tmp/libsodium && \
    ./configure && \
    make -j $(awk '/processor/{i++}END{print i}' /proc/cpuinfo) && \
    make install && \
    [ ! -d ${CONF_DIR} ] && mkdir -p ${CONF_DIR} && \
    [ ! -d ${DATA_DIR} ] && mkdir -p ${DATA_DIR} && cd ${DATA_DIR} && \
    wget https://raw.githubusercontent.com/clangcn/kcp-server/master/socks5_latest/socks5_linux_amd64 -O /usr/local/kcp-server/socks5 && \
    kcptun_latest_release=`curl -s ${kcptun_latest} | cut -d\" -f2` && \
    kcptun_latest_download=`curl -s ${kcptun_latest} | cut -d\" -f2 | sed 's/tag/download/'` && \
    kcptun_latest_filename=`curl -s ${kcptun_latest_release} | sed -n '/<strong>kcptun-linux-amd64/p' | cut -d">" -f2 | cut -d "<" -f1` && \
    wget ${kcptun_latest_download}/${kcptun_latest_filename} -O /usr/local/kcp-server/${kcptun_latest_filename} && \
    tar xzf /usr/local/kcp-server/${kcptun_latest_filename} -C /usr/local/kcp-server/ && \
    mv /usr/local/kcp-server/server_linux_amd64 /usr/local/kcp-server/kcp-server && \
    chown root:root /usr/local/kcp-server/* && \
    chmod 755 /usr/local/kcp-server/* && \
    ln -s /usr/local/kcp-server/kcp-server /bin/kcp-server && \
    ln -s /usr/local/kcp-server/socks5 /bin/socks5 && \
    apk --no-cache del build-base && \
    rm -rf /var/cache/apk/* ~/.cache /tmp/libsodium /usr/local/kcp-server/client_linux_amd64 /usr/local/kcp-server/${kcptun_latest_filename}

WORKDIR ${DATA_DIR}
VOLUME [${DATA_DIR}]
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]


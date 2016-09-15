#!/bin/bash
#########################################################################
# File Name: kcp-server.sh
# Version:1.0.20160915
# Created Time: 2016-09-15
#########################################################################

set -e
set -- kcp-server "$@"
KCPTUN_LISTEN=${KCPTUN_LISTEN:-45678}                     #"listen": ":45678",
KCPTUN_SOCKS5_PORT=${KCPTUN_SOCKS5_PORT:-12948}           #"socks_port": 12948,
KCPTUN_KEY=${KCPTUN_KEY:-password}                        #"key": "password",
KCPTUN_CRYPT=${KCPTUN_CRYPT:-aes}                         #"crypt": "aes",
KCPTUN_MODE=${KCPTUN_MODE:-fast2}                         #"mode": "fast2",
KCPTUN_MTU=${KCPTUN_MTU:-1350}                            #"mtu": 1350,
KCPTUN_SNDWND=${KCPTUN_SNDWND:-1024}                      #"sndwnd": 1024,
KCPTUN_RCVWND=${KCPTUN_RCVWND:-1024}                      #"rcvwnd": 1024,
KCPTUN_NOCOMP=${KCPTUN_NOCOMP:-false}                     #"nocomp": false
KCPTUN_CONF="/usr/local/conf/kcptun_config.json"
[ ! -f ${KCPTUN_CONF} ] && cat > ${KCPTUN_CONF}<<-EOF
{
    "listen": ":${KCPTUN_LISTEN}",
    "target": "127.0.0.1:${KCPTUN_SOCKS5_PORT}",
    "key": "${KCPTUN_KEY}",
    "crypt": "${KCPTUN_CRYPT}",
    "mode": "${KCPTUN_MODE}",
    "mtu": ${KCPTUN_MTU},
    "sndwnd": ${KCPTUN_SNDWND},
    "rcvwnd": ${KCPTUN_RCVWND},
    "nocomp": false
}
EOF
if [[ "${KCPTUN_NOCOMP}" =~ ^[Tt][Rr][Uu][Ee]|[Yy][Ee][Ss]|[Yy]|1|[Ee][Nn][Aa][Bb][Ll][Ee]$ ]]; then
    sed -ri "s/(\"nocomp\":).*/\1 true/" ${KCPTUN_CONF}
fi
echo "+------------------------------------------------+"
echo "|            Manager for kcp-server              |"
echo "+------------------------------------------------+"
echo "|      Images: cndocker/kcp-server:latest        |"
echo "+------------------------------------------------+"
echo "|      Intro: https://github.com/cndocker        |"
echo "+------------------------------------------------+"
echo ""
nohup socks5 127.0.0.1:${KCPTUN_SOCKS5_PORT}  >/dev/null 2>&1 &
sleep 0.3
echo "Socks5 (pid `pidof socks5`)is running."
netstat -ntlup | grep socks5
echo "Starting ${@}..."
kcp-server -v
exec "${@}" -c ${KCPTUN_CONF}


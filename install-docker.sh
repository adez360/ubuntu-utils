#!/bin/bash

RED='\e[31m'
NC='\e[0m'
YELLOW='\e[33m'
GREEN='\e[32m'

if [ "$EUID" -ne 0 ]; then
    echo -e "[${RED}Error${NC}] Please run as root." >&2
    exit 1
fi

echo -e "${YELLOW}Installing docker...${NC}"
apt-get update >/dev/null && apt-get install -y qq ca-certificates curl >/dev/null 2>&1
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
tee /etc/apt/sources.list.d/docker.sources >/dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

apt-get update >/dev/null
apt-get install -y qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin >/dev/null 2>&1

echo -e "${YELLOW}Installation successful."

#!/bin/bash
set -ouex pipefail

# Docker Repo
tee /etc/yum.repos.d/docker-ce.repo <<'EOF'
[docker-ce-stable]
name=Docker CE Stable - $basearch
baseurl=https://download.docker.com/linux/fedora/$releasever/$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/fedora/gpg
EOF

dnf5 -y install dnf5-plugins

# Base
PACKAGES=(
    git
    git-lfs
    zsh
    curl
    htop
    wget
)

# Photography
PACKAGES+=(
    gphoto2
    v4l2loopback
    ffmpeg
    ddcutil
)
# Docker
PACKAGES+=(
    containerd.io
    docker-buildx-plugin
    docker-ce
    docker-ce-cli
    docker-compose-plugin
)

dnf5 install -y "${PACKAGES[@]}"

# Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate --no-confirm --no-start-daemon
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --update
#!/bin/bash
set -ouex pipefail

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
  #v4l2loopback
  ffmpeg
  ddcutil
)

# Tools
PACKAGES+=(
  kitty
)

dnf5 install -y "${PACKAGES[@]}"

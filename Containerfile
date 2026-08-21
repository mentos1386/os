ARG FLAVOR=bazzite-gnome
ARG VERSION=stable-44

# Base Image
FROM ghcr.io/ublue-os/${FLAVOR}:${VERSION}

### MODIFICATIONS
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
<<EOF
  # Docker Repo
  tee /etc/yum.repos.d/docker-ce.repo <<EOD
  [docker-ce-stable]
  name=Docker CE Stable - \$basearch
  baseurl=https://download.docker.com/linux/fedora/\$releasever/\$basearch/stable
  enabled=1
  gpgcheck=1
  gpgkey=https://download.docker.com/linux/fedora/gpg
  EOD

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
    #v4l2loopback
    ffmpeg
    ddcutil
  )

  # Tools
  PACKAGES+=(
    kitty
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
EOF

# Create empty folder to prepare for Nix install.
# Ref: https://github.com/DeterminateSystems/nix-installer/issues/1445#issuecomment-2816777981
 RUN mkdir /nix

### LINTING
## Verify final image and contents are correct.
RUN bootc container lint

LABEL io.artifacthub.package.readme-url=https://code.tjo.space/mentos1386/os/raw/refs/heads/main/README.md
LABEL org.opencontainers.image.description="My Customized Universal Blue Image"
LABEL org.opencontainers.image.documentation=https://code.tjo.space/mentos1386/os/raw/refs/heads/main/README.md
LABEL org.opencontainers.image.source=https://code.tjo.space/mentos1386/os/src/branch/main/Containerfile
LABEL org.opencontainers.image.url=https://code.tjo.space/mentos1386/os
LABEL org.opencontainers.image.vendor=mentos1386
LABEL io.artifacthub.package.deprecated=false
LABEL io.artifacthub.package.keywords=bootc,ublue,universal-blue
LABEL io.artifacthub.package.license=Apache-2.0
LABEL io.artifacthub.package.logo-url=https://code.tjo.space/avatar/39c22fb1566b297cf9f16889638fc2eb?size=512
LABEL io.artifacthub.package.prerelease=false
LABEL containers.bootc=1

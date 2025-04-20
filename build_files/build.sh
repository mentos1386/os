#!/bin/bash

set -ouex pipefail

# Create empty folder to prepare for Nix install.
# Ref: https://github.com/DeterminateSystems/nix-installer/issues/1445#issuecomment-2816777981
mkdir /nix
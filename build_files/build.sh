#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y ckb-next vrms-rpm

#change imageinfo for fastfetch
jq '.["image-name"]="blueraptor" | .["image-ref"]="ostree-image-signed:docker://ghcr.io/thegreatzach/blueraptor"' /usr/share/ublue-os/image-info.json > /tmp/image-info.json && mv /tmp/image-info.json /usr/share/ublue-os/image-info.json

jq '.modules = (.modules[:-2] + [{"type":"command","key":"📦 VRMS","text":"vrms-rpm --licence-list tweaked --grammar spdx-lenient | head -n 1","shell":"/bin/bash"},{"type":"command","key":"📦 VRMS","text":"vrms-rpm --licence-list tweaked --grammar spdx-lenient | head -n 2 | tail -n 1","shell":"/bin/bash"}]+ .modules[-2:])' /usr/share/ublue-os/fastfetch.jsonc > /tmp/image-info.json && mv /tmp/image-info.json /usr/share/ublue-os/fastfetch.jsonc

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket

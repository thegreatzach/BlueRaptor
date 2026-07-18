#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y ckb-next vrms-rpm

dnf5 install -y steam gamescope mangohud

dnf5 -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release{,-extras,-mesa}

dnf5 --enable-repo=terra-mesa --enable-repo=terra -y install scopebuddy

mkdir -p /usr/lib/extest/ && \
curl -Lo /usr/lib/extest/libextest.so \
  "$(curl -s https://api.github.com/repos/ublue-os/extest/releases/latest \
     | jq -r '.assets[] | select(.name | test("\\.so$")).browser_download_url')" && \
setfattr -n user.component -v "extest" /usr/lib/extest/libextest.so

#change imageinfo for fastfetch
jq '.["image-name"]="blueraptor" | .["image-ref"]="ostree-image-signed:docker://ghcr.io/thegreatzach/blueraptor"' /usr/share/ublue-os/image-info.json > /tmp/image-info.json && mv /tmp/image-info.json /usr/share/ublue-os/image-info.json

#Not sure why this doesnt work... shows as "FREE_PACKAGE_COUNT" not acutal VRMS output
#jq '.modules = (.modules[:-2] + [{"type":"command","key":"📦 VRMS","text":"vrms-rpm --licence-list tweaked --grammar spdx-lenient | head -n 1 | tr -d '\''\n'\''","shell":"/bin/bash"},{"type":"command","key":"📦 VRMS","text":"vrms-rpm --licence-list tweaked --grammar spdx-lenient | head -n 2 | tail -n 1 | tr -d '\''\n'\''","shell":"/bin/bash"}]+ .modules[-2:])' /usr/share/ublue-os/fastfetch.jsonc > /tmp/image-info.json && mv /tmp/image-info.json /usr/share/ublue-os/fastfetch.jsonc

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

dnf5 -y copr enable scottames/ghostty
dnf5 -y install ghostty
dnf5 -y copr disable scottames/ghostty

#dnf5 config-manager --add-repo https://us-central1-yum.pkg.dev/projects/antigravity-auto-updater-dev/antigravity-rpm
#dnf5 makecache

#cp /ctx/steam.desktop /usr/share/wayland-sessions/steam.desktop

#dnf5 install antigravity

#### Example for enabling a System Unit File

systemctl enable podman.socket

#!/bin/bash
set -e

ARCH=$1
BIN=$2
VERSION=${3:-1.0.0}
PKG_NAME="qredshift"

# Map arch names to Debian arch names
declare -A DEB_ARCH_MAP=(
  [x86_64]="amd64"
  [i686]="i386"
  [aarch64]="arm64"
  [armv7l]="armhf"
  [armv5tel]="armel"
  [mips64el]="mips64el"
  [mipsel]="mipsel"
  [powerpc64le]="ppc64el"
  [s390x]="s390x"
)

DEB_ARCH="${DEB_ARCH_MAP[$ARCH]}"
if [ -z "$DEB_ARCH" ]; then
  echo "Unknown architecture: $ARCH"
  exit 1
fi

PKG_DIR="build/deb/${PKG_NAME}_${VERSION}_${DEB_ARCH}"


rm -rf "$PKG_DIR"

# Create directory structure
mkdir -p "$PKG_DIR/DEBIAN"
mkdir -p "$PKG_DIR/usr/bin"

# Copy binary
cp "build/$BIN" "$PKG_DIR/usr/bin/qredshift"
chmod 755 "$PKG_DIR/usr/bin/qredshift"

# Create control file
cat > "$PKG_DIR/DEBIAN/control" <<EOF
Package: ${PKG_NAME}
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: ${DEB_ARCH}
Depends: libx11-6, libxrandr2, libxcb1, libxcb-randr0
Maintainer: Raphael Quintao <raphaelquintao@gmail.com>
Homepage: https://github.com/raphaelquintao/QRedshift
Description: A lightweight terminal application to adjust screen color temperature.
EOF

dpkg-deb --build --root-owner-group "$PKG_DIR"


mv "${PKG_DIR}.deb" "build/"
rm -rf "$PKG_DIR"

echo "Created: build/${PKG_NAME}_${VERSION}_${DEB_ARCH}.deb"

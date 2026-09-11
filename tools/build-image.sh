#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
mkdir -p "$ROOT/out/image"
if command -v cpio >/dev/null 2>&1; then
  (cd "$ROOT/out/rootfs" && find . -print | cpio -o -H newc > "$ROOT/out/image/initramfs.img")
else echo 'cpio is required to create initramfs'; exit 1; fi
printf '%s\n' 'Image created: out/image/initramfs.img'

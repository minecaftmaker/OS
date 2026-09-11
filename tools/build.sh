#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
OUT="$ROOT/out"
mkdir -p "$OUT/rootfs" "$OUT/iso/boot"
printf '%s\n' '[NovaOS] assembling build tree'
command -v gcc >/dev/null 2>&1 || { echo 'gcc is required'; exit 1; }
command -v make >/dev/null 2>&1 || { echo 'make is required'; exit 1; }
cp "$ROOT/config/nova-release" "$OUT/rootfs/etc-nova-release"
printf '%s\n' '[NovaOS] build staging complete'

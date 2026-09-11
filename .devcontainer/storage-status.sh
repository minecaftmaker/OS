#!/usr/bin/env bash
set -Eeuo pipefail
VOLUME_NAME="novaos-macos-data"
docker volume create "$VOLUME_NAME" >/dev/null
MOUNT=$(docker volume inspect -f '{{.Mountpoint}}' "$VOLUME_NAME")
echo '=== Codespaces ==='
df -h /workspaces | tail -n 1
echo
echo '=== macOS VM volume ==='
df -h "$MOUNT" | tail -n 1
echo
echo "Volume: $VOLUME_NAME"
echo "Mount:  $MOUNT"
echo
echo '=== Docker usage ==='
docker system df || true

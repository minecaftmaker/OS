#!/usr/bin/env bash
set -Eeuo pipefail

# Keep VM storage out of the Codespaces /workspaces loop filesystem.
# The macOS disk is stored in a Docker-managed volume and remains sparse.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

VOLUME_NAME="novaos-macos-data"
WORKSPACE_WARN_GB=6
WORKSPACE_CRITICAL_GB=2

workspace_free_gb() {
  local kb
  kb=$(df -Pk /workspaces | awk 'NR==2 {print $4}')
  echo $((kb / 1024 / 1024))
}

echo "[codespaces] workspace free: $(workspace_free_gb) GiB"

# Reclaim Docker build/image cache, but never touch the persistent macOS volume.
if (( $(workspace_free_gb) < WORKSPACE_WARN_GB )); then
  echo "[codespaces] reclaiming Docker cache..."
  docker system prune -af --volumes=false || true
  docker builder prune -af || true
  docker image prune -af || true
fi

# Ensure the persistent VM volume exists before Compose starts the VM.
docker volume create "$VOLUME_NAME" >/dev/null

VOLUME_MOUNT=$(docker volume inspect -f '{{.Mountpoint}}' "$VOLUME_NAME")
mkdir -p "$VOLUME_MOUNT"

# Report both filesystems: the workspace is no longer where the VM disk lives.
workspace_free=$(workspace_free_gb)
volume_free_kb=$(df -Pk "$VOLUME_MOUNT" | awk 'NR==2 {print $4}')
volume_free_gb=$((volume_free_kb / 1024 / 1024))

printf '[codespaces] VM volume: %s\n' "$VOLUME_MOUNT"
printf '[codespaces] VM volume free: %s GiB\n' "$volume_free_gb"
printf '[codespaces] VM storage mode: Docker volume + sparse qcow2\n'

if (( workspace_free < WORKSPACE_CRITICAL_GB )); then
  echo "ERROR: less than ${WORKSPACE_CRITICAL_GB} GiB remain in /workspaces."
  echo "Recreate/clean the Codespace before continuing."
  exit 1
fi

if (( volume_free_gb < 6 )); then
  echo "ERROR: less than 6 GiB remain on the filesystem backing the macOS volume."
  echo "Refusing to start the VM to avoid taking the Codespace offline."
  exit 1
fi

# Never prune volumes here: novaos-macos-data contains the macOS VM.
echo "[codespaces] storage guard passed"

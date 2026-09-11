#!/usr/bin/env bash
set -Eeuo pipefail

# Codespaces runs initializeCommand before the workspace bind mount exists.
# The macOS VM is therefore measured from its Docker volume, not /workspaces.
VOLUME_NAME="novaos-macos-data"
WORKSPACE_WARN_GB=6
VOLUME_WARN_GB=8
VOLUME_CRITICAL_GB=3

workspace_free_gb() {
  local path="${CODESPACE_VSCODE_FOLDER:-${PWD:-/}}"
  local kb
  if [ -d "$path" ] && kb=$(df -Pk "$path" 2>/dev/null | awk 'NR==2 {print $4}'); then
    echo $((kb / 1024 / 1024))
  else
    # During initializeCommand /workspaces may not exist yet. Do not treat
    # that as zero free space; it is simply not mounted at this stage.
    echo -1
  fi
}

docker volume create "$VOLUME_NAME" >/dev/null
VOLUME_MOUNT=$(docker volume inspect -f '{{.Mountpoint}}' "$VOLUME_NAME")
mkdir -p "$VOLUME_MOUNT"

volume_free_kb=$(df -Pk "$VOLUME_MOUNT" | awk 'NR==2 {print $4}')
volume_free_gb=$((volume_free_kb / 1024 / 1024))
workspace_free=$(workspace_free_gb)

printf '[codespaces] workspace free: '
if (( workspace_free < 0 )); then
  printf 'not mounted yet\n'
else
  printf '%s GiB\n' "$workspace_free"
fi
printf '[codespaces] VM volume: %s\n' "$VOLUME_MOUNT"
printf '[codespaces] VM volume free: %s GiB\n' "$volume_free_gb"
printf '[codespaces] VM storage mode: Docker volume + sparse qcow2\n'

# Reclaim Docker image/build cache only. Never prune volumes because the VM
# disk itself is stored in novaos-macos-data.
if (( volume_free_gb < VOLUME_WARN_GB )); then
  echo "[codespaces] low volume-backed storage; reclaiming non-volume Docker cache..."
  docker system prune -af --volumes=false || true
  docker builder prune -af || true
  docker image prune -af || true
fi

# Once a workspace mount exists, protect it too, but never fail merely because
# initializeCommand runs before the mount is available.
if (( workspace_free >= 0 && workspace_free < WORKSPACE_WARN_GB )); then
  echo "[codespaces] warning: workspace has less than ${WORKSPACE_WARN_GB} GiB free"
fi

if (( volume_free_gb < VOLUME_CRITICAL_GB )); then
  echo "ERROR: less than ${VOLUME_CRITICAL_GB} GiB remain on the filesystem backing the macOS VM."
  echo "Refusing to start the VM to avoid taking the Codespace offline."
  exit 1
fi

echo "[codespaces] storage guard passed"

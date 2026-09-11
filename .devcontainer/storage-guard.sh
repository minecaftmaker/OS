#!/usr/bin/env bash
set -Eeuo pipefail

# GitHub Codespaces default storage can be 32 GB. Keep the guest disk sparse
# and reclaim Docker cache before macOS is started.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

TARGET_GB=32
VM_CAP_GB=24
MIN_FREE_GB=5

free_kb=$(df -Pk . | awk 'NR==2 {print $4}')
free_gb=$((free_kb / 1024 / 1024))

echo "[codespaces] free workspace storage: ${free_gb} GiB"

if (( free_gb < MIN_FREE_GB )); then
  echo "[codespaces] reclaiming Docker cache..."
  docker system prune -af --volumes || true
  docker builder prune -af || true
fi

mkdir -p "$ROOT/macos"

# Abort before a normal file operation can consume the entire Codespace disk.
free_kb=$(df -Pk . | awk 'NR==2 {print $4}')
free_gb=$((free_kb / 1024 / 1024))
if (( free_gb < 2 )); then
  echo "ERROR: less than 2 GiB remain in the Codespace filesystem."
  echo "Delete caches or recreate the Codespace before starting macOS."
  exit 1
fi

# Remove only transient build/cache material. The macOS VM data under ./macos is preserved.
docker system prune -af || true

echo "[codespaces] target: <= ${TARGET_GB} GiB host storage"
echo "[codespaces] VM virtual-capacity ceiling: ${VM_CAP_GB} GiB"
echo "[codespaces] sparse qcow2 growth is intentional; it does not preallocate ${VM_CAP_GB} GiB"

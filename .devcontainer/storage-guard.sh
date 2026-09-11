#!/usr/bin/env bash
set -Eeuo pipefail

# Codespaces host storage is limited. The macOS guest therefore uses a sparse
# qcow2 image whose *logical* capacity is larger than the host space it initially
# consumes. Do not change DISK_SIZE below without re-evaluating the storage budget.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

TARGET_GB=32
VM_LOGICAL_GB=44
MIN_FREE_GB=5
CRITICAL_FREE_GB=2

free_kb=$(df -Pk . | awk 'NR==2 {print $4}')
free_gb=$((free_kb / 1024 / 1024))

echo "[codespaces] free workspace storage: ${free_gb} GiB"

echo "[codespaces] logical macOS disk: ${VM_LOGICAL_GB} GiB (qcow2 sparse)"

if (( free_gb < MIN_FREE_GB )); then
  echo "[codespaces] reclaiming Docker cache..."
  docker system prune -af --volumes || true
  docker builder prune -af || true
fi

mkdir -p "$ROOT/macos"

free_kb=$(df -Pk . | awk 'NR==2 {print $4}')
free_gb=$((free_kb / 1024 / 1024))
if (( free_gb < CRITICAL_FREE_GB )); then
  echo "ERROR: less than ${CRITICAL_FREE_GB} GiB remain in the Codespace filesystem."
  echo "Delete caches or recreate the Codespace before starting macOS."
  exit 1
fi

# Reclaim transient Docker layers but never remove ./macos VM data.
docker system prune -af || true

echo "[codespaces] host target: <= ${TARGET_GB} GiB"
echo "[codespaces] macOS logical disk: ${VM_LOGICAL_GB} GiB"
echo "[codespaces] qcow2 is sparse; its physical usage grows only as macOS writes data."

#!/usr/bin/env bash
set -Eeuo pipefail

# Codespaces has a fixed physical filesystem. The macOS guest therefore uses a
# sparse qcow2 image whose logical capacity is large enough for Tahoe's installer
# while its physical footprint grows only as blocks are actually written.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

TARGET_GB=32
VM_LOGICAL_GB=44
WARN_FREE_GB=8
CRITICAL_FREE_GB=3

free_kb=$(df -Pk . | awk 'NR==2 {print $4}')
free_gb=$((free_kb / 1024 / 1024))

echo "[codespaces] free workspace storage: ${free_gb} GiB"
echo "[codespaces] logical macOS disk: ${VM_LOGICAL_GB} GiB (qcow2 sparse)"

if (( free_gb < WARN_FREE_GB )); then
  echo "[codespaces] low storage; reclaiming Docker build/cache data..."
  docker system prune -af --volumes || true
  docker builder prune -af || true
  docker image prune -af || true
fi

mkdir -p "$ROOT/macos"

free_kb=$(df -Pk . | awk 'NR==2 {print $4}')
free_gb=$((free_kb / 1024 / 1024))
if (( free_gb < CRITICAL_FREE_GB )); then
  echo "ERROR: less than ${CRITICAL_FREE_GB} GiB remain in the Codespace filesystem."
  echo "The macOS VM is intentionally not started with dangerously low host storage."
  echo "Delete caches or recreate the Codespace before continuing."
  exit 1
fi

# Avoid retaining transient Docker layers between Codespace rebuilds.
docker system prune -af || true

echo "[codespaces] host storage budget: ${TARGET_GB} GiB"
echo "[codespaces] macOS logical capacity: ${VM_LOGICAL_GB} GiB"
echo "[codespaces] physical qcow2 usage grows only as macOS writes blocks"

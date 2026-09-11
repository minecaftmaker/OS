#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
rm -rf macos
mkdir -p macos
docker system prune -af --volumes || true
docker builder prune -af || true
echo "Reset complete. The next start will create a fresh 24 GiB sparse qcow2 guest disk."

#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

before=$(docker system df --format '{{.Size}}' 2>/dev/null || true)
echo "Docker usage before cleanup: ${before:-unknown}"
docker system prune -af --volumes || true
docker builder prune -af || true

echo "Docker usage after cleanup:"
docker system df || true

echo "Workspace usage:"
du -sh ./* 2>/dev/null | sort -h | tail -n 20 || true

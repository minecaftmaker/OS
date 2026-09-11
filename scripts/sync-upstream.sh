#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
mkdir -p vendor
if [ -d vendor/dockur-macos/.git ]; then
  git -C vendor/dockur-macos fetch --depth=1 origin master
  git -C vendor/dockur-macos reset --hard origin/master
else
  rm -rf vendor/dockur-macos
  git clone --depth=1 https://github.com/dockur/macos.git vendor/dockur-macos
fi
sha=$(git -C vendor/dockur-macos rev-parse HEAD)
printf '%s\n' "$sha" > vendor/dockur-macos.commit
printf 'Synced Dockur macOS upstream: %s\n' "$sha"

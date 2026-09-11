#!/bin/sh
set -eu
for x in gcc make cpio xorriso; do command -v "$x" >/dev/null 2>&1 && echo "ok: $x" || echo "missing: $x"; done

#!/bin/sh
set -eu
case "${1:-}" in
 list) ls /var/lib/nova/packages 2>/dev/null || true ;;
 install) echo "install requested: ${2:-}" ;;
 remove) echo "remove requested: ${2:-}" ;;
 *) echo 'usage: nova-pkg {list|install|remove} [package]' ; exit 2 ;;
esac

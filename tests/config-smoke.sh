#!/bin/sh
set -eu
test -f config/os-release
test -f config/nova-release
echo config-smoke: PASS

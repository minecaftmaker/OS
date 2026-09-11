#!/bin/sh
set -eu
test -f boot/grub/grub.cfg
test -f init/nova-init
echo boot-smoke: PASS

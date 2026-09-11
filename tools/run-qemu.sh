#!/bin/sh
set -eu
exec qemu-system-x86_64 -m 2048 -smp 2 -kernel out/iso/boot/vmlinuz -initrd out/image/initramfs.img -append 'console=ttyS0' -nographic

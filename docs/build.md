# Building NovaOS

Use a Linux x86_64 host. Install GCC, GNU make, cpio, QEMU, and optionally xorriso. Run `./tools/check-deps.sh`, then `./tools/build.sh`. The project deliberately downloads/pins upstream Linux and BusyBox sources instead of duplicating their enormous source trees.

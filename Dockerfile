# Optimized overlay image. Runtime behavior comes from upstream Dockur.
FROM ghcr.io/dockur/macos:latest

ENV VERSION=26 \
    RAM_SIZE=6G \
    CPU_CORES=2 \
    DISK_SIZE=24G \
    DISK_FMT=qcow2 \
    DISK_CACHE=none \
    DISK_TYPE=blk

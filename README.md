# NovaOS

A Linux-based desktop operating system project inspired by Windows 11 usability and Linux openness.

This repository is intentionally organized as a complete OS source tree: boot configuration, kernel configuration, init/services, package tooling, desktop shell, system applications, themes, documentation, tests, and image-building scripts.

## Architecture

- Linux kernel: configured as the hardware kernel rather than reimplementing a kernel.
- BusyBox: minimal POSIX userspace for the base image.
- systemd-style service layout with a small project init layer.
- Nova Shell: centered launcher, taskbar, window-management concepts, notifications, virtual desktops, and settings.
- Nova package metadata: simple repository/package format for the project.
- Reproducible image scripts: build an initramfs/root filesystem and bootable image.

## Status

This is an active source tree and architectural foundation. The build system checks host dependencies and assembles components; Linux kernel and third-party source archives are intentionally fetched separately instead of vendoring millions of upstream lines.

## Build

See `docs/build.md` and run `./tools/build.sh` from a Linux build host.

## License

Project-original files are MIT licensed unless a file states otherwise. Third-party components retain their upstream licenses.

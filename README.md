# Storage-Optimized Dockur macOS for GitHub Codespaces

This repository is a storage-conscious fork/overlay of [`dockur/macos`](https://github.com/dockur/macos) for running macOS in GitHub Codespaces.

## Current profile

- macOS 15 Sequoia
- 1 vCPU during installation
- 4 GiB RAM
- 40 GiB logical qcow2 disk
- VM disk stored in Docker-managed volume `novaos-macos-data`
- Audio disabled
- Web viewer only on port `8006`
- No automatic VM restart loop

## Why the disk is 40 GiB

macOS checks the **logical capacity** of the VM disk during installation. A sparse qcow2 disk can expose 40 GiB to macOS without immediately allocating 40 GiB on the host.

The VM is deliberately **not** stored in `/workspaces`, because your Codespace exposes `/workspaces` as a 32 GiB filesystem. The Docker-managed volume keeps the rapidly growing guest disk out of that workspace filesystem.

Use:

```bash
bash .devcontainer/storage-status.sh
```

to compare workspace free space, VM-volume free space, and Docker usage.

## First run

Use a fresh Codespace for the Sequoia profile. If an older VM exists in `./macos`, stop the VM first and remove that old directory so it cannot continue consuming workspace storage.

The project does **not** modify Apple's signed installer payloads or fake installer metadata. The optimization is done on the virtualization/storage side: sparse storage, Docker cache cleanup, reduced VM resources, and moving persistent VM data out of `/workspaces`.

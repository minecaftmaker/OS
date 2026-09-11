# Optimized Dockur macOS for GitHub Codespaces

This repository is a storage-conscious fork/overlay of [`dockur/macos`](https://github.com/dockur/macos) for running macOS in GitHub Codespaces.

## What is changed

- macOS Tahoe 26 is selected by default.
- Codespaces is capped for a 32 GB storage target instead of inheriting Dockur's `DISK_SIZE=max` Codespaces setting.
- The VM disk uses sparse `qcow2`, so the virtual capacity is a ceiling rather than an immediately allocated raw file.
- Docker caches and unused images are pruned during Codespace initialization.
- The default VM profile targets 2 vCPUs and 6 GB RAM on the standard 2-core/8 GB Codespaces machine.
- Storage guardrails prevent accidental growth past the project target.
- Upstream source can be synchronized with `scripts/sync-upstream.sh` rather than duplicating macOS installer media in Git.

## Start in Codespaces

1. Create a GitHub Codespace using the `main` branch.
2. Open the forwarded **Web** port for `8006`.
3. Complete the normal Dockur macOS recovery/installation flow.
4. Keep the VM disk below the 24 GB virtual-disk ceiling so the Codespace retains headroom for Docker and the workspace.

## Important

macOS itself is not distributed by this repository. Dockur downloads recovery/install components from Apple's servers. This repository contains the open-source container orchestration/configuration layer and an optimized Codespaces profile.

Tahoe is currently supported by Dockur but its own README notes that macOS 26 can run unusually slowly, so performance is workload- and host-dependent.

Upstream project: https://github.com/dockur/macos

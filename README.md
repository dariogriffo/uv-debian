![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/dariogriffo/uv-debian/total)
![GitHub Downloads (all assets, latest release)](https://img.shields.io/github/downloads/dariogriffo/uv-debian/latest/total)
![GitHub Release](https://img.shields.io/github/v/release/dariogriffo/uv-debian)
![GitHub Release Date](https://img.shields.io/github/release-date/dariogriffo/uv-debian?display_date=published_at)

<h1>
   <p align="center">
     <a href="https://uv.org/"><img src="https://github.com/dariogriffo/uv-debian/blob/main/uv-logo.png" alt="uv Logo" width="128" style="margin-right: 20px"></a>
     <a href="https://www.debian.org/"><img src="https://github.com/dariogriffo/uv-debian/blob/main/debian-logo.png" alt="Debian Logo" width="104" style="margin-left: 20px"></a>
     <br>uv for Debian
   </p>
</h1>
<p align="center">
 An extremely fast Python package and project manager, written in Rust.
</p>

# uv for Debian

This repository contains build scripts to produce the _unofficial_ Debian packages
(.deb) for [uv](https://github.com/astral-sh/uv/) hosted at [deb.griffo.io](https://deb.griffo.io)

Two packages are produced:
- `uv` — the uv binary, plus the [`uvx`](https://docs.astral.sh/uv/guides/tools/)
  tool runner, both installed into `/usr/bin`.
- `uvx` — an `Architecture: all` package that depends on `uv`, so
  `apt install uvx` works. It ships no executable of its own: `uvx` is a small
  trampoline that runs the `uv` binary sitting next to it (it does not search
  `PATH`), so it has to live in the same directory as `uv` and is shipped by the
  `uv` package.

Currently supported Debian distros are:
- Bookworm (v12)
- Trixie (v13)
- Forky (v14)
- Sid (testing)

Thanks to @ranjithrajv

Supported architectures:
- amd64 (x86_64) - All distributions
- arm64 (aarch64) - All distributions
- armel (ARM EABI) - All distributions
- armhf (ARM hard float) - All distributions
- ppc64el (PowerPC 64-bit little endian) - All distributions
- s390x (IBM System z) - All distributions
- riscv64 (RISC-V 64-bit) - Trixie, Forky, Sid only

This is an unofficial community project to provide a package that's easy to
install on Debian. If you're looking for the uv source code, see
[uv](https://github.com/astral-sh/uv/).

## Install/Update

📖 **Step-by-step install guide:** [Debian](https://deb.griffo.io/install-latest-uv-in-debian.html) · [Ubuntu](https://deb.griffo.io/install-latest-uv-in-ubuntu.html)

### The Debian way

> ⚠️ **From 1 October 2026, apt access requires a yearly subscription**
> ([deb.griffo.io](https://deb.griffo.io)). To use this tool for free, download
> the .deb from the [Releases](https://github.com/dariogriffo/uv-debian/releases) page
> and install it manually (see below).

```sh
sudo install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://deb.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc | sudo gpg --dearmor --yes -o /etc/apt/keyrings/deb.griffo.io.gpg
echo "deb [signed-by=/etc/apt/keyrings/deb.griffo.io.gpg] https://deb.griffo.io/apt $(lsb_release -sc 2>/dev/null) main" | sudo tee /etc/apt/sources.list.d/deb.griffo.io.list
sudo apt update
sudo apt install -y uv
```

`uvx` is installed alongside `uv`, so there is nothing else to do to use it:

```sh
uvx pycowsay 'hello world!'
```

### Manual Installation

1. Download the .deb package for your Debian version available on
   the [Releases](https://github.com/dariogriffo/uv-debian/releases) page.
2. Install the downloaded .deb package.

```sh
sudo dpkg -i <filename>.deb
```
## Updating

To update to a new version, just follow any of the installation methods above. There's no need to uninstall the old version; it will be updated correctly.

## Building

### Build for single architecture
```sh
./build.sh <uv_version> <build_version> <architecture>
# Example: ./build.sh 0.8.11 1 arm64
```

### Build for all architectures
```sh
./build.sh <uv_version> <build_version> all
# Example: ./build.sh 0.8.11 1 all
```

## Roadmap

- [x] Produce a .deb package on GitHub Releases
- [x] Set up a debian mirror for easier updates
- [x] Multi-architecture support (amd64, arm64, armel, armhf, ppc64el, s390x)
- [x] Ship `uvx` and make it installable as its own package

## Disclaimer

- This repo is not open for issues related to uv. This repo is only for _unofficial_ Debian packaging.

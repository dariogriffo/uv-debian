![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/dariogriffo/uv-debian/total)
![GitHub Downloads (all assets, latest release)](https://img.shields.io/github/downloads/dariogriffo/uv-debian/latest/total)
![GitHub Release](https://img.shields.io/github/v/release/dariogriffo/uv-debian)
![GitHub Release Date](https://img.shields.io/github/release-date/dariogriffo/uv-debian)

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
(.deb) for [uv](https://github.com/astral-sh/uv/) hosted at [debian.griffo.io](https://debian.griffo.io)

Currently supported Debian distros are:
- Bookworm (v12)
- Trixie (v13)
- Forky (v14)
- Sid (testing)

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

### The Debian way

```sh
curl -sS https://debian.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/debian.griffo.io.gpg
echo "deb https://debian.griffo.io//apt $(lsb_release -sc 2>/dev/null) main" | sudo tee /etc/apt/sources.list.d/debian.griffo.io.list
sudo apt install -y uv
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

## Disclaimer

- This repo is not open for issues related to uv. This repo is only for _unofficial_ Debian packaging.

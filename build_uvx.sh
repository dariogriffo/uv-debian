#!/bin/bash
set -euo pipefail

uv_VERSION=${1:-}
BUILD_VERSION=${2:-}

if [ -z "$uv_VERSION" ] || [ -z "$BUILD_VERSION" ]; then
    echo "Usage: $0 <uv_version> <build_version>"
    echo "Example: $0 0.12.5 1"
    exit 1
fi

# uvx is Architecture: all -- it carries no binary, so it is built once per
# distribution rather than once per architecture (see Dockerfile.uvx).
build_uvx_package() {
    local dist=$1
    local suffix=$2
    local version="${uv_VERSION}-${BUILD_VERSION}~${dist}"
    local deb_name="uvx_${version}_all${suffix}.deb"

    echo "  Building $deb_name"

    if ! docker build . -f Dockerfile.uvx -t "uvx-$dist${suffix}" \
        --build-arg DIST="$dist" \
        --build-arg uv_VERSION="$uv_VERSION" \
        --build-arg BUILD_VERSION="$BUILD_VERSION" \
        --build-arg FULL_VERSION="$version" \
        --build-arg DEB_NAME="$deb_name"; then
        echo "❌ Failed to build Docker image for uvx on $dist"
        return 1
    fi

    id="$(docker create "uvx-$dist${suffix}")"
    if ! docker cp "$id:/$deb_name" - > "./$deb_name"; then
        echo "❌ Failed to extract .deb package for uvx on $dist"
        return 1
    fi

    if ! tar -xf "./$deb_name"; then
        echo "❌ Failed to extract .deb contents for uvx on $dist"
        return 1
    fi

    return 0
}

echo "🚀 Building uvx $uv_VERSION-$BUILD_VERSION (Architecture: all)..."
echo ""

echo "Building Debian uvx packages..."
DEBIAN_DISTS=("bookworm" "trixie" "forky" "sid")
for dist in "${DEBIAN_DISTS[@]}"; do
    build_uvx_package "$dist" ""
done

echo ""
echo "Building Ubuntu uvx packages..."
UBUNTU_DISTS=("jammy" "noble" "questing" "resolute")
for dist in "${UBUNTU_DISTS[@]}"; do
    build_uvx_package "$dist" "_ubu"
done

echo ""
echo "✅ uvx packages built successfully!"
ls -la uvx_*.deb

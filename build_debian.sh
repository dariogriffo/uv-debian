uv_VERSION=$1
BUILD_VERSION=$2
ARCH=${3:-amd64}  # Default to amd64 if no architecture specified

if [ -z "$uv_VERSION" ] || [ -z "$BUILD_VERSION" ]; then
    echo "Usage: $0 <uv_version> <build_version> [architecture]"
    echo "Example: $0 0.8.11 1 arm64"
    echo "Example: $0 0.8.11 1 all    # Build for all architectures"
    echo "Supported architectures: amd64, arm64, armel, armhf, ppc64el, s390x, riscv64, i386, all"
    exit 1
fi

# Function to map Debian architecture to uv release name
get_uv_release() {
    local arch=$1
    case "$arch" in
        "amd64")
            echo "uv-x86_64-unknown-linux-musl"
            ;;
        "arm64")
            echo "uv-aarch64-unknown-linux-musl"
            ;;
        "armel")
            echo "uv-arm-unknown-linux-musleabihf"
            ;;
        "armhf")
            echo "uv-armv7-unknown-linux-musleabihf"
            ;;
        "ppc64el")
            echo "uv-powerpc64le-unknown-linux-gnu"
            ;;
        "s390x")
            echo "uv-s390x-unknown-linux-gnu"
            ;;
        "riscv64")
            echo "uv-riscv64gc-unknown-linux-gnu"
            ;;
        "i386")
            echo "uv-i686-unknown-linux-musl"
            ;;
        *)
            echo ""
            ;;
    esac
}

# Function to build for a specific architecture
build_architecture() {
    local build_arch=$1
    local uv_release
    
    uv_release=$(get_uv_release "$build_arch")
    if [ -z "$uv_release" ]; then
        echo "❌ Unsupported architecture: $build_arch"
        echo "Supported architectures: amd64, arm64, armel, armhf, ppc64el, s390x, riscv64, i386"
        return 1
    fi
    
    echo "Building for architecture: $build_arch using $uv_release"
    
    # Clean up any previous builds for this architecture
    rm -rf "$uv_release" || true
    rm -f "${uv_release}.tar.gz" || true
    
    # Download and extract uv binary for this architecture
    if ! wget "https://github.com/astral-sh/uv/releases/download/${uv_VERSION}/${uv_release}.tar.gz"; then
        echo "❌ Failed to download uv binary for $build_arch"
        return 1
    fi
    
    if ! tar -xf "${uv_release}.tar.gz"; then
        echo "❌ Failed to extract uv binary for $build_arch"
        return 1
    fi
    
    rm -f "${uv_release}.tar.gz"
    
    # One package for every suite: upstream ships one binary per architecture,
    # so only the old ~<suite> version suffix ever differed. The fixed ~griffo
    # keeps it below the distro's own build of the same version.
    FULL_VERSION="$uv_VERSION-${BUILD_VERSION}~griffo_${build_arch}"
    echo "  Building $FULL_VERSION"
    
    if ! docker build . -t "uv-$build_arch" \
        --build-arg uv_VERSION="$uv_VERSION" \
        --build-arg BUILD_VERSION="$BUILD_VERSION" \
        --build-arg FULL_VERSION="$FULL_VERSION" \
        --build-arg ARCH="$build_arch" \
        --build-arg UV_RELEASE="$uv_release"; then
        echo "❌ Failed to build Docker image for $build_arch"
        return 1
    fi
    
    id="$(docker create "uv-$build_arch")"
    if ! docker cp "$id:/uv_$FULL_VERSION.deb" - > "./uv_$FULL_VERSION.deb"; then
        echo "❌ Failed to extract .deb package for $build_arch"
        return 1
    fi
    
    if ! tar -xf "./uv_$FULL_VERSION.deb"; then
        echo "❌ Failed to extract .deb contents for $build_arch"
        return 1
    fi
    
    # Clean up extracted directory
    rm -rf "$uv_release" || true
    
    echo "✅ Successfully built for $build_arch"
    return 0
}

# Main build logic
if [ "$ARCH" = "all" ]; then
    echo "🚀 Building uv $uv_VERSION-$BUILD_VERSION for all supported architectures..."
    echo ""
    
    # All supported architectures
    ARCHITECTURES=("amd64" "arm64" "armel" "armhf" "ppc64el" "s390x" "riscv64" "i386")
    
    for build_arch in "${ARCHITECTURES[@]}"; do
        echo "==========================================="
        echo "Building for architecture: $build_arch"
        echo "==========================================="
        
        if ! build_architecture "$build_arch"; then
            echo "❌ Failed to build for $build_arch"
            exit 1
        fi
        
        echo ""
    done
    
    echo "🎉 All architectures built successfully!"
    echo "Generated packages:"
    ls -la uv_*.deb
else
    # Build for single architecture
    if ! build_architecture "$ARCH"; then
        exit 1
    fi
fi
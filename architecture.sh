#!/usr/bin/env bash

# This script tries to guess your system's architecture.
# Rhasspy expects one of the following architecture names:
# - amd64 (Intel/AMD)
# - armhf (Raspberry Pi 2-3 B)
# - aarch64 (Raspberry Pi 3B+, 4)
# - armv6l (Raspberry Pi 1, Zero, Zero W)

if [[ ! -z "$1" ]]; then
    cpu_arch="$1"
else
    cpu_arch="$(uname --m)"
fi

# Try lookup table first
declare -A known_archs
known_archs=(['x86_64']='amd64' ['arm32v7']='armhf' ['armv7l']='armhf' ['arm64v8']='aarch64' ['armv6l']='armv6l')

guess_arch="${known_archs[${cpu_arch}]}"
if [[ -z "${guess_arch}" ]]; then
    # Try using Debian command
    if [[ -n "$(command -v dpkg-architecture)" ]]; then
        guess_arch="$(dpkg-architecture | grep DEB_BUILD_ARCH= | sed 's/[^=]\+=//')"
    fi

    if [[ -z "${guess_arch}" ]]; then
        # Fall back to CPU architecture
        cpu_arch="${guess_arch}"
    fi
fi

echo "${guess_arch}"

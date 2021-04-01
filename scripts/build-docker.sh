#!/usr/bin/env bash
set -e

# Directory of *this* script
this_dir="$( cd "$( dirname "$0" )" && pwd )"
src_dir="$(realpath "${this_dir}/..")"

download="${src_dir}/download"
mkdir -p "${download}"

version="$(cat "${src_dir}/VERSION")"

# -----------------------------------------------------------------------------

: "${PLATFORMS=linux/amd64,linux/arm/v7,linux/arm64,linux/arm/v6}"
: "${DOCKER_REGISTRY=docker.io}"

DOCKERFILE="${src_dir}/Dockerfile"

if [[ -n "${NOBUILDX}" ]]; then
    DOCKERFILE="${DOCKERFILE}.nobuildx"
fi

if [[ -n "${PROXY}" ]]; then
    if [[ -z "${PROXY_HOST}" ]]; then
        export PROXY_HOST="$(hostname -I | awk '{print $1}')"
    fi

    : "${APT_PROXY_HOST=${PROXY_HOST}}"
    : "${APT_PROXY_PORT=3142}"
    : "${PYPI_PROXY_HOST=${PROXY_HOST}}"
    : "${PYPI_PROXY_PORT=4000}"

    if [[ -z "NO_APT_PROXY" ]]; then
        export APT_PROXY='1'
        export APT_PROXY_HOST
        export APT_PROXY_PORT
        echo "APT proxy: ${APT_PROXY_HOST}:${APT_PROXY_PORT}"
    fi

    if [[ -z "NO_PYPI_PROXY" ]]; then
        export PYPI_PROXY='1'
        export PYPI_PROXY_HOST
        export PYPI_PROXY_PORT
        echo "PyPI proxy: ${PYPI_PROXY_HOST}:${PYPI_PROXY_PORT}"
    fi

    # Use temporary file instead
    temp_dockerfile="$(mktemp -p "${src_dir}")"
    function cleanup {
        rm -f "${temp_dockerfile}"
    }

    trap cleanup EXIT

    # Run through pre-processor to replace variables
    "${src_dir}/docker/preprocess.sh" < "${DOCKERFILE}" > "${temp_dockerfile}"
    DOCKERFILE="${temp_dockerfile}"
fi

# -----------------------------------------------------------------------------

# Determine docker tags
tags=()

# Latest version
if [[ -z "NO_DOCKER_LATEST" ]]; then
    tags+=(--tag "${DOCKER_REGISTRY}/rhasspy/rhasspy:latest")
fi

# Specific version
tags+=(--tag "${DOCKER_REGISTRY}/rhasspy/rhasspy:${version}")

# -----------------------------------------------------------------------------

if [[ -n "${NOBUILDX}" ]]; then
    # Don't use docker buildx (single platform)

    if [[ -z "${TARGETARCH}" ]]; then
        # Guess architecture
        cpu_arch="$(uname -m)"
        case "${cpu_arch}" in
            armv6l)
                export TARGETARCH=arm
                export TARGETVARIANT=v6
                ;;

            armv7l)
                export TARGETARCH=arm
                export TARGETVARIANT=v7
                ;;

            aarch64|arm64v8)
                export TARGETARCH=arm64
                export TARGETVARIANT=''
                ;;

            *)
                # Assume x86_64
                export TARGETARCH=amd64
                export TARGETVARIANT=''
                ;;
        esac

        echo "Guessed architecture: ${TARGETARCH}${TARGETVARIANT}"
    fi

    docker build \
           "${src_dir}" \
           -f "${DOCKERFILE}" \
           --build-arg "TARGETARCH=${TARGETARCH}" \
           --build-arg "TARGETVARIANT=${TARGETVARIANT}" \
           "${tags[@]}" \
           "$@"
else
    # Use docker buildx (multi-platform)
    docker buildx build \
           "${src_dir}" \
           -f "${DOCKERFILE}" \
           "--platform=${PLATFORMS}" \
           "${tags[@]}" \
           --push \
           "$@"
fi

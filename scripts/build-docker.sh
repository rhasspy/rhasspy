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

if [[ -n "${PROXY}" ]]; then
    export PROXY_IP="$(hostname -I | awk '{print $1}')"
    export PROXY_PORT=3142
    export PROXY="${PROXY_IP}:${PROXY_PORT}"
    export PYPI_PORT=4000
    export PYPI="${PROXY_IP}:${PYPI_PORT}"
    export PYPI_HOST="${PROXY_IP}"

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

docker buildx build \
        "${src_dir}" \
        -f "${DOCKERFILE}" \
        "--platform=${PLATFORMS}" \
        --build-arg "DOCKER_REGISTRY=${DOCKER_REGISTRY}" \
        --tag "${DOCKER_REGISTRY}/rhasspy/rhasspy:latest" \
        --tag "${DOCKER_REGISTRY}/rhasspy/rhasspy:${version}" \
        --push \
        "$@"

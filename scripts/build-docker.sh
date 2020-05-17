#!/usr/bin/env bash
set -e

# Directory of *this* script
this_dir="$( cd "$( dirname "$0" )" && pwd )"
src_dir="$(realpath "${this_dir}/..")"

version="$(cat "${src_dir}/VERSION")"

# -----------------------------------------------------------------------------

: "${PLATFORMS=linux/amd64,linux/arm/v7,linux/arm64,linux/arm/v6}"

: "${DOCKER_REGISTRY=docker.io}"

docker buildx build \
        "${src_dir}" \
        "--platform=${PLATFORMS}" \
        --build-arg "DOCKER_REGISTRY=${DOCKER_REGISTRY}" \
        --tag "${DOCKER_REGISTRY}/rhasspy/rhasspy:${version}" \
        --push

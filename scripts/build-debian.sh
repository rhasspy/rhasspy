#!/usr/bin/env bash
set -e

if [[ -z "$1" ]]; then
    echo "Usage: build-debian dist/ [target] [target]"
    exit 1
fi

dist_dir="$(realpath "$1")"
mkdir -p "${dist_dir}"
shift

# Directory of *this* script
this_dir="$( cd "$( dirname "$0" )" && pwd )"
src_dir="$(realpath "${this_dir}/..")"

version="$(cat "${src_dir}/VERSION")"

# -----------------------------------------------------------------------------

if [[ -z "${NOBUILDX}" ]]; then
    if [[ -z "$1" ]]; then
        platforms=('linux/amd64' 'linux/arm/v7' 'linux/arm64')
    else
        platforms=("$@")
    fi

    function join { local IFS="$1"; shift; echo "$*"; }
    platform_str=$(join ',' ${platforms[@]})
else
    if [[ -z "$1" ]]; then
        echo "Platform is required with NOBUILDX"
        exit 1
    fi

    platforms=("$@")
fi

# ------------------------------------------------------------------------------

: "${DOCKER_REGISTRY=docker.io}"

echo "Building..."

if [[ -z "${NOBUILDX}" ]]; then
    docker buildx build \
           "${src_dir}" \
           -f "${src_dir}/Dockerfile.debian" \
           "--platform=${platform_str}" \
           --build-arg "DOCKER_REGISTRY=${DOCKER_REGISTRY}" \
           --tag "${DOCKER_REGISTRY}/rhasspy-debian" \
           --push
else
    docker build \
           "${src_dir}"  \
           -f "${src_dir}/Dockerfile.debian" \
           --build-arg "DOCKER_REGISTRY=${DOCKER_REGISTRY}" \
           -t "${DOCKER_REGISTRY}/rhasspy-debian"
fi

# ------------------------------------------------------------------------------

declare -A platform_to_debian
platform_to_debian=(['linux/amd64']='amd64' ['linux/arm/v6']='armel' ['linux/arm/v7']='armhf' ['linux/arm64']='arm64')

for platform in "${platforms[@]}"; do
    echo "Packaging..."
    debian_arch="${platform_to_debian["${platform}"]}"
    package_name="rhasspy_${version}_${debian_arch}"

    if [[ -z "${NOBUILDX}" ]]; then
        docker pull \
               --platform "${platform}" \
               "${DOCKER_REGISTRY}/rhasspy-debian"

        docker run \
               --platform "${platform}" \
               --rm -i --entrypoint /bin/cat \
               "${DOCKER_REGISTRY}/rhasspy-debian" \
               "/build/${package_name}.deb" > "${dist_dir}/${package_name}.deb"
    else
        docker run \
               --rm -i --entrypoint /bin/cat \
               "${DOCKER_REGISTRY}/rhasspy-debian" \
               "/build/${package_name}.deb" > "${dist_dir}/${package_name}.deb"
    fi

    echo "Wrote ${dist_dir}/${package_name}.deb"
done

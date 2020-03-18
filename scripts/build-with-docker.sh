#!/usr/bin/env bash
set -e
this_dir="$( cd "$( dirname "$0" )" && pwd )"
src_dir="$(realpath "${this_dir}/..")"
version="$(cat VERSION)"

if [[ -z "${version}" ]]; then
    echo "VERSION missing"
    exit 1
fi

if [[ -z "$(command -v qemu-arm-static)" ]]; then
    echo "Need to install qemu-user-static"
    sudo apt-get update
    sudo apt-get install qemu-arm-static
fi

# Copy qemu for ARM architectures
mkdir -p "${src_dir}/etc"
for qemu_file in qemu-arm-static qemu-aarch64-static; do
    dest_file="${src_dir}/etc/${qemu_file}"

    if [[ ! -s "${dest_file}" ]]; then
        cp "$(which ${qemu_file})" "${dest_file}"
    fi
done

# Do Docker builds
# docker_archs=('amd64' 'arm32v7' 'arm64v8' 'arm32v6')
docker_archs=('amd64' 'arm32v7' 'arm64v8')
if [[ ! -z "$1" ]]; then
    docker_archs=("$@")
fi

declare -A friendly_archs
friendly_archs=(['amd64']='amd64' ['arm32v7']='armhf' ['arm64v8']='aarch64' ['arm32v6']='arm32v6')
declare -A cpu_archs
cpu_archs=(['amd64']='x86_64' ['arm32v7']='armv7l' ['arm64v8']='aarch64' ['arm32v6']='armv6l')

for docker_arch in "${docker_archs[@]}"; do
    friendly_arch="${friendly_archs[${docker_arch}]}"
    cpu_arch="${cpu_archs[${docker_arch}]}"
    echo "${docker_arch} ${friendly_arch} ${cpu_arch}"

    if [[ -z "${friendly_arch}" ]]; then
       exit 1
    fi

    docker_tag="rhasspy/rhasspy:${version}-${friendly_arch}"
    case "${friendly_arch}" in
        'arm32v6')
            # Raspbian build
            docker build "${src_dir}" \
                   --build-arg "BUILD_ARCH=${docker_arch}" \
                   --build-arg "FRIENDLY_ARCH=${friendly_arch}" \
                   --build-arg "CPU_ARCH=${cpu_arch}" \
                   -f Dockerfile.source.alsa.pizero \
                   -t "${docker_tag}"
        ;;

        'aarch64')
            # Custom arm64 build
            docker build "${src_dir}" \
                   --build-arg "BUILD_ARCH=${docker_arch}" \
                   --build-arg "FRIENDLY_ARCH=${friendly_arch}" \
                   --build-arg "CPU_ARCH=${cpu_arch}" \
                   -f Dockerfile.source.alsa.aarch64 \
                   -t "${docker_tag}"
        ;;

        *)
            # Default Debian build
            docker build "${src_dir}" \
                   --build-arg "BUILD_ARCH=${docker_arch}" \
                   --build-arg "FRIENDLY_ARCH=${friendly_arch}" \
                   --build-arg "CPU_ARCH=${cpu_arch}" \
                   -f Dockerfile.source.alsa \
                   -t "${docker_tag}"
    esac
done

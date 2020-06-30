#!/usr/bin/env bash
for docker_arch in amd64 armv7 arm64 armv6; do
    wget "https://github.com/synesthesiam/prebuilt-apps/releases/download/v1.0/julius-4.5_${docker_arch}.tar.gz"

    wget "https://github.com/synesthesiam/prebuilt-apps/releases/download/v1.0/kenlm-20200308_${docker_arch}.tar.gz"
    wget "https://github.com/synesthesiam/prebuilt-apps/releases/download/v1.0/nanotts-20200520_${docker_arch}.tar.gz"
    wget "https://github.com/synesthesiam/prebuilt-apps/releases/download/v1.0/opengrm-1.3.4_${docker_arch}.tar.gz"
    wget "https://github.com/synesthesiam/prebuilt-apps/releases/download/v1.0/phonetisaurus-2019_${docker_arch}.tar.gz"

    if [[ "${docker_arch}" != 'armv6' ]]; then
        wget "https://github.com/synesthesiam/prebuilt-apps/releases/download/v1.0/kaldi-2020_${docker_arch}.tar.gz"
    fi
done

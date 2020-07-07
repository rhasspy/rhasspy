#!/usr/bin/env bash
set -e

# Directory of *this* script
this_dir="$( cd "$( dirname "$0" )" && pwd )"
src_dir="$(realpath "${this_dir}/..")"

download="${src_dir}/download"
mkdir -p "${download}"

# -----------------------------------------------------------------------------

for docker_arch in amd64 armv7 arm64 armv6; do
    julius="julius-4.5_${docker_arch}.tar.gz"
    if [[ ! -s "${download}/${julius}" ]]; then
        wget -O "${download}/${julius}" "https://github.com/synesthesiam/prebuilt-apps/releases/download/v1.0/${julius}"
    fi

    kenlm="kenlm-20200308_${docker_arch}.tar.gz"
    if [[ ! -s "${download}/${kenlm}" ]]; then
        wget -O "${download}/${kenlm}" "https://github.com/synesthesiam/prebuilt-apps/releases/download/v1.0/${kenlm}"
    fi

    nanotts="nanotts-20200520_${docker_arch}.tar.gz"
    if [[ ! -s "${download}/${nanotts}" ]]; then
        wget -O "${download}/${nanotts}" "https://github.com/synesthesiam/prebuilt-apps/releases/download/v1.0/${nanotts}"
    fi

    opengrm="opengrm-1.3.4_${docker_arch}.tar.gz"
    if [[ ! -s "${download}/${opengrm}" ]]; then
        wget -O "${download}/${opengrm}" "https://github.com/synesthesiam/prebuilt-apps/releases/download/v1.0/${opengrm}"
    fi

    phonetisaurus="phonetisaurus-2019_${docker_arch}.tar.gz"
    if [[ ! -s "${download}/${phonetisaurus}" ]]; then
        wget -O "${download}/${phonetisaurus}" "https://github.com/synesthesiam/prebuilt-apps/releases/download/v1.0/${phonetisaurus}"
    fi

    snowboy='snowboy-1.3.0.tar.gz'
    if [[ ! -s "${download}/${snowboy}" ]]; then
        wget -O "${download}/${snowboy}" 'https://github.com/Kitt-AI/snowboy/archive/v1.3.0.tar.gz'
    fi

    pocketsphinx='pocketsphinx-python.tar.gz'
    if [[ ! -s "${download}/${pocketsphinx}" ]]; then
        wget -O "${download}/${pocketsphinx}" 'https://github.com/synesthesiam/pocketsphinx-python/releases/download/v1.0/pocketsphinx-python.tar.gz'
    fi

    # Skip Pi Zero
    if [[ "${docker_arch}" != 'armv6' ]]; then
        kaldi="kaldi-2020_${docker_arch}.tar.gz"
        if [[ ! -s "${download}/${kaldi}" ]]; then
            wget -O "${download}/${kaldi}" "https://github.com/synesthesiam/prebuilt-apps/releases/download/v1.0/${kaldi}"
        fi

        case "${docker_arch}" in
            amd64)
                precise_arch='x86_64'
                deepspeech_arch='amd64'
                ;;
            armv7)
                precise_arch='armv7l'
                deepspeech_arch='rpi3'
                ;;
            arm64)
                precise_arch='aarch64'
                deepspeech_arch='arm64'
                ;;
            *)
                echo "Invalid precise arch: ${docker_arch}"
                exit 1
                ;;
        esac

        # Mycroft Precise
        precise="precise-engine_0.3.0_${docker_arch}.tar.gz"
        if [[ ! -s "${download}/${precise}" ]]; then
            wget -O "${download}/${precise}" "https://github.com/MycroftAI/mycroft-precise/releases/download/v0.3.0/precise-engine_0.3.0_${precise_arch}.tar.gz"
        fi

        # DeepSpeech
        deepspeech="native_client.${docker_arch}.cpu.linux.0.6.1.tar.xz"
        if [[ ! -s "${download}/${deepspeech}" ]]; then
            wget -O "${download}/${deepspeech}" "https://github.com/mozilla/DeepSpeech/releases/download/v0.6.1/native_client.${deepspeech_arch}.cpu.linux.tar.xz"
        fi
    fi
done

#!/usr/bin/env bash
set -e

# Directory of *this* script
this_dir="$( cd "$( dirname "$0" )" && pwd )"
src_dir="$(realpath "${this_dir}/..")"

download="${src_dir}/download"
cpu_arch="$(uname -m)"
target_arch="$("${src_dir}/architecture.sh")"

# -----------------------------------------------------------------------------

mkdir -p "${download}"

# Snowboy
snowboy_file="${download}/snowboy-1.3.0.tar.gz"
if [[ ! -s "${snowboy_file}" ]]; then
    echo "Downloading snowboy (${snowboy_file})"
    curl -sSfL -o "${snowboy_file}" 'https://github.com/Kitt-AI/snowboy/archive/v1.3.0.tar.gz'
fi

# Pocketsphinx
pocketsphinx_file="${download}/pocketsphinx-python.tar.gz"
if [[ ! -s "${pocketsphinx_file}" ]]; then
    echo "Downloading pocketsphinx (${pocketsphinx_file})"
    curl -sSfL -o "${pocketsphinx_file}" 'https://github.com/synesthesiam/pocketsphinx-python/releases/download/v1.0/pocketsphinx-python.tar.gz'
fi

# Opengrm
declare -A opengrm_archs
opengrm_archs=(['x86_64']='amd64' ['armv7l']='armhf' ['aarch64']='aarch64' ['armv6l']='armv6l')

opengrm_arch="${opengrm_archs[${cpu_arch}]}"
opengrm_file="${download}/opengrm-1.3.4-${target_arch}.tar.gz"
if [ -n "${opengrm_arch}" ] && [ ! -s "${opengrm_file}" ]; then
    echo "Downloading opengrm (${opengrm_file})"
    curl -sSfL -o "${opengrm_file}" "https://github.com/synesthesiam/docker-opengrm/releases/download/v1.3.4/opengrm-1.3.4-${opengrm_arch}.tar.gz"
fi

# Phonetisaurus
declare -A phonetisaurus_archs
phonetisaurus_archs=(['x86_64']='amd64' ['armv7l']='armhf' ['aarch64']='aarch64' ['armv6l']='armv6l')

phonetisaurus_arch="${phonetisaurus_archs[${cpu_arch}]}"
phonetisaurus_file="${download}/phonetisaurus-2019-${target_arch}.tar.gz"
if [ -n "${phonetisaurus_arch}" ] && [ ! -s "${phonetisaurus_file}" ]; then
    echo "Downloading phonetisaurus (${phonetisaurus_file})"
    curl -sSfL -o "${phonetisaurus_file}" "https://github.com/synesthesiam/docker-phonetisaurus/releases/download/v2019.1/phonetisaurus-2019-${phonetisaurus_arch}.tar.gz"
fi

# Kaldi
declare -A kaldi_archs
kaldi_archs=(['x86_64']='amd64' ['armv7l']='armhf' ['aarch64']='aarch64')

kaldi_arch="${kaldi_archs[${cpu_arch}]}"
kaldi_file="${download}/kaldi-2020-${target_arch}.tar.gz"
if [ -n "${kaldi_arch}" ] && [ ! -s "${kaldi_file}" ]; then
    echo "Downloading kaldi (${kaldi_file})"
    curl -sSfL -o "${kaldi_file}" "https://github.com/synesthesiam/docker-kaldi/releases/download/v2020.1/kaldi-2020-${kaldi_arch}.tar.gz"
fi

# Mycroft Precise
declare -A precise_archs
precise_archs=(['x86_64']='x86_64' ['armv7l']='armv7l' ['aarch64']='aarch64')

precise_arch="${precise_archs[${cpu_arch}]}"
precise_file="${download}/precise-engine_0.3.0_${target_arch}.tar.gz"
if [ -n "${precise_arch}" ] && [ ! -s "${precise_file}" ]; then
    echo "Downloading Mycroft Precise (${precise_file})"
    curl -sSfL -o "${precise_file}" "https://github.com/MycroftAI/mycroft-precise/releases/download/v0.3.0/precise-engine_0.3.0_${precise_arch}.tar.gz"
fi

# Mozilla DeepSpeech Native Client
declare -A deepspeech_archs
deepspeech_archs=(['x86_64']='amd64' ['armv7l']='rpi3' ['aarch64']='rpi3')

deepspeech_arch="${deepspeech_archs[${cpu_arch}]}"

# TODO: Support other platforms besides Linux
deepspeech_file="${download}/native_client.${target_arch}.cpu.linux.0.6.1.tar.xz"
if [ -n "${deepspeech_arch}" ] && [ ! -s "${deepspeech_file}" ]; then
    echo "Downloading DeepSpeech native client (${deepspeech_file})"
    curl -sSfL -o "${deepspeech_file}" "https://github.com/mozilla/DeepSpeech/releases/download/v0.6.1/native_client.${deepspeech_arch}.cpu.linux.tar.xz"
fi

# KenLM
declare -A kenlm_archs
kenlm_archs=(['x86_64']='amd64' ['armv7l']='armv7' ['aarch64']='arm64')

kenlm_arch="${kenlm_archs[${cpu_arch}]}"
kenlm_file="${download}/kenlm-20200308_${target_arch}.tar.gz"
if [ -n "${kenlm_arch}" ] && [ ! -s "${kenlm_file}" ]; then
    echo "Downloading KenLM (${kenlm_file})"
    curl -sSfL -o "${kenlm_file}" "https://github.com/synesthesiam/docker-kenlm/releases/download/v2020.03.28/kenlm-20200308_${kenlm_arch}.tar.gz"
fi

# -----------------------------------------------------------------------------

echo "OK"

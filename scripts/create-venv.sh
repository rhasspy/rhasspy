#!/usr/bin/env bash
set -e

if [[ -z "${PIP_INSTALL}" ]]; then
    PIP_INSTALL='install --upgrade'
fi

# Directory of *this* script
this_dir="$( cd "$( dirname "$0" )" && pwd )"
src_dir="$(realpath "${this_dir}/..")"

python_name="$(basename "${src_dir}" | sed -e 's/-//' | sed -e 's/-/_/g')"
cpu_arch="$(uname -m)"

# -----------------------------------------------------------------------------

architecture="$1"
if [[ -z "${architecture}" ]]; then
    architecture="$(bash "${src_dir}/architecture.sh")"
fi

venv="${src_dir}/.venv"
download="${src_dir}/download"

# -----------------------------------------------------------------------------

if [[ ! -d "${venv}" ]]; then
    # Create virtual environment
    echo "Creating virtual environment at ${venv}"
    python3 -m venv "${venv}"
fi

source "${venv}/bin/activate"

# Directory where pre-compiled binaries will be installed
mkdir -p "${venv}/tools"

# Install Python dependencies
echo 'Installing Python dependencies'
pip3 ${PIP_INSTALL} pip
pip3 ${PIP_INSTALL} wheel setuptools

# Snowboy
if [[ -s "${download}/snowboy-1.3.0.tar.gz" ]]; then
    # Only install if not already present in venv
    if [[ -z "$(pip3 freeze | grep '^snowboy==1.2.0b1$')" ]]; then
        echo 'Installing snowboy'
        pip3 ${PIP_INSTALL} "${download}/snowboy-1.3.0.tar.gz"
    fi
fi

# Pocketsphinx
if [[ -s "${download}/pocketsphinx-python.tar.gz" ]]; then
    echo 'Installing pocketsphinx'
    # Only install if not already present in venv
    if [[ -z "$(pip3 freeze | grep '^pocketsphinx==0.1.15$')" ]]; then
        pip3 ${PIP_INSTALL} "${download}/pocketsphinx-python.tar.gz"
    fi
fi

# Check for opengrm
if [[ -n "$(command -v ngramcount)" ]]; then
    echo 'Missing libngram-tools'
    echo 'Run: apt-get install libngram-tools'
fi

# MITLM
# if [[ -s "${download}/mitlm-0.4.2-${architecture}.tar.gz" ]]; then
#     echo 'Installing MITLM'
#     "${src_dir}/scripts/install-mitlm.sh" "${download}/mitlm-0.4.2-${architecture}.tar.gz" "${venv}/tools"
# fi

# Phonetisaurus
if [[ -s "${download}/phonetisaurus-2019-${architecture}.tar.gz" ]]; then
    echo 'Installing Phonetisaurus'
    "${src_dir}/scripts/install-phonetisaurus.sh" "${download}/phonetisaurus-2019-${architecture}.tar.gz" "${venv}/tools"
fi

# Kaldi
if [[ -s "${download}/kaldi-2020-${architecture}.tar.gz" ]]; then
    echo 'Installing Kaldi'
    "${src_dir}/scripts/install-kaldi.sh" "${download}/kaldi-2020-${architecture}.tar.gz" "${venv}/tools"
fi

# Mycroft Precise
if [[ -s "${download}/precise-engine_0.3.0_${cpu_arch}.tar.gz" ]]; then
    echo 'Installing Mycroft Precise'
    "${src_dir}/scripts/install-precise.sh" "${download}/precise-engine_0.3.0_${cpu_arch}.tar.gz" "${venv}/tools"
fi

echo 'Installing requirements'
pip3 ${PIP_INSTALL} -r requirements.txt

# Optional development requirements
echo 'Installing development requirements'
pip3 ${PIP_INSTALL} -r requirements_dev.txt || \
    echo "Failed to install development requirements"

# -----------------------------------------------------------------------------

echo "OK"

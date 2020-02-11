#!/usr/bin/env bash
set -e

if [[ -z "${PIP_INSTALL}" ]]; then
    PIP_INSTALL='install'
fi

# Directory of *this* script
this_dir="$( cd "$( dirname "$0" )" && pwd )"
src_dir="$(realpath "${this_dir}/..")"

python_name="$(basename "${src_dir}" | sed -e 's/-//' | sed -e 's/-/_/g')"

# -----------------------------------------------------------------------------

architecture="$1"
if [[ -z "${architecture}" ]]; then
    architecture="$(bash "${src_dir}/architecture.sh")"
fi

venv="${src_dir}/.venv"
download="${src_dir}/download"

# -----------------------------------------------------------------------------

# Create virtual environment
echo "Creating virtual environment at ${venv}"
rm -rf "${venv}"
python3 -m venv "${venv}"
source "${venv}/bin/activate"

# Install Python dependencies
echo "Installing Python dependencies"
pip3 ${PIP_INSTALL} --upgrade pip
pip3 ${PIP_INSTALL} wheel setuptools
pip3 ${PIP_INSTALL} "${download}/snowboy-1.3.0.tar.gz"

pip3 ${PIP_INSTALL} -r requirements.txt

# Optional development requirements
pip3 ${PIP_INSTALL} -r requirements_dev.txt || \
    echo "Failed to install development requirements"

# -----------------------------------------------------------------------------

echo "OK"

#!/usr/bin/env bash
set -e

architecture="$1"
version="$2"

if [[ -z "${version}" ]];
then
    echo "Usage: build-pyinstaller.sh architecture version"
    exit 1
fi

# Directory of *this* script
this_dir="$( cd "$( dirname "$0" )" && pwd )"
src_dir="$(realpath "${this_dir}/..")"

package_name="$(basename "${src_dir}")"
python_name="$(basename "${src_dir}" | sed -e 's/-//' | sed -e 's/-/_/g')"

venv="${src_dir}/.venv"
if [[ -d "${venv}" ]]; then
    echo "Using virtual environment at ${venv}"
    source "${venv}/bin/activate"
fi

# -----------------------------------------------------------------------------

dist="${src_dir}/dist"
mkdir -p dist

pyinstaller_dist="${src_dir}/pyinstaller/dist"

# Create PyInstaller artifacts
pyinstaller \
    -y \
    --workpath "${src_dir}/pyinstaller/build" \
    --distpath "${pyinstaller_dist}" \
    "${python_name}.spec"

# Delete unnecessary directories
rm -rf \
   "${pyinstaller_dist}/${python_name}/share/" \
   "${pyinstaller_dist}${python_name}/notebook/"

# Tar up binary distribution
tar -C "${pyinstaller_dist}" \
    -czf \
    "${dist}/${package_name}_${version}_${architecture}.tar.gz" \
    "${python_name}/"

# -----------------------------------------------------------------------------

echo "OK"

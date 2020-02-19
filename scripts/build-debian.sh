#!/usr/bin/env bash
set -e

architecture="$1"
version="$2"

if [[ -z "${version}" ]];
then
    echo "Usage: build-debian.sh architecture version"
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

# Create PyInstaller artifacts
pyinstaller \
    -y \
    --workpath "${src_dir}/pyinstaller/build" \
    --distpath "${src_dir}/pyinstaller/dist" \
    "${python_name}.spec"

# Tar up binary distribution
tar -C "${src_dir}/pyinstaller/dist" \
    -czf \
    "${dist}/${package_name}_${version}_${architecture}.tar.gz" \
    "${python_name}/"

# Create Debian package
debian_package="${package_name}_${version}_${architecture}"
debian="${src_dir}/debian"
debian_dir="${debian}/${debian_package}"

rm -rf "${debian_dir}"
mkdir -p "${debian_dir}/DEBIAN" "${debian_dir}/usr/bin" "${debian_dir}/usr/lib"

# Generate control file
cat "${debian}/DEBIAN/control" | \
    version="${version}" architecture="${architecture}" envsubst \
                         > "${debian_dir}/DEBIAN/control"

# Copy bin/lib files
cp "${debian}/bin"/* "${debian_dir}/usr/bin/"
cp -R "${src_dir}/pyinstaller/dist/${python_name}" "${debian_dir}/usr/lib/"

# Build .deb package
cd "${debian}/" && fakeroot dpkg --build "${debian_package}"
mv "${debian}/${debian_package}.deb" "${dist}/"

# -----------------------------------------------------------------------------

echo "OK"

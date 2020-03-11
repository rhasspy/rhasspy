#!/usr/bin/env bash
set -e

architecture="$1"
version="$2"

if [[ -z "${version}" ]];
then
    echo "Usage: build-debian-satellite.sh architecture version"
    exit 1
fi

# Directory of *this* script
this_dir="$( cd "$( dirname "$0" )" && pwd )"
src_dir="$(realpath "${this_dir}/..")"

package_name='rhasspysatellite'
python_name='rhasspysatellite'

venv="${src_dir}/.venv"
if [[ -d "${venv}" ]]; then
    echo "Using virtual environment at ${venv}"
    source "${venv}/bin/activate"
fi

# -----------------------------------------------------------------------------

dist="${src_dir}/dist"
mkdir -p dist

# Create PyInstaller artifacts
dist_dir="${src_dir}/pyinstaller/dist"
pyinstaller \
    -y \
    --workpath "${src_dir}/pyinstaller/build" \
    --distpath "${dist_dir}" \
    "${python_name}.spec"

# Delete unnecessary directories
rm -rf \
   "${pyinstaller_dist}/${python_name}/share/" \
   "${pyinstaller_dist}${python_name}/notebook/"

download_dir="${src_dir}/download"

# Copy required files
mkdir -p "${dist_dir}/${python_name}/rhasspyprofile"
cp -R "${src_dir}/rhasspy-profile/rhasspyprofile/profiles" \
   "${dist_dir}/${python_name}/rhasspyprofile/"

mkdir -p "${dist_dir}/${python_name}/rhasspyserver_hermes"
cp -R "${src_dir}/rhasspy-server-hermes/web" \
   "${src_dir}/rhasspy-server-hermes/templates" \
   "${src_dir}/VERSION" \
   "${dist_dir}/${python_name}/rhasspyserver_hermes"

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
cat "${debian}/DEBIAN_satellite/control" | \
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

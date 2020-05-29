#!/usr/bin/env bash
set -e

# Directory of *this* script
this_dir="$( cd "$( dirname "$0" )" && pwd )"
src_dir="$(realpath "${this_dir}/..")"

dist_dir="${src_dir}/dist"
mkdir -p "${dist_dir}"

version="$(cat "${src_dir}/VERSION")"

# -----------------------------------------------------------------------------

# Files to include in distribution
dist_files=(
    'bin/rhasspy-voltron'
    'bin/voltron-run'
    'etc/shflags'
    'etc/wav'
    'm4'
    'scripts'
    'aclocal.m4'
    'config.guess'
    'configure'
    'config.sub'
    'install-sh'
    'LICENSE'
    'Makefile.in'
    'missing'
    'README.md'
    'requirements.txt'
    'rhasspy.sh.in'
    'rhasspy.spec.in'
    'RHASSPY_DIRS'
    'setup.py.in'
    'VERSION'
)

# Add sub-modules
while read -r dir_name;
do
    python_name="$(echo "${dir_name}" | sed -e 's/-//' | sed -e 's/-/_/g')"
    dist_files+=(
        "${dir_name}/LICENSE"
        "${dir_name}/MANIFEST.in"
        "${dir_name}/README.md"
        "${dir_name}/requirements.txt"
        "${dir_name}/setup.py"
        "${dir_name}/VERSION"
        "${dir_name}/${python_name}"/*.py
    )

    bin_script="${dir_name}/bin/${dir_name}"
    if [[ -f "${bin_script}" ]]; then
        dist_files+=("${bin_script}")
    fi
done < "${src_dir}/RHASSPY_DIRS"

# Add special cases
dist_files+=(
    'rhasspy-profile/rhasspyprofile/profiles'
    'rhasspy-server-hermes/templates'
    'rhasspy-server-hermes/web'
    'rhasspy-wake-porcupine-hermes/rhasspywake_porcupine_hermes/porcupine'
    'rhasspy-wake-precise-hermes/rhasspywake_precise_hermes/models'
    'rhasspy-wake-snowboy-hermes/rhasspywake_snowboy_hermes/models'
)

# Tar it up
dist_file="${dist_dir}/rhasspy-voltron_${version}.tar.gz"
tar -C "${src_dir}" -czvf "${dist_file}" -- "${dist_files[@]}"

echo ''
echo "Wrote ${dist_file}"

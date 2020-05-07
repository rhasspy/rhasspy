#!/usr/bin/env bash
set -e

# Directory of *this* script
this_dir="$( cd "$( dirname "$0" )" && pwd )"
src_dir="$(realpath "${this_dir}/..")"

venv="${src_dir}/.venv"
if [[ ! -d "${venv}" ]]; then
    echo "Missing virtual environment at ${venv}"
    echo 'Did you run "make venv"?'
    exit 1
fi

# -----------------------------------------------------------------------------

dist_dir="${src_dir}/dist"
mkdir -p "${dist_dir}"

# Make dependent libraries
bash "${this_dir}/build-dists.sh"

# -----------------------------------------------------------------------------

# Create service virtual environments and build
# TODO: Add kaldi
while read -r service_name;
do
    # rhasspy-asr-pocketsphinx-hermes -> rhasspyasr_pocketsphinx_hermes
    python_name="$(echo "${service_name}" | sed -e 's/-//' | sed -e 's/-/_/g')"

    echo "${service_name} (${python_name})"
    service_dir="${src_dir}/${service_name}"
    cd "${service_dir}"

    make dist
    cp "${service_dir}/dist"/*.deb "${dist_dir}/"

    echo ""
done <"${src_dir}/RHASSPY_SERVICES"

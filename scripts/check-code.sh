#!/usr/bin/env bash
set -e

# Directory of *this* script
this_dir="$( cd "$( dirname "$0" )" && pwd )"
src_dir="$(realpath "${this_dir}/..")"

# -----------------------------------------------------------------------------

# Run code checks for all sub-projects
cat "${src_dir}/RHASSPY_DIRS" | \
    while read -r package_name;
    do
        # rhasspy-asr-pocketsphinx-hermes -> rhasspyasr_pocketsphinx_hermes
        python_name="$(echo "${package_name}" | sed -e 's/-//' | sed -e 's/-/_/g')"

        echo '----------'
        echo "${package_name} (${python_name})"
        service_dir="${src_dir}/${package_name}"
        cd "${service_dir}"

        source .venv/bin/activate
        make check
        deactivate

        echo ''
    done

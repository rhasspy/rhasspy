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
bash "${this_dir}/build-sdists.sh"

# -----------------------------------------------------------------------------

# Create service virtual environments and build
# TODO: Add kaldi
cat "${src_dir}/RHASSPY_SERVICES" | \
    while read -r service_name;
    do
        # rhasspy-asr-pocketsphinx-hermes -> rhasspyasr_pocketsphinx_hermes
        python_name="$(echo "${service_name}" | sed -e 's/-//' | sed -e 's/-/_/g')"

        echo "${service_name} (${python_name})"
        service_dir="${src_dir}/${service_name}"
        cd "${service_dir}"

        if [[ ! -d .venv ]]; then
            # Create virtual environment
            rm -rf .venv
            python3 -m venv .venv
            .venv/bin/pip3 install --upgrade wheel setuptools
        fi

        # Install dependencies
        # req_pyinstaller="$(grep pyinstaller "${service_dir}/requirements_dev.txt")"
        if [[ -z "${req_pyinstaller}" ]]; then
            req_pyinstaller='pyinstaller==3.5'
        fi

        .venv/bin/pip3 install \
                       --upgrade \
                       -f "${dist_dir}" \
                       -r requirements.txt \
                       "${req_pyinstaller}"


        # Run PyInstaller
        cd "${service_dir}" && \
            .venv/bin/pyinstaller \
                -y \
                --workpath pyinstaller/build \
                --distpath pyinstaller/dist \
                "${python_name}.spec"

        echo ""
    done

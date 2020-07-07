#!/usr/bin/env bash
set -e

if [[ "$1" == '--no-build' ]]; then
    no_build='yes'
fi

if [[ "$1" == '--no-copy' ]]; then
    no_copy='yes'
fi

# Directory of *this* script
this_dir="$( cd "$( dirname "$0" )" && pwd )"
src_dir="$(realpath "${this_dir}/..")"

# -----------------------------------------------------------------------------

: "${PYTHON=python3}"

dist_dir="${src_dir}/dist"
mkdir -p "${dist_dir}"

if [[ -z "${no_build}" ]]; then
    # Clear old Rhasspy libraries
    rm -f "${dist_dir}/"rhasspy*

    # Make dependent libraries
    while read -r dir_name;
    do
        echo "${dir_name}"
        cd "${src_dir}/${dir_name}" && "${PYTHON}" setup.py sdist --dist-dir "${dist_dir}"
        echo ""
    done < "${src_dir}/RHASSPY_DIRS"
fi

if [[ -z "${no_copy}" ]]; then
    # Update submodule downloads
    while read -r dir_name;
    do
        download_dir="${src_dir}/${dir_name}/download"
        mkdir -p "${download_dir}"

        # Clear old Rhasspy libraries
        rm -f "${download_dir}"/rhasspy*.tar.gz

        # Copy required libraries
        lib_dir_names=("${dir_name}")
        while [[ -n "${lib_dir_names[@]}" ]]; do
            # Pop first item
            lib_dir_name="${lib_dir_names[0]}"
            lib_dir_names=("${lib_dir_names[@]:1}")

            while read -r lib_name;
            do
                dist_name="$(echo "${lib_name}" | sed -e 's/[=~]=/-/').tar.gz"
                cp "${dist_dir}/${dist_name}" "${download_dir}/"
                echo "${dir_name} <- ${dist_name}"

                # Search for more Rhasspy dependencies
                sub_dir_name="$(echo "${lib_name}" | sed -e 's/[=~]=.\+$//')"
                lib_dir_names+=("${sub_dir_name}")
            done < <(grep '^rhasspy-' "${src_dir}/${lib_dir_name}/requirements.txt")
        done
    done < "${src_dir}/RHASSPY_DIRS"
fi

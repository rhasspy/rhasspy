#!/usr/bin/env bash
set -e

# Directory of *this* script
this_dir="$( cd "$( dirname "$0" )" && pwd )"
src_dir="$(realpath "${this_dir}/..")"

# -----------------------------------------------------------------------------

dist_dir="${src_dir}/dist"
mkdir -p "${dist_dir}"

# Clear old Rhasspy libraries
rm -f "${dist_dir}/"rhasspy*

# Make dependent libraries
while read -r dir_name;
do
    echo "${dir_name}"
    cd "${src_dir}/${dir_name}" && python3 setup.py sdist --dist-dir "${dist_dir}"
    echo ""
done < "${src_dir}/RHASSPY_DIRS"

# Update submodule downloads
while read -r dir_name;
do
    download_dir="${src_dir}/${dir_name}/download"

    # Clear old Rhasspy libraries
    rm -f "${download_dir}"/rhasspy*.tar.gz

    # Copy required libraries
    while read -r lib_name;
    do
        dist_name="$(echo "${lib_name}" | sed -e 's/==/-/').tar.gz"
        cp "${dist_dir}/${dist_name}" "${download_dir}/"
        echo "${dir_name} <- ${dist_name}"
    done < <(grep '^rhasspy-' "${dir_name}/requirements.txt")
done < "${src_dir}/RHASSPY_DIRS"

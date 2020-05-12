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

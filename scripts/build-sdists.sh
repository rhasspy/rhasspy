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
cat "${src_dir}/RHASSPY_LIBRARIES" | \
    while read -r lib_name;
do
    echo "${lib_name}"
    cd "${src_dir}/${lib_name}" && python3 setup.py sdist --dist-dir "${dist_dir}"
    echo ""
done

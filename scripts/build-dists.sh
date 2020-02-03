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
while read -r lib_name;
do
    echo "${lib_name}"
    cd "${src_dir}/${lib_name}" && python3 setup.py sdist --dist-dir "${dist_dir}"
    echo ""
done < "${src_dir}/RHASSPY_LIBRARIES"

# Special cases
for lib_name in 'rhasspy-asr-kaldi' 'rhasspy-asr-pocketsphinx';
do
    cd "${src_dir}/${lib_name}" && \
        make dist && \
        cp "dist"/*.whl "${dist_dir}/"
done

# -----------------------------------------------------------------------------

# Copy to submodule download directories
while read -r dir_name;
do
    cd "${src_dir}/${dir_name}" && mkdir -p download && cp -f "${dist_dir}"/rhasspy* download/
done < "${src_dir}/RHASSPY_DIRS"

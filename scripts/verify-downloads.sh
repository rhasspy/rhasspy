#!/usr/bin/env bash
# Directory of *this* script
this_dir="$( cd "$( dirname "$0" )" && pwd )"
src_dir="$(realpath "${this_dir}/..")"

download_dir="${src_dir}/download"
diff "${src_dir}/etc/downloads.md5" \
     <(cd "${download_dir}" && md5sum *)

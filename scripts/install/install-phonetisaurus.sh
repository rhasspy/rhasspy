#!/usr/bin/env bash
set -e

if [[ -z "$2" ]]; then
    echo "Usage: install-phonetisaurus.sh phonetisaurus.tar.gz output-dir/"
    exit 1
fi

phonetisaurus="$(realpath "$1")"
output="$(realpath "$2")"

# -----------------------------------------------------------------------------

# Create a temporary directory for extraction
temp_dir="$(mktemp -d)"

function cleanup {
    rm -rf "${temp_dir}"
}

trap cleanup EXIT

# -----------------------------------------------------------------------------

tar -C "${temp_dir}" -xf "${phonetisaurus}"
install -D "--target-directory=${output}/bin" -- "${temp_dir}/bin"/*

mkdir -p "${output}/lib"
cp -a "${temp_dir}/lib"/*.so* "${output}/lib/"

mkdir -p "${output}/lib/fst"
cp -a "${temp_dir}/lib/fst"/*.so* "${output}/lib/fst/"

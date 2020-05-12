#!/usr/bin/env bash
set -e

if [[ -z "$2" ]]; then
    echo "Usage: install-deepspeech.sh native_client.tar.xz output-dir/"
    exit 1
fi

native_client="$(realpath "$1")"
output="$(realpath "$2")"

# -----------------------------------------------------------------------------

# Create a temporary directory for extraction
temp_dir="$(mktemp -d)"

function cleanup {
    rm -rf "${temp_dir}"
}

trap cleanup EXIT

# -----------------------------------------------------------------------------

tar -C "${temp_dir}" -xf "${native_client}"
install -D "--target-directory=${output}/bin" -- "${temp_dir}/generate_trie" "${temp_dir}/deepspeech"
install -D "--target-directory=${output}/lib" -- "${temp_dir}"/*.so*
install -D "--target-directory=${output}/include" -- "${temp_dir}"/*.h

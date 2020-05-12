#!/usr/bin/env bash
set -e

if [[ -z "$2" ]]; then
    echo "Usage: install-kenlm.sh kenlm.tar.gz output-dir/"
    exit 1
fi

kenlm="$(realpath "$1")"
output="$(realpath "$2")"

mkdir -p "${output}/bin"
tar -C "${output}/bin" -xf "${kenlm}"

#!/usr/bin/env bash
set -e

if [[ -z "$2" ]]; then
    echo "Usage: install-kaldi.sh kaldi.tar.gz output-dir/"
    exit 1
fi

kaldi="$(realpath "$1")"
output="$(realpath "$2")"

mkdir -p "${output}/lib/kaldi"
tar -C "${output}/lib/kaldi" -xf "${kaldi}" --strip-components=1

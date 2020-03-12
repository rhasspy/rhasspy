#!/usr/bin/env bash
kaldi="$1"
output="$2"

if [[ -z "${output}" ]]; then
    echo "Usage: install-kaldi.sh kaldi.tar.gz output-dir/"
    exit 1
fi

tar -C "${output}" -xvf "${kaldi}"

#!/usr/bin/env bash
kenlm="$1"
output="$2"

if [[ -z "${output}" ]]; then
    echo "Usage: install-kenlm.sh kenlm.tar.gz output-dir/"
    exit 1
fi

tar -C "${output}" -xvf "${kenlm}" build_binary

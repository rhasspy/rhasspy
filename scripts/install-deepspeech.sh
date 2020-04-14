#!/usr/bin/env bash
native_client="$1"
output="$2"

if [[ -z "${output}" ]]; then
    echo "Usage: install-deepspeech.sh native_client.tar.xz output-dir/"
    exit 1
fi

tar -C "${output}" -xvf "${native_client}" generate_trie

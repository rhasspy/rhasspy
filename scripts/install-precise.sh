#!/usr/bin/env bash
precise="$1"
output="$2"

if [[ -z "${output}" ]]; then
    echo "Usage: install-precise.sh precise-engine.tar.gz output-dir/"
    exit 1
fi

tar -C "${output}" -xvf "${precise}"

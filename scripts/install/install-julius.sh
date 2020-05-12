#!/usr/bin/env bash
set -e

if [[ -z "$2" ]]; then
    echo "Usage: install-julius.sh julius.tar.gz output-dir/"
    exit 1
fi

julius="$(realpath "$1")"
output="$(realpath "$2")"

mkdir -p "${output}/bin"
tar -C "${output}/bin" -xf "${julius}"

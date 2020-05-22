#!/usr/bin/env bash
set -e

if [[ -z "$2" ]]; then
    echo "Usage: install-nanotts.sh nanotts.tar.gz output-dir/"
    exit 1
fi

nanotts="$(realpath "$1")"
output="$(realpath "$2")"

mkdir -p "${output}"
tar -C "${output}" -xf "${nanotts}"

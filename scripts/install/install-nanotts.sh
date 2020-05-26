#!/usr/bin/env bash
set -e

if [[ -z "$2" ]]; then
    echo "Usage: install-nanotts.sh nanotts.tar.gz output-dir/"
    exit 1
fi

nanotts="$(realpath "$1")"
output="$(realpath "$2")"

mkdir -p "${output}/lib/nanotts"
tar -C "${output}/lib/nanotts" --strip-components=1 -xf "${nanotts}"
mv "${output}/lib/nanotts/pico/lang" "${output}/lib/nanotts/"
ln -sf "${output}/lib/nanotts/nanotts" "${output}/bin/nanotts"

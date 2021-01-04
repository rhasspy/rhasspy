#!/usr/bin/env bash
set -e

if [[ -z "$2" ]]; then
    echo "Usage: install-precise.sh precise-engine.tar.gz output-dir/"
    exit 1
fi

precise="$(realpath "$1")"
output="$(realpath "$2")"

mkdir -p "${output}/lib/precise"
tar -C "${output}/lib/precise" -xf "${precise}" --strip-components=1

# Use relative link
pushd "${output}/bin"
ln -sf "../lib/precise/precise-engine" 'precise-engine'
popd

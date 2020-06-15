#!/usr/bin/env bash

if [[ -z "$1" ]]; then
    echo "Usage: get-requirements.txt <HOST_CPU>"
    exit 1
fi

set -e

: "${PYTHON=python3}"

# Directory of *this* script
this_dir="$( cd "$( dirname "$0" )" && pwd )"
src_dir="$(realpath "${this_dir}/..")"

"${src_dir}/configure" --enable-in-place "--host=$1-unknown-linux-gnueabihf" >&2
"${PYTHON}" "${src_dir}/setup.py" egg_info >&2
cat "${src_dir}/rhasspy.egg-info/requires.txt" | sort | uniq

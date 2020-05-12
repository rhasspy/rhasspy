#!/usr/bin/env bash
set -e
: "${MAKE_THREADS=4}"

if [[ -z "$3" ]]; then
    echo "Usage: build-julius julius.tar.gz build/ output.tar.gz"
    exit 1
fi

julius_src="$(realpath "$1")"
build_dir="$(realpath "$2")"
output_file="$(realpath "$3")"

# Julius
julius_build="${build_dir}/julius"
echo "Building Julius in ${julius_build} from ${julius_src}"
mkdir -p "${julius_build}"
tar -C "${julius_build}" --strip-components=1 -xf "${julius_src}"
cd "${julius_build}" && \
    mkdir -p build && \
    ./configure "--prefix=${julius_build}/build" && \
    make -j "${MAKE_THREADS}" && \
    make install

# Strip binaries
echo "Tar-ing binary files to ${output_file}"
cd "${julius_build}/build/bin" && \
    (strip --strip-unneeded -- * || true) && \
    tar -czf "${output_file}" -- *


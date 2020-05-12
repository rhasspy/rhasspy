#!/usr/bin/env bash
set -e
: "${MAKE_THREADS=4}"

if [[ -z "$4" ]]; then
    echo "Usage: build-opengrm opengrm.tar.gz openfst.tar.gz build/ output.tar.gz"
    exit 1
fi

opengrm_src="$(realpath "$1")"
openfst_src="$(realpath "$2")"
build_dir="$(realpath "$3")"
output_file="$(realpath "$4")"

# OpenFST
openfst_build="${build_dir}/opengrm/openfst"
echo "Building OpenFST in ${openfst_build} from ${openfst_src}"
mkdir -p "${openfst_build}"
tar -C "${openfst_build}" --strip-components=1 -xf "${openfst_src}"
cd "${openfst_build}" && \
    mkdir -p build && \
    ./configure "--prefix=${openfst_build}/build" --enable-far && \
    make -j "${MAKE_THREADS}" && \
    make install

# Opengrm
opengrm_build="${build_dir}/opengrm"
echo "Building Opengrm in ${opengrm_build} from ${opengrm_src}"
mkdir -p "${opengrm_build}"
tar -C "${opengrm_build}" --strip-components=1 -xf "${opengrm_src}"
cd "${opengrm_build}" && \
    mkdir -p build && \
    CXXFLAGS="-I${openfst_build}/build/include" LDFLAGS="-L${openfst_build}/build/lib" ./configure "--prefix=${opengrm_build}/build" && \
    make -j "${MAKE_THREADS}" && \
    make install

# Strip binaries
echo "Tar-ing binary files to ${output_file}"
cd "${opengrm_build}/build" && \
    cp "${openfst_build}/build/bin"/* bin/ &&
    cp "${openfst_build}/build/lib"/*.so* lib/ &&
    rm -f lib/*.a lib/fst/*.a && \
    (strip --strip-unneeded -- bin/* lib/* lib/fst/* || true) && \
    tar -czf "${output_file}" -- *


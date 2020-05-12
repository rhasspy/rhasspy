#!/usr/bin/env bash
set -e
: "${MAKE_THREADS=4}"

if [[ -z "$4" ]]; then
    echo "Usage: build-phonetisaurus phonetisaurus.tar.gz openfst.tar.gz build/ output.tar.gz"
    exit 1
fi

phonetisaurus_src="$(realpath "$1")"
openfst_src="$(realpath "$2")"
build_dir="$(realpath "$3")"
output_file="$(realpath "$4")"

# OpenFST
openfst_build="${build_dir}/phonetisaurus/openfst"
echo "Building OpenFST in ${openfst_build} from ${openfst_src}"
mkdir -p "${openfst_build}"
tar -C "${openfst_build}" --strip-components=1 -xf "${openfst_src}"
cd "${openfst_build}" && \
    mkdir -p build && \
    ./configure "--prefix=${openfst_build}/build" --enable-far && \
    make -j "${MAKE_THREADS}" && \
    make install

# Phonetisaurus
phonetisaurus_build="${build_dir}/phonetisaurus"
echo "Building Phonetisaurus in ${phonetisaurus_build} from ${phonetisaurus_src}"
mkdir -p "${phonetisaurus_build}"
tar -C "${phonetisaurus_build}" --strip-components=1 -xf "${phonetisaurus_src}"
cd "${phonetisaurus_build}" && \
    mkdir -p build && \
     ./configure "--prefix=${phonetisaurus_build}/build" \
                 "--with-openfst-includes=-I${openfst_build}/build/include" \
                 "--with-openfst-libs=-L${openfst_build}/build/lib" && \
    make -j "${MAKE_THREADS}" && \
    make install

# Strip binaries
echo "Tar-ing binary files to ${output_file}"
cd "${phonetisaurus_build}/build" && \
    cp "${openfst_build}/build/bin"/* bin/ &&
    cp "${openfst_build}/build/lib"/*.so* lib/ &&
    rm -f lib/*.a lib/fst/*.a && \
    (strip --strip-unneeded -- bin/* lib/* || true) && \
    tar -czf "${output_file}" -- *


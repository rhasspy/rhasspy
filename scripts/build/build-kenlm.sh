#!/usr/bin/env bash
set -e
: "${MAKE_THREADS=4}"

if [[ -z "$4" ]]; then
    echo "Usage: build-kenlm kenlm.tar.gz eigen.tar.gz build/ output.tar.gz"
    exit 1
fi

kenlm_src="$(realpath "$1")"
eigen_src="$(realpath "$2")"
build_dir="$(realpath "$3")"
output_file="$(realpath "$4")"

# Eigen
eigen_build="${build_dir}/eigen"
echo "Building eigen in ${eigen_build} from ${eigen_src}"
mkdir -p "${eigen_build}"
tar -C "${eigen_build}" --strip-components=1 -xf "${eigen_src}"
cd "${eigen_build}" && \
    mkdir -p build && \
    cd build && \
    cmake .. && \
    make -j "${MAKE_THREADS}"

# KenLM
kenlm_build="${build_dir}/kenlm"
echo "Building KenLM in ${kenlm_build} from ${kenlm_src}"
mkdir -p "${kenlm_build}"
tar -C "${kenlm_build}" --strip-components=1 -xf "${kenlm_src}"
cd "${kenlm_build}" && \
    mkdir -p build && \
    cd build && \
    cmake .. && \
    make -j "${MAKE_THREADS}"

# Strip binaries
echo "Tar-ing binary files to ${output_file}"
cd "${kenlm_build}/build/bin" && \
    (strip --strip-unneeded -- * || true) && \
    tar -czf "${output_file}" -- *


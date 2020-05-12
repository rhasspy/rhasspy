#!/usr/bin/env bash
set -e
: "${MAKE_THREADS=4}"

if [[ -z "$3" ]]; then
    echo "Usage: build-kaldi kaldi.tar.gz build/ output.tar.gz"
    exit 1
fi

kaldi_src="$(realpath "$1")"
build_dir="$(realpath "$2")"
output_file="$(realpath "$3")"

# Kaldi
kaldi_build="${build_dir}/kaldi"
echo "Building Kaldi in ${kaldi_build} from ${kaldi_src}"
mkdir -p "${kaldi_build}"
tar -C "${kaldi_build}" --strip-components=1 -xf "${kaldi_src}"

cd "${kaldi_build}/tools" && \
    make -j "${MAKE_THREADS}"

cd "${kaldi_build}/src" && \
    ./configure --shared --mathlib=ATLAS --use-cuda=no

# Fix things for aarch64 (arm64v8)
if [ "$(uname --m)" = "aarch64" ]; then
    sed -i 's/-msse -msse2/-ftree-vectorize/g' "${kaldi_build}/src/kaldi.mk"
fi

cd "${kaldi_build}/src" && \
    make depend -j "${MAKE_THREADS}" && \
    make -j "${MAKE_THREADS}"

# Create dist
dist_dir="${kaldi_build}/dist"
mkdir -p "${dist_dir}/kaldi/egs" && \
    cp -R "${kaldi_build}/egs/wsj" "${dist_dir}/kaldi/egs/" && \
    rsync -av --exclude='*.o' --exclude='*.cc' "${kaldi_build}/src/bin/" "${dist_dir}/kaldi/" && \
    cp "${kaldi_build}/src/lib"/*.so* "${dist_dir}/kaldi/" && \
    rsync -av --include='*.so*' --include='fst' --exclude='*' "${kaldi_build}/tools/openfst/lib/" "${dist_dir}/kaldi/" && \
    cp "${kaldi_build}/tools/openfst/bin/" "${dist_dir}/kaldi/"

# Fix rpaths
# shellcheck disable=SC2016
find "${dist_dir}/kaldi/" -type f -exec patchelf --set-rpath '$ORIGIN' {} \;

# Strip binaries
echo "Tar-ing binary files to ${output_file}"
cd "${dist_dir}" && \
    (strip --strip-unneeded kaldi/* || true) && \
    tar -czf "${output_file}" kaldi


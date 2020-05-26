#!/usr/bin/env bash
set -e
: "${MAKE_THREADS=4}"

if [[ -z "$3" ]]; then
    echo "Usage: build-nanotts nanotts.tar.gz build/ output.tar.gz"
    exit 1
fi

nanotts_src="$(realpath "$1")"
build_dir="$(realpath "$2")"
output_file="$(realpath "$3")"

# nanoTTS
nanotts_build="${build_dir}/nanotts"
echo "Building nanoTTS in ${nanotts_build} from ${nanotts_src}"
mkdir -p "${nanotts_build}"
tar -C "${nanotts_build}" --strip-components=1 -xf "${nanotts_src}"
cd "${nanotts_build}" && \
    make -j "${MAKE_THREADS}" noalsa

echo "Tar-ing binary files to ${output_file}"
cd "${nanotts_build}" && \
    mkdir -p bin && \
    cp nanotts bin/ && \
    tar -czf "${output_file}" -- bin/ lang/


#!/usr/bin/env bash
phonetisaurus="$1"
output="$2"

if [[ -z "${output}" ]]; then
    echo "Usage: install-phonetisaurus.sh phonetisaurus.tar.gz output-dir/"
    exit 1
fi

tar -C "${output}" -xvf "${phonetisaurus}" \
	--strip-components=2 \
    ./bin/phonetisaurus-apply ./bin/phonetisaurus-g2pfst \
    ./lib/libfst.so.13.0.0 ./lib/libfstfar.so.13.0.0 ./lib/libfstngram.so.13.0.0

patchelf --set-rpath '$ORIGIN' "${output}/phonetisaurus-g2pfst"

# libfst.so.13.0.0 -> libfst.so.13
for f in libfst.so.13 libfstfar.so.13 libfstngram.so.13
do
    mv "${output}/${f}.0.0" "${output}/${f}"
    patchelf --set-rpath '$ORIGIN' "${output}/${f}"
done

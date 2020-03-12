#!/usr/bin/env bash
mitlm="$1"
output="$2"

if [[ -z "${output}" ]]; then
    echo "Usage: install-mitlm.sh mitlm.tar.gz output-dir/"
    exit 1
fi

tar -C "${output}" -xvf "${mitlm}" \
    --strip-components=2 \
    mitlm/bin/estimate-ngram mitlm/lib/libmitlm.so.1

patchelf --set-rpath '$ORIGIN' "${output}/estimate-ngram"

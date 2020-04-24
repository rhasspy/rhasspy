#!/usr/bin/env bash
opengrm="$1"
output="$2"

if [[ -z "${output}" ]]; then
    echo "Usage: install-opengrm.sh opengrm.tar.gz output-dir/"
    exit 1
fi

tar -C "${output}" -xvf "${opengrm}" \
	--strip-components=2 \
    ./bin/ngramcount ./bin/ngrammake ./bin/ngramprint ./bin/fstcompile \
    ./bin/ngramperplexity ./bin/ngrammerge ./bin/ngramread ./bin/farcompilestrings \
    ./lib/libfst.so.13.0.0 ./lib/libfstfar.so.13.0.0 \
    ./lib/libfstscript.so.13.0.0 ./lib/libngram.so.134.0.0 \
    ./lib/libngramhist.so.134.0.0 ./lib/libfstfarscript.so.13.0.0

for f in ngramcount ngrammake ngramprint fstcompile;
do
    patchelf --set-rpath '$ORIGIN' "${output}/${f}"
done

# libfst.so.13.0.0 -> libfst.so.13
for f in libfst.so.13 libfstfar.so.13 libfstscript.so.13 libfstfarscript.so.13 libngram.so.134 libngramhist.so.134;
do
    mv "${output}/${f}.0.0" "${output}/${f}"
    patchelf --set-rpath '$ORIGIN' "${output}/${f}"
done

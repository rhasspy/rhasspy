#!/usr/bin/env bash
set -e

if [[ -z "$2" ]]; then
    echo "Usage: install-nanotts.sh nanotts.tar.gz output-dir/"
    exit 1
fi

nanotts="$(realpath "$1")"
output="$(realpath "$2")"

mkdir -p "${output}/lib/nanotts"
tar -C "${output}/lib/nanotts" --strip-components=1 -xf "${nanotts}"

# Write wrapper script that uses correct lang dir
(
cat <<'EOF'
#!/usr/bin/env bash
this_dir="$( cd "$( dirname "$0" )" && pwd )"

nanotts_dir="$(realpath "${this_dir}/../lib/nanotts")"
"${nanotts_dir}/nanotts" -l "${nanotts_dir}/pico/lang" "$@"
EOF
) > "${output}/bin/nanotts"

chmod +x "${output}/bin/nanotts"

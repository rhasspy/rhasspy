#!/usr/bin/env bash
set -e

# Directory of *this* script
this_dir="$( cd "$( dirname "$0" )" && pwd )"
src_dir="$(realpath "${this_dir}/..")"

venv="${src_dir}/.venv"
if [[ -d "${venv}" ]]; then
    echo "Using virtual environment at ${venv}"
    source "${venv}/bin/activate"
fi

# -----------------------------------------------------------------------------

docs_dir="${src_dir}/rhasspy-server-hermes/web/docs"
mkdocs build --site-dir "${docs_dir}"

# -----------------------------------------------------------------------------

echo "OK"

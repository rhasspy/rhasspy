#!/usr/bin/env bash
set -e

# Directory of *this* script
this_dir="$( cd "$( dirname "$0" )" && pwd )"
src_dir="$(realpath "${this_dir}/..")"

cat "${src_dir}/RHASSPY_DIRS" | \
    while read -r dir_name;
    do
        if [[ ! -d "${src_dir}/${dir_name}" ]]; then
            git clone "http://github.com/rhasspy/${dir_name}.git"
        fi

        cd "${src_dir}/${dir_name}"
        if [[ -z "$(ls)" ]]; then
            git checkout master
        fi

        echo "${dir_name} OK"
    done

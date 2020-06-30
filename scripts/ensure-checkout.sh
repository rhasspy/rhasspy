#!/usr/bin/env bash
set -e

# Directory of *this* script
this_dir="$( cd "$( dirname "$0" )" && pwd )"
src_dir="$(realpath "${this_dir}/..")"

while read -r dir_name;
do
    if [[ ! -d "${src_dir}/${dir_name}" ]]; then
        cd "${src_dir}" && git clone "http://github.com/rhasspy/${dir_name}.git"
    fi

    if [[ ! -f README.md ]]; then
        cd "${src_dir}/${dir_name}" && git checkout master
    fi

    echo "${dir_name} OK"
done <"${src_dir}/RHASSPY_DIRS"

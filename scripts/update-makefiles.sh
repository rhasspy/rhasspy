#!/usr/bin/env bash
# Directory of *this* script
this_dir="$( cd "$( dirname "$0" )" && pwd )"
src_dir="$(realpath "${this_dir}/..")"

# -----------------------------------------------------------------------------

while read -r service_name;
do
    cp "${src_dir}/Makefile.service.template" "${src_dir}/${service_name}/Makefile"
done <"${src_dir}/RHASSPY_SERVICES"

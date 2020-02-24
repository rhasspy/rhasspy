#!/usr/bin/env bash
this_dir="$( cd "$( dirname "$0" )" && pwd )"
base_dir="$(realpath "${this_dir}/..")"

lang="$1"
if [[ -z "${lang}" ]]; then
    echo "Usage: run-tests-for.sh <LANGUAGE>"
    exit 1
fi

venv="${base_dir}/.venv"
if [[ -d "${venv}" ]]; then
    echo "Using virtual environment at ${venv}"
    source "${venv}/bin/activate"
fi

# -----------------------------------------------------------------------------

# Create a temporary directory for profiles
temp_dir="$(mktemp -d)"

# function cleanup {
#     rm -rf "${temp_dir}"
# }

# trap cleanup EXIT

# -----------------------------------------------------------------------------

function wait-for-url() {
    url="$1"
    echo "Waiting for ${url}"
    timeout 30 bash -c \
            'while [[ "$(curl -s -o /dev/null -w "%{http_code}" "${0}")" != "200" ]]; do sleep 0.5; done' \
            "${url}"
}

# -----------------------------------------------------------------------------

profiles_dir="${base_dir}/profiles/${lang}"
shared_dir="${profiles_dir}/shared"

for profile_dir in ${profiles_dir}/test_*; do
    profile_name="$(basename "${profile_dir}")"
    echo "${lang}/${profile_name}"
    cp -R "${profile_dir}" "${temp_dir}/${lang}"
    cp -R "${shared_dir}"/* "${temp_dir}/${lang}/"

    user="$(id -u):$(id -g)"
    container_id="$(docker run -d -v "${temp_dir}:/profiles" --user "${user}" --network host cecep-prime:15555/services/rhasspy:2.5.0 --profile "${lang}" --user-profiles /profiles -- --set download.url_base http://localhost:5000)"

    (
        wait-for-url 'http://localhost:12101/api/version' || exit 1
        echo ''

        echo "Downloading"
        curl -X POST 'http://localhost:12101/api/download-profile' || exit 1
        echo ''

        echo "Restarting"
        curl -X POST 'http://localhost:12101/api/restart' || exit 1
        echo ''

        echo "Training"
        curl -X POST 'http://localhost:12101/api/train' || exit 1
        echo ''

        echo "Testing"
        (cd "${base_dir}" && python3 -m unittest tests/${lang}/*.py) || exit 1
        echo ''
    ) || docker stop "${container_id}"
done

#!/usr/bin/env bash

# Directory of *this* script
this_dir="$( cd "$( dirname "$0" )" && pwd )"
src_dir="$(realpath "${this_dir}/..")"

config_home="${XDG_CONFIG_HOME}"
if [[ -z "${config_home}" ]]; then
    config_home="${HOME}/.config"
fi

# -----------------------------------------------------------------------------
# Command-line Arguments
# -----------------------------------------------------------------------------

. "${src_dir}/etc/shflags"

DEFINE_string 'profile' '' 'Path to profile' 'p'
DEFINE_string 'system-profiles' "${src_dir}/rhasspy-server-hermes/profiles" 'Directory with base profile files'
DEFINE_string 'user-profiles' "${config_home}/rhasspy/profiles" 'Directory with user profile files'

FLAGS "$@" || exit $?
eval set -- "${FLAGS_ARGV}"

set -e

# -----------------------------------------------------------------------------
# Load settings
# -----------------------------------------------------------------------------

profile_name="${FLAGS_profile}"
if [[ -z "${profile_name}" ]]; then
    echo "--profile is required"
    exit 1
fi

system_profiles="${FLAGS_system_profiles}"
if [[ -z "${system_profiles}" ]]; then
    echo "--system-profiles is required"
    exit 1
fi

user_profiles="${FLAGS_user_profiles}"
if [[ -z "${user_profiles}" ]]; then
    echo "--user-profiles is required"
    exit 1
fi

profile_dir="${user_profiles}/${profile_name}"

mqtt_host='localhost'
mqtt_port='1883'

# -----------------------------------------------------------------------------

# Include services on PATH
while read -r service_name;
do
    # rhasspy-asr-pocketsphinx-hermes -> rhasspyasr_pocketsphinx_hermes
    python_name="$(echo "${service_name}" | sed -e 's/-//' | sed -e 's/-/_/g')"
    service_dir="${src_dir}/${python_name}"

    # Create symbolic link to real executable.
    # rhasspyasr_pocketsphinx_hermes -> rhasspy-asr-pocketsphinx-hermes
    service_bin="${service_dir}/${service_name}"
    if [[ ! -f "${service_bin}" ]]; then
        ln -s "${service_dir}/${python_name}" "${service_bin}"
    fi

    export PATH="${service_dir}:${PATH}"
done < "${src_dir}/RHASSPY_SERVICES"

# -----------------------------------------------------------------------------

# Generate supervisord conf
conf_path="${profile_dir}/supervisord.conf"
echo "Generating ${conf_path}"

rhasspysupervisor \
    --profile "${profile_name}" \
    --system-profiles "${system_profiles}" \
    --user-profiles "${user_profiles}" \
    --docker-compose '' \
    --debug

# Run web server
rhasspyserver_hermes \
    --profile "${profile_name}" \
    --system-profiles "${system_profiles}" \
    --user-profiles "${user_profiles}" \
    --web-dir "${src_dir}/web" \
    &

# Kill the process above when this terminal exits
web_pid=$!

function finish {
    kill "${web_pid}"
}

trap finish EXIT

# Run assistant
log_path="${profile_dir}/supervisord.log"
pid_path="${profile_dir}/supervisord.pid"
supervisord \
    --configuration "${conf_path}" \
    --logfile "${log_path}" \
    --pidfile "${pid_path}"

#!/usr/bin/env bash

if [[ -z "$(command -v docker)" ]]; then
    echo "Docker is required"
    exit 1
fi

if [[ -z "$(command -v docker-compose)" ]]; then
    echo "Docker compose is required"
    exit 1
fi

rhasspy_supervisor_version='0.1.3'
rhasspy_server_version='2.5.0'

# -----------------------------------------------------------------------------

profile=''

while [[ ! -z "$1" ]];
do
    if [ "$1" == "--profile" ] || [ "$1" == "-p" ]; then
        profile="$2"
        shift 2
    fi

    shift 1
done

if [[ -z "${profile}" ]]; then
    echo "--profile or -p is required"
    exit 1
fi

# -----------------------------------------------------------------------------


config_home="${XDG_CONFIG_HOME}"
if [[ -z "${config_home}" ]]; then
    config_home="${HOME}/.config"
fi


user_profiles="${config_home}/rhasspy/profiles"

function rhasspy_supervisor {
    docker run -it \
           --user "$(id -u):$(id -g)" \
           -v "${user_profiles}:${user_profiles}" \
           "rhasspy/rhasspy-supervisor:${rhasspy_supervisor_version}" \
           "$@"
}

function rhasspy_server {
    docker run -it \
           --user "$(id -u):$(id -g)" \
           --network host \
           -v "${user_profiles}:${user_profiles}" \
           "rhasspy/rhasspy-server-hermes:${rhasspy_server_version}" \
           "$@"
}

# -----------------------------------------------------------------------------

pid_file="${user_profiles}/${profile}/supervisord.pid"
rm -f "${pid_file}"

# Generate docker-compose.yml
rhasspy_supervisor \
    --user-profiles "${user_profiles}" \
    --profile "${profile}" \
    --debug

compose_file="${user_profiles}/${profile}/docker-compose.yml"
compose_running=''

function finish {
    echo "Exiting"
    if [[ ! -z "${compose_running}" ]]; then
        # Shut down Docker services if still running
        docker-compose --file "${compose_file}" down
    fi
}

trap finish EXIT

exit_code="2"
while [[ "${exit_code}" -eq "2" ]];
do
    docker-compose --file "${compose_file}" up --detach
    compose_running='1'

    # Run web server
    rhasspy_server  \
        --mqtt-host 'localhost' \
        --user-profiles "${user_profiles}" \
        --profile "${profile}"

    # An exit code of 2 indicates a restart
    exit_code="$?"

    docker-compose --file "${compose_file}" down --timeout 5
    compose_running=''
done

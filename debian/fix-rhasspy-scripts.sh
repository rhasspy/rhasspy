#!/usr/bin/env bash
prefix='/usr/lib/rhasspy'

while [[ ! -z "$1" ]];
do
    script_file="$1"

    # rhasspy-command-name
    script_name="$(basename "${script_file}")"

    # command-name
    command_name="${script_name:8}"

    # Overwrite script to use "rhasspy command-name"
    cat > "${script_file}" <<EOF
#!/usr/bin/env bash
"${prefix}/rhasspy/rhasspy" ${command_name} "\$@"
EOF
    chmod +x "${script_file}"
    shift 1
done

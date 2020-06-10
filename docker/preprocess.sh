#!/usr/bin/env bash

# Very basic preprocessor that reads from stdin and prints to stdout.
#
# Lines starting with '# IFDEF FOO' ignore the lines until '# ENDIF' if $FOO is
# empty in the environment.
#
# Within IFDEF/ENDIF blocks, lines starting with #! will have environment
# variables expanded using envsubst and the #! prefix stripped.

drop_line=''
ifdef_regex='^# IFDEF (.+)$'
reveal_regex='^#!'

while read line || [ -n "${line}" ];
do
    if [[ "${line}" =~ ${ifdef_regex} ]]; then
        name="${BASH_REMATCH[1]}"
        if [[ -z "${!name}" ]]; then
            drop_line='1'
        fi

        # Don't output preprocessor directive
        continue
    elif [[ "${line}" == '# ENDIF' ]]; then
        drop_line=''

        # Don't output preprocessor directive
        continue
    fi

    if [[ -z "${drop_line}" ]]; then
        if [[ "${line}" =~ ${reveal_regex} ]]; then
            # Strip #! prefix and expand environment variables
            line="$(echo "${line:2}" | envsubst)"
        fi

        # Output line
        echo "${line}"
    fi
done

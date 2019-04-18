#!/bin/bash

function error() {
    echo error: "$1"
    echo
    help
    exit 1
}

# just create new function with description
function to-add-option() {
    help
}


# prints this message
function help() {
    echo "options:"
    cat "$0" \
        | grep -v '#!/bin/bash' \
        | grep -A1 -e '^#.*' \
        | sed 's/function \(.*\)() {/\1/' \
        | grep -v '\-\-' \
        | sed '1!G;h;$!d' \
        | sed '/^#/!N;s/\n//' \
        | sed 's/ *# */\|- /' \
        | column -t -s'|'
}

OPTIONS=$(cat "$0" \
    | grep -v '#!/bin/bash' \
    | grep -A1 -e '^#.*' \
    | sed 's/function \(.*\)() {/\1/' \
    | grep -v '\-\-' \
    | grep -v '#')
ERROR=true
for var in "$@"; do
    for option in ${OPTIONS}; do
        if [[ ${var} == ${option} ]]; then
            ${option} ${*:2}
	    ERROR=false
        fi
    done
done

if [[ ${ERROR} == true ]]; then
    error "invalid option $1"
fi

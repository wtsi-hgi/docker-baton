#!/usr/bin/env bash
DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function validateBatonVariant {
    batonVariant=$1

    if [[ -z "$batonVariant" ]]
    then
        echo "baton variant must be passed as the first argument"
        exit 1
    fi

    if [[ ! -d "$DIRECTORY/../$batonVariant" ]]
    then
        echo "baton variant \"$batonVariant\" does not exist"
        exit 1
    fi
}

function validateIrodsVariant {
    batonVariant=$1
    irodsVariant=$2

    if [[ ! -d "$DIRECTORY/../$batonVariant/$irodsVariant" ]]
    then
        echo "$DIRECTORY/../$batonVariant/$irodsVariant"
        echo "iRODS variant \"$irodsVariant\" does not exist for baton \"$batonVariant\""
        exit 1
    fi
}

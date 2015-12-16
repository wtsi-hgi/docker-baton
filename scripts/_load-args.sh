#!/usr/bin/env bash
if [[ -z "$1" ]]
then
    echo "baton branch must be given as the first argument"
    exit 1
fi
export batonBranch=$1

if [[ -z "$2" ]]
then
    export batonRepository="https://github.com/wtsi-npg/baton"
else
    export batonRepository=$2
fi

export irodsVariant="irods-3.3.1"

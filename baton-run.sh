#!/bin/bash
logLocation="log"

if [ -z "$IRODS_SETTINGS" ]
then
    errorMessage="IRODS_SETTINGS not set"
    echo "$errorMessage" >> $logLocation
    >&2 echo "$errorMessage"
    exit 1
fi

if [ ! -f "$IRODS_SETTINGS" ]
then
    echo "$IRODS_SETTINGS has not been mounted in a volume" >> $logLocation

    if [ -z "$IRODS_USERNAME" ]
    then
        missingVariable="IRODS_USERNAME"
    elif [ -z "$IRODS_HOST" ]
    then
        missingVariable="IRODS_HOST"
    elif [ -z "$IRODS_PORT" ]
    then
        missingVariable="IRODS_PORT"
    elif [ -z "$IRODS_ZONE" ]
    then
        missingVariable="IRODS_ZONE"
    fi

    if [ -n "$missingVariable" ]
    then
        settingsDirectory="$(dirname $IRODS_SETTINGS)"
        settingsFile="$(basename $IRODS_SETTINGS)"
        errorMessage="$missingVariable environment variable must be set. Alternatively, mount a directory containing an iRODs client settings file '$settingsFile' in '$settingsDirectory/'"
        echo "$errorMessage" >> $logLocation
        >&2 echo "$errorMessage"
        exit 1
    else
        echo "irodsUserName $IRODS_USERNAME" >> $IRODS_SETTINGS
        echo "irodsHost $IRODS_HOST" >> $IRODS_SETTINGS
        echo "irodsPort $IRODS_PORT" >> $IRODS_SETTINGS
        echo "irodsZone $IRODS_ZONE" >> $IRODS_SETTINGS
        echo "Written settings to: $IRODS_SETTINGS" >> $logLocation
    fi
else
    echo "$IRODS_SETTINGS has been mounted in a volume" >> $logLocation
fi

echo "Executing user command: $*" >> $logLocation
sh -c "$*"
exit 0

#!/usr/bin/env bash
set -e -o pipefail
LOG_LOCATION="log"
userCommands=$*

execute_user_command() {
    echo "Executing user command: $*" >> ${LOG_LOCATION}
    bash -c "$userCommands"
    exit $?
}

exitWithError() {
    # Log to stderr
    >&2 cat ${LOG_LOCATION}

    if [ -n "${DEBUG}" ] && [ "${DEBUG}" -eq 1 ]
    then
        >&2 echo "Debug mode enabled - ignoring settings issue"
        execute_user_command
    else
        exit 1
    fi
}

if [ -z "${IRODS_SETTINGS}" ]
then
    errorMessage="IRODS_SETTINGS not set"
    echo "${errorMessage}" >> ${LOG_LOCATION}
    exitWithError
fi

if [ ! -f "${IRODS_SETTINGS}" ]
then
    echo "${IRODS_SETTINGS} has not been mounted in a volume" >> ${LOG_LOCATION}

    if [ -z "${IRODS_USERNAME}" ]
    then
        missingVariable="IRODS_USERNAME"
    elif [ -z "${IRODS_HOST}" ]
    then
        missingVariable="IRODS_HOST"
    elif [ -z "${IRODS_PORT}" ]
    then
        missingVariable="IRODS_PORT"
    elif [ -z "${IRODS_ZONE}" ]
    then
        missingVariable="IRODS_ZONE"
    fi

    if [ -n "${missingVariable}" ]
    then
        settingsDirectory="$(dirname ${IRODS_SETTINGS})"
        settingsFile="$(basename ${IRODS_SETTINGS})"
        errorMessage="${missingVariable} environment variable must be set. Alternatively, mount a directory containing an iRODs client settings file '${settingsFile}' in '${settingsDirectory}/'"
        echo "${errorMessage}" >> ${LOG_LOCATION}
        exitWithError
    else
        echo "irodsUserName ${IRODS_USERNAME}" >> ${IRODS_SETTINGS}
        echo "irodsHost ${IRODS_HOST}" >> ${IRODS_SETTINGS}
        echo "irodsPort ${IRODS_PORT}" >> ${IRODS_SETTINGS}
        echo "irodsZone ${IRODS_ZONE}" >> ${IRODS_SETTINGS}
        echo "Written settings to: ${IRODS_SETTINGS}" >> $LOG_LOCATION
    fi
else
    echo "${IRODS_SETTINGS} has been mounted in a volume" >> $LOG_LOCATION
fi

cat ${IRODS_SETTINGS} >> $LOG_LOCATION

if [ -n "${IRODS_PASSWORD}" ]
then
    echo "iRODs password supplied to authenticate user '${IRODS_USERNAME}'" >> ${LOG_LOCATION}
    iinit "${IRODS_PASSWORD}" 2>> ${LOG_LOCATION}
    if [ $? -ne 0 ]
    then
        exitWithError
    fi
else
    echo "iRODs password not supplied" >> ${LOG_LOCATION}
fi

execute_user_command
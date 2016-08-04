#!/usr/bin/env bash
# Dockerhub expects all required build content to be within the same directory as the Dockerfile. It does not support
# the use of symlinks. Other than downloading from the Internet, the only way to have this common script is to
# disgustingly duplicate it. Please only edit the original (/base/irods-3.3.1/setup.sh) and make copies read-only.
LOG_LOCATION="log"
userCommands=$*

log() {
    echo "$*" >> ${LOG_LOCATION}
}

execute_user_command() {
    log "Executing user command: ${userCommands}"
    bash -c "${userCommands}"
    exit $?
}

exitWithError() {
    # Dump log to stderr
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
    log "IRODS_SETTINGS not set"
    exitWithError
fi

if [ ! -f "${IRODS_SETTINGS}" ]
then
    log "${IRODS_SETTINGS} has not been mounted in a volume"

    if [ -z "${IRODS_HOST}" ]
    then
        missingVariable="IRODS_HOST"
    elif [ -z "${IRODS_PORT}" ]
    then
        missingVariable="IRODS_PORT"
    elif [ -z "${IRODS_USERNAME}" ]
    then
        missingVariable="IRODS_USERNAME"
    elif [ -z "${IRODS_ZONE}" ]
    then
        missingVariable="IRODS_ZONE"
    fi

    if [ -n "${missingVariable}" ]
    then
        settingsDirectory="$(dirname ${IRODS_SETTINGS})"
        settingsFile="$(basename ${IRODS_SETTINGS})"
        log "${missingVariable} environment variable must be set. Alternatively, mount a directory containing an iRODs \
        client settings file '${settingsFile}' in '${settingsDirectory}/'"
        exitWithError
    else
        ./write-settings.sh $IRODS_HOST $IRODS_PORT $IRODS_USERNAME $IRODS_ZONE $IRODS_SETTINGS
        log "Written settings to: ${IRODS_SETTINGS}"
    fi
else
    log "${IRODS_SETTINGS} has been mounted in a volume"
fi

log $(cat "${IRODS_SETTINGS}")

if [ -n "${IRODS_PASSWORD}" ]
then
    log "iRODs password supplied to authenticate user '${IRODS_USERNAME}' - calling iinit"
    iinit_out=$(iinit "${IRODS_PASSWORD}" 2>&1)
    if [ $? -ne 0 ]
    then
        log ${iinit_out}
        exitWithError
    fi
else
    log "iRODs password not supplied"
fi

execute_user_command
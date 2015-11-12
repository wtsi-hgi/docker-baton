#!/bin/bash

if [ -z "$IRODS_USERNAME" ]
then
    echo "IRODS_USERNAME parameter must be set"
elif [ -z "$IRODS_HOST" ]
then
    echo "IRODS_HOST must be set"
elif [ -z "$IRODS_PORT" ]
then
    echo "IRODS_PORT must be set"
elif [ -z "$IRODS_ZONE" ]
then
    echo "irodsZone must be set"
else
    echo "irodsUserName $IRODS_USERNAME" >> $IRODS_SETTINGS
    echo "irodsHost $IRODS_HOST" >> $IRODS_SETTINGS
    echo "irodsPort $IRODS_PORT" >> $IRODS_SETTINGS
    echo "irodsZone $IRODS_ZONE" >> $IRODS_SETTINGS

    sh -c "$*"
fi

exit 1

# baton in Docker
With iRODs version 3.3.1.

## Building the container
```bash
docker build -t wtsi-hgi/baton -f Dockerfile .
```

## Using the container
```bash
docker run -it -e IRODS_USERNAME=<username> -e IRODS_HOST=<host> -e IRODS_PORT=<port> -e IRODS_ZONE=<zone> wtsi-hgi/baton <baton_command>
```
e.g.
```bash
docker run -it -e IRODS_USERNAME="my_username" -e IRODS_HOST="my.irods.host" -e IRODS_PORT=1234 -e IRODS_ZONE="my_zone" wtsi-hgi/baton baton-get
```

All environment variables (IRODS_USERNAME, IRODS_HOST, IRODS_PORT, IRODS_ZONE) must be set.


docker run -it -v $PWD/.irods:/root/.irods -e IRODS_PASSWORD="testuser" wtsi-hgi/baton bash

docker run -it -e IRODS_USERNAME="testuser" -e IRODS_HOST="192.168.99.100" -e IRODS_PORT=1247 -e IRODS_ZONE="iplant" -e IRODS_PASSWORD="testuser" wtsi-hgi/baton bash


Will exit with error if IRODS_PASSWORD is incorrect.

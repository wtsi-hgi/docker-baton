# baton in Docker
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

# baton in Docker
With iRODs version 3.3.1.

## Building the container
```bash
docker build -t wtsi-hgi/baton -f Dockerfile .
```

## Using the container
### Suppling configuration through environmental variables
```bash
docker run -it -e IRODS_USERNAME=<username> -e IRODS_HOST=<host> -e IRODS_PORT=<port> -e IRODS_ZONE=<zone> -e IRODS_PASSWORD=<password> wtsi-hgi/baton <baton_command>

# e.g.
docker run -it -e IRODS_USERNAME="testuser" -e IRODS_HOST="192.168.99.100" -e IRODS_PORT=1247 -e IRODS_ZONE="iplant" -e IRODS_PASSWORD="mypassword" wtsi-hgi/baton baton-get
```

### Suppling configuration by mounting them
```bash
docker run -it -v <local_directory>:/root/.irods -e IRODS_PASSWORD=<password> wtsi-hgi/baton <baton_command>

# e.g.
docker run -it -v /home/you/.irods:/root/.irods -e IRODS_PASSWORD="mypassword" wtsi-hgi/baton baton-get
```

### Notes
- If an incorrect password is supplied with `IRODS_PASSWORD`, the run will terminate with a non-zero exit status.
- IRODS_PASSWORD is optional.
- If the configuration is mounted, it will not be overridden with configurations supplied using environmental variables.


## Debugging the container
The best way to find out what is going on in the container is to get a bash shell:
```bash
docker run -it -e IRODS_USERNAME="testuser" -e IRODS_HOST="192.168.99.100" -e IRODS_PORT=1247 -e IRODS_ZONE="iplant" wtsi-hgi/baton bash
```
**Do not supply a password if things are not working, as if it cannot be validated, the run will exit.**

It is possible to use [iRODs icommands](https://docs.irods.org/master/icommands/user/) to debug the container.

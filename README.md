# baton in Docker
Containerised baton version 0.16.1, configured for use with iRODs version 3.3.1.


## Building the container
### From GitHub
```bash
docker build -t wtsi-hgi/baton github.com/wtsi-hgi/docker-baton.git
```

### Locally
```bash
docker build -t wtsi-hgi/baton -f Dockerfile .
```


## Using the container
### Running
#### Suppling configuration through environmental variables
```bash
docker run -it -e IRODS_USERNAME=<username> -e IRODS_HOST=<host> -e IRODS_PORT=<port> -e IRODS_ZONE=<zone> -e IRODS_PASSWORD=<password> wtsi-hgi/baton <baton_command>

# e.g.
docker run -it -e IRODS_USERNAME="testuser" -e IRODS_HOST="192.168.99.100" -e IRODS_PORT=1247 -e IRODS_ZONE="myzone" -e IRODS_PASSWORD="mypassword" wtsi-hgi/baton baton-get
```

#### Suppling configuration by mounting them
```bash
docker run -it -v <local_directory>:/root/.irods -e IRODS_PASSWORD=<password> wtsi-hgi/baton <baton_command>

# e.g.
docker run -it -v /home/you/.irods:/root/.irods -e IRODS_PASSWORD="mypassword" wtsi-hgi/baton baton-get
```

#### Notes
- If an incorrect password is supplied with `IRODS_PASSWORD`, the run will terminate with a non-zero exit status.
- IRODS_PASSWORD is optional.
- If the configuration is mounted, it will not be overridden with configurations supplied using environmental variables.

### For testing software with a baton dependency
#### Run a iRODs testing server
The [only official iRODs server Docker image](https://hub.docker.com/r/irods/icat/) is for iRODs version 4.0.3. However, the [iRODs version 3.3.1 server Docker image](https://hub.docker.com/r/agaveapi/irods/) created by [agaveapi](https://hub.docker.com/u/agaveapi/) can be used.
```bash
docker run -d -p 1247:1247 --name=irods3.3.1 agaveapi/irods:3.3.1
```
The .irodsEnv required to connect as the preconfigured 'testuser' is:
```
irodsUserName testuser
irodsHost <your_docker_ip>
irodsPort 1247
irodsZone iplant
```

## Debugging
The best way to find out what is going on in the container is to get a bash shell:
```bash
docker run -it -e IRODS_USERNAME="testuser" -e IRODS_HOST="192.168.99.100" -e IRODS_PORT=1247 -e IRODS_ZONE="iplant" wtsi-hgi/baton bash
```
**Do not supply a password if things are not working, as if it cannot be validated, the run will exit.**

It is possible to use [iRODs icommands](https://docs.irods.org/master/icommands/user/) to debug the configuration.

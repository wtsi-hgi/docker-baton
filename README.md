# baton in Docker
[baton](https://github.com/wtsi-npg/baton) in a Docker container.

## Variants
- [baton version 0.16.1, using iRODs version 3.3.1](https://github.com/wtsi-hgi/docker-baton/tree/master/0.16.1/irods-3.3.1).
- [baton 'devel' branch, using iRODs version 3.3.1](https://github.com/wtsi-hgi/docker-baton/tree/master/devel/irods-3.3.1).


## Building the container
### From GitHub
```bash
docker build -t wtsi-hgi/baton:<variant> -f <variant>/irods-3.3.1/Dockerfile github.com/wtsi-hgi/docker-baton.git

# e.g.
docker build -t wtsi-hgi/baton:0.16.1 -f 0.16.1/irods-3.3.1/Dockerfile github.com/wtsi-hgi/docker-baton.git
```

### Locally
From the repository's root directory:
```bash
docker build -t wtsi-hgi/baton:<variant> -f <variant>/irods-3.3.1/Dockerfile .

# e.g.
docker build -t wtsi-hgi/baton:0.16.1 -f 0.16.1/irods-3.3.1/Dockerfile .
```


## Using the container
### Running
#### Suppling configuration through environmental variables
```bash
docker run -it -e IRODS_USERNAME=<username> -e IRODS_HOST=<host> -e IRODS_PORT=<port> -e IRODS_ZONE=<zone> -e IRODS_PASSWORD=<password> wtsi-hgi/baton:<variant> <baton_command>

# e.g.
docker run -it -e IRODS_USERNAME="testuser" -e IRODS_HOST="192.168.99.100" -e IRODS_PORT=1247 -e IRODS_ZONE="myzone" -e IRODS_PASSWORD="mypassword" wtsi-hgi/baton:0.16.1 baton
```

#### Suppling configuration by mounting them
```bash
docker run -it -v <local_directory>:/root/.irods -e IRODS_PASSWORD=<password> wtsi-hgi/baton:<variant> <baton_command>

# e.g.
docker run -it -v /home/you/.irods:/root/.irods -e IRODS_PASSWORD="mypassword" wtsi-hgi/baton:0.16.1 baton
```

#### Notes
- If an incorrect password is supplied with `IRODS_PASSWORD`, the run will terminate with a non-zero exit status ([unless `DEBUG` is set](#debugging)).
- `IRODS_PASSWORD` is optional. If not set, every query to the iRODS server will require authentication.
- If the configuration is mounted, it will not be overridden with configurations supplied using environmental variables.


### Testing software with a baton dependency
#### Run an iRODs testing server
The [only official iRODs server Docker image](https://hub.docker.com/r/irods/icat/) is for iRODs version 4.0.3. However, the [iRODs version 3.3.1 server Docker image](https://hub.docker.com/r/agaveapi/irods/) created by [agaveapi](https://hub.docker.com/u/agaveapi/) can be used.
```bash
docker run -d -p 1247:1247 --name=irods3.3.1 agaveapi/irods:3.3.1
```
The `.irodsEnv` required to connect as the preconfigured 'testuser' is:
```
irodsUserName testuser
irodsHost <your_docker_ip>
irodsPort 1247
irodsZone iplant
```
The password for 'testuser' is 'testuser'.

#### Test connection
```bash
docker run -it -e IRODS_USERNAME="testuser" -e IRODS_HOST=<your_docker_ip> -e IRODS_PORT=1247 -e IRODS_ZONE="iplant" -e IRODS_PASSWORD="testuser" wtsi-hgi/baton:<variant> ils
```

#### Query with baton
```bash
docker run -it -e IRODS_USERNAME="testuser" -e IRODS_HOST=<your_docker_ip> -e IRODS_PORT=1247 -e IRODS_ZONE="iplant" -e IRODS_PASSWORD="testuser" wtsi-hgi/baton:<variant> <baton_query>
```

## Debugging
The best way to find out what is going on in the container is to get a bash shell:
```bash
docker run -it -e IRODS_USERNAME=<user> -e IRODS_HOST=<host> -e IRODS_PORT=1247 -e IRODS_ZONE=<zone> wtsi-hgi/baton:<variant> bash
```
To get into a bash shell, even if your setup usually causes the run to exit, set `DEBUG` to `1`:
```bash
docker run -it -e DEBUG=1 wtsi-hgi/baton:<variant>
```

It is possible to use [iRODs icommands](https://docs.irods.org/master/icommands/user/) to debug the configuration.

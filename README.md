# baton in Docker
[baton](https://github.com/wtsi-npg/baton) in a [Docker](https://www.docker.com/) container.


## Docker Hub
A Docker Hub hosted version of this Docker image is available at: [https://hub.docker.com/r/mercury/baton/](https://hub.docker.com/r/mercury/baton/).

Please note that the tag to use for the Docker Hub image is *mercury/baton* opposed to *wtsi-hgi/baton*.


## Building the container
You will only need to explicitly build the container if you are not planning on using the Docker Hub repository.

### Variants
#### Hard-coded
- [baton version 0.16.1, using iRODs version 3.3.1](https://github.com/wtsi-hgi/docker-baton/tree/master/0.16.1/irods-3.3.1).

#### Custom
To build a custom version of baton, ``BRANCH`` and ``REPOSITORY`` must be given as [build arguments](https://docs.docker.com/engine/reference/commandline/build/#set-build-time-variables-build-arg).
- [custom baton version, using iRODs version 3.3.1](https://github.com/wtsi-hgi/docker-baton/tree/master/custom/irods-3.3.1).

### Build commands
#### From GitHub
```bash
docker build -t wtsi-hgi/baton:<tag> -f <batonVariant>/irods-3.3.1/Dockerfile github.com/wtsi-hgi/docker-baton.git

# e.g.
docker build -t wtsi-hgi/baton:0.16.1-with-irods-3.3.1 -f 0.16.1/irods-3.3.1/Dockerfile github.com/wtsi-hgi/docker-baton.git
docker build --build-arg BRANCH=0.16.1 --build-arg REPOSITORY=https://github.com/wtsi-npg/baton.git -t wtsi-hgi/baton:custom-0.16.1-with-irods-3.3.1 -f custom/irods-3.3.1/Dockerfile github.com/wtsi-hgi/docker-baton.git
```

#### Locally
From the repository's root directory:
```bash
docker build -t wtsi-hgi/baton:<tag> -f <batonVariant>/irods-3.3.1/Dockerfile .

# e.g.
docker build -t wtsi-hgi/baton:custom-0.16.1-with-irods-3.3.1 -f 0.16.1/irods-3.3.1/Dockerfile .
docker build --build-arg BRANCH=0.16.1 --build-arg REPOSITORY=https://github.com/wtsi-npg/baton.git -t wtsi-hgi/baton:custom-0.16.1-with-irods-3.3.1 -f custom/irods-3.3.1/Dockerfile .
```

Alternatively, use the convenience script:
```bash
./scripts/build.sh branch [repository=https://github.com/wtsi-npg/baton]
```


## Using the container
### Running
#### Suppling configuration through environmental variables
```bash
docker run -it -e IRODS_USERNAME=<username> -e IRODS_HOST=<host> -e IRODS_PORT=<port> -e IRODS_ZONE=<zone> -e IRODS_PASSWORD=<password> wtsi-hgi/baton:<tag> <baton_command>

# e.g.
docker run -it -e IRODS_USERNAME="rods" -e IRODS_HOST="192.168.99.100" -e IRODS_PORT=1247 -e IRODS_ZONE="iplant" -e IRODS_PASSWORD="rods" wtsi-hgi/baton:0.16.1-with-irods-3.3.1 baton
```

#### Suppling configuration by mounting them
```bash
docker run -it -v <local_directory>:/root/.irods -e IRODS_PASSWORD=<password> wtsi-hgi/baton:<tag> <baton_command>

# e.g.
docker run -it -v /home/you/.irods:/root/.irods -e IRODS_PASSWORD="mypassword" wtsi-hgi/baton:0.16.1-with-irods-3.3.1 baton
```

#### Notes
- If an incorrect password is supplied with `IRODS_PASSWORD`, the run will terminate with a non-zero exit status ([unless `DEBUG` is set](#debugging)).
- `IRODS_PASSWORD` is optional. If not set, every query to the iRODS server will require authentication.
- If the configuration is mounted, it will not be overridden with configurations supplied using environmental variables.


### Testing software with a baton dependency
[test-with-baton](https://github.com/wtsi-hgi/test-with-baton) was made specifically to test software with a baton dependency. It handles all the setup of
baton and iRODS, producing a set of binaries that (in most cases) will act in exactly the same way as if baton was installed on the test machine.


### Using with a containerised instance of iRODS
The [only official iRODs server Docker image](https://hub.docker.com/r/irods/icat/) is for iRODs version 4.0.3. However, the [iRODs version 3.3.1 server Docker image](https://hub.docker.com/r/agaveapi/irods/) created by [agaveapi](https://hub.docker.com/u/agaveapi/) can be used.
```bash
docker run -d -p 1247:1247 --name=irods3.3.1 agaveapi/irods:3.3.1
```
The `.irodsEnv` required to connect as the preconfigured 'rods' administrator user is:
```
irodsUserName rods
irodsHost <your_docker_ip>
irodsPort 1247
irodsZone iplant
```
The password for 'rods' is 'rods'.

##### Test connection
```bash
docker run -it -e IRODS_USERNAME="rods" -e IRODS_HOST=<your_docker_ip> -e IRODS_PORT=1247 -e IRODS_ZONE="iplant" -e IRODS_PASSWORD="rods" wtsi-hgi/baton:<tag> ils
```

##### Query with baton
```bash
docker run -it -e IRODS_USERNAME="rods" -e IRODS_HOST=<your_docker_ip> -e IRODS_PORT=1247 -e IRODS_ZONE="iplant" -e IRODS_PASSWORD="rods" wtsi-hgi/baton:<tag> <baton_query>
```

## Debugging
The best way to find out what is going on in the container is to get a bash shell:
```bash
docker run -it -e IRODS_USERNAME=<user> -e IRODS_HOST=<host> -e IRODS_PORT=1247 -e IRODS_ZONE=<zone> wtsi-hgi/baton:<tag> bash
```
To get into a bash shell, even if your setup usually causes the run to exit, set `DEBUG` to `1`:
```bash
docker run -it -e DEBUG=1 wtsi-hgi/baton:<tag>
```

It is possible to use [iRODs icommands](https://docs.irods.org/master/icommands/user/) to debug the configuration.

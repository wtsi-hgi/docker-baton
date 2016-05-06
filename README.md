# baton in Docker
[baton](https://github.com/wtsi-npg/baton) in a [Docker](https://www.docker.com/) container.


## Variants
Docker Hub hosted versions of some of these Docker images are available at:
[https://hub.docker.com/r/mercury/baton/](https://hub.docker.com/r/mercury/baton/). The custom version builds are not on
Dockerhub as it does not support the use of build arguments. The versions that are not tied to a specific commit (e.g.
ones linked to a branch) are not hosted on Dockerhub as the commit used is determined at build time.

### Hard-coded
- [baton version 0.16.1, using iRODs version 3.3.1](https://github.com/wtsi-hgi/docker-baton/tree/master/0.16.1/irods-3.3.1).
- [baton version 0.16.2, using iRODs version 3.3.1](https://github.com/wtsi-hgi/docker-baton/tree/master/0.16.2/irods-3.3.1).
- [baton version 0.16.2, using iRODs version 4.1.8](https://github.com/wtsi-hgi/docker-baton/tree/master/0.16.2/irods-4.1.8).
- [baton version 0.16.3, using iRODs version 3.3.1](https://github.com/wtsi-hgi/docker-baton/tree/master/0.16.3/irods-3.3.1).
- [baton version 0.16.3, using iRODs version 4.1.8](https://github.com/wtsi-hgi/docker-baton/tree/master/0.16.3/irods-4.1.8).
- [baton development ("devel") branch, using iRODs version 3.3.1](https://github.com/wtsi-hgi/docker-baton/tree/master/devel/irods-3.3.1) (not on Dockerhub).
- [baton development ("devel") branch, using iRODs version 4.1.8](https://github.com/wtsi-hgi/docker-baton/tree/master/devel/irods-4.4.8) (not on Dockerhub).

### Custom
To build a custom version of baton, ``BRANCH`` (either tag or branch name) and ``REPOSITORY`` must be given as 
[build arguments](https://docs.docker.com/engine/reference/commandline/build/#set-build-time-variables-build-arg).
- [custom baton version, using iRODs version 3.3.1](https://github.com/wtsi-hgi/docker-baton/tree/master/custom/irods-3.3.1) (not on Dockerhub).
- [custom baton version, using iRODs version 4.1.8](https://github.com/wtsi-hgi/docker-baton/tree/master/custom/irods-4.1.8) (not on Dockerhub).


## Building the container
(You will only need to explicitly build the container if you are not using images from the Docker Hub repository.)

Before building a specific baton image, you must first build the corresponding base image:
- For baton using iRODS 3.3.1:
```bash
docker build -t mercury/baton:base-for-baton-with-irods-3.3.1 base/irods-3.3.1
```
- For baton using iRODS 4.1.8:
```bash
docker build -t mercury/baton:base-for-baton-with-irods-4.1.8 base/irods-4.1.8
```

Then, to build the baton image: 
```bash
docker build -t mercury/baton:x.xx.x-with-irods-x.x.x x.xx.x/irods-x.x.x

# e.g.
docker build -t mercury/baton:0.16.2-with-irods-4.1.8 0.16.2/irods-4.1.8
docker build --build-arg BRANCH=0.16.1 --build-arg REPOSITORY=https://github.com/wtsi-npg/baton.git -t mercury/baton:custom-0.16.1-with-irods-3.3.1 custom/irods-3.3.1
```

## Using the container
### Running
#### Supplying configuration through environmental variables
```bash
docker run -it -e IRODS_USERNAME=<username> -e IRODS_HOST=<host> -e IRODS_PORT=<port> -e IRODS_ZONE=<zone> -e IRODS_PASSWORD=<password> mercury/baton:<tag> <baton_command>

# e.g.
docker run -it -e IRODS_HOST="192.168.99.100" -e IRODS_PORT=1247 -e IRODS_USERNAME="rods" -e IRODS_ZONE="iplant" -e IRODS_PASSWORD="rods" mercury/baton:0.16.1-with-irods-3.3.1 baton
docker run -it --link icat:icat -e IRODS_HOST="icat" -e IRODS_PORT=1247 -e IRODS_USERNAME="rods" -e IRODS_ZONE="testZone" -e IRODS_PASSWORD="irods123" mercury/baton:0.16.2-with-irods-4.1.8 baton
```

#### Suppling configuration by mounting them
```bash
docker run -it -v <local_directory>:/root/.irods -e IRODS_PASSWORD=<password> mercury/baton:<tag> <baton_command>

# e.g.
docker run -it -v /home/you/.irods:/root/.irods -e IRODS_PASSWORD="mypassword" mercury/baton:0.16.1-with-irods-3.3.1 baton
```

#### Notes
- If an incorrect password is supplied with `IRODS_PASSWORD`, the run will terminate with a non-zero exit status 
([unless `DEBUG` is set](#debugging)).
- `IRODS_PASSWORD` is optional; a `.irodsA` file may be mounted instead. If neither, the first query to the iRODS server 
will require authentication.
- If the configuration is mounted, it will not be overridden with configurations supplied using environmental variables.


### Testing software with a baton dependency
[test-with-baton](https://github.com/wtsi-hgi/test-with-baton) was made specifically to test software with a baton 
dependency. It handles all the setup of baton and iRODS, producing a set of binaries that will act in exactly the same 
way as if baton was installed on the test machine.


### Using with a containerised instance of iRODS
If you wish to try baton with a test instance of iRODS, [these iRODs version 3.3.1 and 4.1.8 server Docker images]
(https://hub.docker.com/r/mercury/icat/) can be used.


## Debugging
The best way to find out what is going on in the container is to go into a shell. To get into a shell, even if your 
iRODS connection setup has a problem, set `DEBUG` to `1`:
```bash
docker run -it -e DEBUG=1 mercury/baton:<tag> bash
```
To bypass the setup script all together:
```bash
docker run -it --entrypoint=bash mercury/baton:<tag>
```

It is possible to use [iRODs icommands](https://docs.irods.org/master/icommands/user/) to debug the configuration.

# baton in Docker
## Building the container
```bash
docker build -t hgi/baton -f Dockerfile
```

## Using the container
### Starting the baton daemon
```bash
docker run -d -name baton_daemon hgi/baton -e iRODS_CONFIG=something
```
### Using containerised baton
```bash
docker exec baton_daemon baton --version
```

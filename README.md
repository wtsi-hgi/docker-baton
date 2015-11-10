# Baton in Docker
## Building the container
```bash
docker build -t hgi/baton -f Dockerfile
```

## Using the container
```bash
docker run -d -name baton_daemon hgi/baton -e iRODS_CONFIG=something
```


To run baton command:
```bash
docker exec baton_daemon baton --version
```

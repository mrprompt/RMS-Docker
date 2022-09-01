# RMS - Docker

Docker container to run RMS project.


## Building

```console
docker build -t rms .
```

## Running

```console
docker run -d -p 6080:80 --name rms -v /RMS_data:/root/RMS_data -v /dev/shm:/dev/shm rms
```

Open VNC to your container IP or access `http://localhost:6080`




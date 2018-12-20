# RMS - Docker

Docker container to run RMS project.


## Building

```console
docker build -t RMS .
```

## Running

```console
docker run -it --rm --name rms -v /RMS_data:/root/RMS_data RMS
```

Open VNC to your container IP or access `http://localhost:6079`


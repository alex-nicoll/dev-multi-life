# multi-life-dev
This repo packages up my [multi-life](https://github.com/alex-nicoll/multi-life) development environment as a Docker image, allowing it to be deployed quickly on Linux, Windows, and macOS. I made this mostly to get familiar with Docker.

The environment includes Debian bullseye, Go, Go static analysis tools, Vim, some useful Vim plugins and configuration, and more.

## Requirements

- amd64 architecture
- git
- [Docker](https://docs.docker.com/get-docker/)
- terminal with Solarized Dark color palette
  - This can be achieved on Windows by installing Microsoft Terminal.

## Installation

1. Clone [multi-life](https://github.com/alex-nicoll/multi-life).
2. Run the following in a shell:
```
docker run --rm -it \
-v ~/multi-life:/root/multi-life \
-v ~/.gitconfig:/root/.gitconfig \
-v ~/.ssh:/root/.ssh \
-v vol-multi-life-dev:/root/.host \
-p 127.0.0.1:8080:8080 \
alexnicoll/multi-life-dev
```

Replace `~/multi-life` with the path to the cloned multi-life repository. The `-v ~/multi-life:/root/multi-life` argument bind mounts the directory into the container. Any changes made in the container will be reflected on the host. `.gitconfig` and `.ssh` are bind mounted as well; these lines can be removed if they are unwanted.

The `-v vol-multi-life-dev:/root/.host` argument mounts a Docker volume named vol-multi-life-dev to /root/.host, creating the volume if it doesn't exist. The volume stores the bash history, Go build cache, and Go module cache. The volume can be renamed, but the mount point inside the container must remain /root/.host.

The `-p 127.0.0.1:8080:8080` argument maps port 8080 of the container to port 8080 on 127.0.0.1 of the host. To allow external connections (e.g., to develop and test the app on a server), remove the `127.0.0.1`.

## Notes

When building the image using the `docker build` command, the plugin installation layer may take a very long time to complete, and will have no visible output, appearing to hang. The reason for the lack of output is that Vim is being run in silent (batch) mode. This is because when Vim is run in normal mode, the editor opens up and makes a mess of the `docker build` output. If you would like to run Vim in normal mode and see plugin installation progress, remove the `-E` and `-s` flags from the `vim` command in the Dockerfile:
```
RUN ["vim", "-u", "plugins.vim", "+PlugInstall", "+qall"]
```

# multi-life-dev
This repo packages up my [multi-life](https://github.com/alex-nicoll/multi-life) development environment as a Docker image, allowing it to be deployed quickly on Linux, Windows, and macOS. I made this mostly to get familiar with Docker.

The environment includes Debian bullseye, Go, Go static analysis tools, Vim, some useful Vim plugins and configuration, and more.

## Requirements

- amd64 architecture
- [Docker](https://docs.docker.com/get-docker/)
- terminal with Solarized Dark color palette
  - This can be achieved on Windows by installing Microsoft Terminal.

## Installation

```
docker run --rm -it \
-v vol-multi-life-dev:/root/host \
-v vol-multi-life-dev-staticcheck:/root/.cache/staticcheck \
-v ~/.gitconfig:/root/.gitconfig \
-v ~/.ssh:/root/.ssh \
-p 127.0.0.1:8080:8080 \
alexnicoll/multi-life-dev
```

`-v vol-multi-life-dev:/root/host` mounts a Docker volume named vol-multi-life-dev to /root/host, creating the volume if it doesn't exist. This is where you should `git clone` multi-life. The volume also stores the bash history, Go build cache, and Go module cache. The volume can be renamed, but the mount point inside the container must remain /root/host.

`-v vol-multi-life-dev-staticcheck:/root/.cache/staticcheck` stores the staticcheck cache in a volume. A separate volume is needed because the location of the cache can't be changed to be inside /root/host.

`-v ~/.gitconfig:/root/.gitconfig` and `-v ~/.ssh/root/.ssh` bind mount git configuration and SSH keys into the container. Any changes made in the container will be reflected on the host. These lines can be removed if they are unwanted.

`-p 127.0.0.1:8080:8080` maps port 8080 of the container to port 8080 on 127.0.0.1 of the host. To allow external connections (e.g., to develop and test the app on a server), remove the `127.0.0.1`.

## Notes

When building the image using the `docker build` command, the plugin installation layer may take a very long time to complete, and will have no visible output, appearing to hang. The reason for the lack of output is that Vim is being run in silent (batch) mode. This is because when Vim is run in normal mode, the editor opens up and makes a mess of the `docker build` output. If you would like to run Vim in normal mode and see plugin installation progress, remove the `-E` and `-s` flags from the `vim` command in the Dockerfile:
```
RUN ["vim", "-u", "plugins.vim", "+PlugInstall", "+qall"]
```

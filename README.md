# go-editor

This repository contains a Dockerfile that adds Vim, gopls, and some configuration on top of a Go build environment.

## Motivation

I currently build Go code for a project inside a container, but use Vim + [vim-go](https://github.com/fatih/vim-go) as an editor outside the container. This creates the problem of the build process and editor relying on different Go installations. The solution I arrived at is to run the editor inside a container, on top of the same image as the build process. This repository could be used as a template by others wishing to do the same thing.

## Requirements

- amd64 architecture
- [Docker](https://docs.docker.com/get-docker/)

## Usage

### 1: Pull and run the image

```
docker run --rm -it \
-v ~/repo:/root/repo \
-w /root/repo \
-v ~/.vimrc:/root/.vimrc \
-v vol-go-editor-vim:/root/.vim \
-v vol-go-editor:/root/host \
-e TERM=xterm-256color \
alexnicoll/go-editor
```

`-v ~/repo:/root/repo` bind mounts a Go repo into the container, and `-w /root/repo` sets the working directory when the container starts.

`-v ~/.vimrc:/root/.vimrc` bind mounts the home directory's .vimrc into the container. This could point to a Go-specific .vimrc instead of ~/.vimrc.

`-v vol-go-editor-vim:/root/.vim` mounts a Docker volume named vol-go-editor-vim to /root/.vim, creating the volume if it doesn't exist. This has the effect of persisting the Vim plugin manager and plugins after the container is destroyed.

`-v vol-go-editor:/root/host` mounts a volume containing the Go build cache and Go module cache. These are used under the hood by gopls. The volume can be renamed, but the mount point must be the same as the one referenced in the Dockerfile (/root/host).

`-e TERM=xterm-256color` is needed in order to get plugins like [vim-colors-solarized](https://github.com/altercation/vim-colors-solarized) to work correctly. It can be removed if there is no such plugin.

Note: Instead of bind mounting .vimrc and .vim, we could have a fixed .vimrc and plugins already installed as part of the image. Bind mounting addresses the use case of multiple people with different Vim configurations using the same image.

### 2: Set up Vim

1. Install a plugin manager like [vim-plug](https://github.com/junegunn/vim-plug).
2. Add vim-go (or whichever plugins are desired) to .vimrc. E.g., if using vim-plug:
```
call plug#begin('~/.vim/plugged')
Plug 'fatih/vim-go', { 'tag': 'v1.28' }
call plug#end()
```
3. Restart Vim or run `:source %` to reload the .vimrc, if necessary.
4. Install plugins. E.g., if using vim-plug, run :PlugInstall. Then restart Vim.

### 3: Go code

You now have everything necessary to edit code inside a container. You can exit and destroy the container by logging out, and recreate it by running the `docker run` command again. You can also detach from the container with CTRL-P+CTRL-Q, and reattach with `docker attach <container name>`.

### Appendix: Adding features to vim-go

If using vim-go, note that not all of its dependencies are included in the image. gopls is installed, which enables you to get around, write, and refactor Go code, but advanced features like debugging won't work. If more features are desired, then their dependencies need to be built into the image. Alternatively, image users can do the following to enable features without modifying the Dockerfile:

1. Add something like this to .vimrc:
```
let g:go_bin_path = "/root/host/go/bin"
```
This causes vim-go to install binaries to the specified directory (see :h g:go\_bin\_path for more details). If the `docker run` command from step 1 was used verbatim, then this particular directory is inside a volume.

2. Now you can run the following to add debugging support:
```
:GoInstallBinaries dlv
```

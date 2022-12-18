# multi-life-dev
The purpose of this repo is to create a reusable Docker image of my [multi-life](https://github.com/alex-nicoll/multi-life) development environment. This is mostly just an experiment, but in theory it would allow one to quickly deploy the environment on any OS.

The image being built currently consists of Debian bullseye, Go, Vim, and some useful Vim plugins and configuration. For the list of plugins see [plugins.vim](https://github.com/alex-nicoll/multi-life-dev/blob/main/plugins.vim).

When building the image using the `docker build` command, the plugin installation layer may take a very long time to complete, and will have no visible output, appearing to hang. The reason for the lack of output is that Vim is being run in silent (batch) mode. This is because when Vim is run in normal mode, the editor opens up and makes a mess of the `docker build` output. If you would like to run Vim in normal mode and see plugin installation progress, remove the `-E` and `-s` flags from the `vim` command in the Dockerfile:
```
RUN ["vim", "-u", "plugins.vim", "+PlugInstall", "+qall"]
```

To use the image, one will need to have git and Docker installed, and be running a terminal set to the Solarized Dark color palette.

The built image is not yet hosted in a registry, but it will be soon.

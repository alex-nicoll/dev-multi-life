FROM golang:1.19.4-bullseye

# Install static analysis tools.
RUN ["go", "install", "github.com/mgechev/revive@latest"]
RUN ["go", "install", "honnef.co/go/tools/cmd/staticcheck@latest"]
RUN ["go", "install", "github.com/kisielk/errcheck@latest"]

RUN apt-get update && apt-get install --yes vim

WORKDIR /root

# Install Vim plugins and .vimrc
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
COPY plugins.vim .
RUN ["vim", "-E", "-s", "-u", "plugins.vim", "+PlugInstall", "+qall"]
COPY .vimrc .

# Set TERM such that the solarized Vim plugin works correctly.
ENV TERM xterm-256color

# /root/.host must be mapped to a volume at run time.
# Store bash history in /root/.host
RUN /bin/bash -c 'echo -e "\nHISTFILE=\"/root/.host/bash_history\"" >> .bashrc'
# Clear the Go build cache and module cache of data created while installing
# vim-go. We no longer need it, and the cache locations are about to change.
RUN ["rm", "-r", "/root/.cache/go-build", "/go/pkg/mod"]
# Remove .cache if it is now empty.
RUN /bin/bash -c 'rm -d /root/.cache || true'
# Store the Go build cache and module cache in /root/.host
RUN ["go", "env", "-w", "GOCACHE=/root/.host/go-cache/build", "GOMODCACHE=/root/.host/go-cache/mod"]

# Enable git completions.
RUN /bin/bash -c 'echo -e ". /usr/share/bash-completion/completions/git" >> .bashrc'

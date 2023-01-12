FROM golang:1.19.4-bullseye

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

# Install multi-life Go dependencies.
RUN curl \
    -LO https://raw.githubusercontent.com/alex-nicoll/multi-life/main/go.mod \
    -LO https://raw.githubusercontent.com/alex-nicoll/multi-life/main/go.sum && \
    go mod download && \
    rm go.mod go.sum

# Store history /root/host, which should have a volume mounted to it at run time.
RUN /bin/bash -c 'echo -e "\nHISTFILE=\"/root/host/.bash_history\"" >> .bashrc'

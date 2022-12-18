FROM golang:1.19.4-bullseye
RUN ["apt-get", "update"]
RUN ["apt-get", "install", "vim", "--yes"]
WORKDIR /root
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
COPY plugins.vim .
RUN ["vim", "-E", "-s", "-u", "plugins.vim", "+PlugInstall", "+qall"]
COPY .vimrc .
ENV TERM xterm-256color

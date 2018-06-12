FROM ubuntu:18.04

LABEL maintainer="zhanghf@zailingtech.com"

ENV TZ "Asia/Shanghai"

COPY install.sh /usr/local/

RUN /usr/local/install.sh

COPY .vimrc /root/
COPY .zshrc /root/
COPY .tmux.conf /root/

CMD zsh

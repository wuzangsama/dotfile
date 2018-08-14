FROM ubuntu:18.04

LABEL maintainer="zhanghf@zailingtech.com"

# 设置go相关环境变量
ENV GOLANG_VERSION 1.10.3
ENV GOLANG_ARCH 'linux-amd64'
ENV GOPATH /go
ENV GOROOT /usr/local/go
ENV PATH $GOPATH/bin:$GOROOT/bin:$GOROOT/pkg/tool/linux_amd64:$PATH
# 设置maven相关环境变量
ENV M2_HOME /usr/local/maven
ENV M2 $M2_HOME/bin
ENV PATH $M2:$PATH
# 设置locale，进入终端可以输入中文
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
# 设置容器时区
ENV TZ "Asia/Shanghai"

RUN apt update -y \
# 安装工具
    && apt install -y build-essential \
    && apt install -y gdb \
    && apt install -y valgrind \
    && apt install -y git \
    && apt install -y man \
    && apt install -y clang \
    && apt install -y libclang-dev \
    && apt install -y cmake \
    && apt install -y wget \
    && apt install -y curl \
    && apt install -y silversearcher-ag \
    && apt install -y tmux \
    && apt install -y zsh \
    && rm -rf /var/lib/apt/lists/*
RUN git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    && chsh -s /bin/zsh
# 安装vim需要的工具包
RUN apt update -y \
    && echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt install -y openssl \
    && apt install -y ctags \
    && apt install -y cscope \
    && apt install -y python2.7 \
    && apt install -y python2.7-dev \
    && apt install -y python3.7 \
    && apt install -y python3.7-dev \
    && apt install -y ruby \
    && apt install -y ruby-dev \
    && apt install -y lua5.1 \
    && apt install -y liblua5.1-0-dev \
    && apt install -y luajit \
    && apt install -y libluajit-5.1-dev \
    && apt install -y perl \
    && apt install -y libperl-dev \
    && apt install -y tcl \
    && apt install -y tcl-dev \
    && apt install -y libtcl8.6 \
    && apt install -y libncurses5-dev \
    && apt install -y libtool \
    && apt install -y automake \
    && rm -rf /var/lib/apt/lists/*
# 安装java(暂时不设置环境变量)
RUN apt update -y \
    && apt install -y software-properties-common \
    && add-apt-repository -y ppa:webupd8team/java \
    && apt-get update \
    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
    && apt-get install -y oracle-java8-installer \
    && update-java-alternatives -s java-8-oracle \
    && rm -rf /var/lib/apt/lists/*
# 安装go
RUN golang_download_url="https://golang.org/dl/go${GOLANG_VERSION}.${GOLANG_ARCH}.tar.gz" \
    && wget -O go.tgz "$golang_download_url" \
    && tar -C /usr/local -xzf go.tgz \
    && rm go.tgz \
    && go version \
    && go get github.com/klauspost/asmfmt/cmd/asmfmt \
    && go get github.com/derekparker/delve/cmd/dlv \
    && go get github.com/kisielk/errcheck \
    && go get github.com/davidrjenni/reftools/cmd/fillstruct \
    && go get github.com/nsf/gocode \
    && go get github.com/rogpeppe/godef \
    && go get github.com/zmb3/gogetdoc \
    && go get golang.org/x/tools/cmd/goimports \
    && go get github.com/golang/lint/golint \
    && go get github.com/alecthomas/gometalinter \
    && go get github.com/fatih/gomodifytags \
    && go get golang.org/x/tools/cmd/gorename \
    && go get github.com/jstemmer/gotags \
    && go get golang.org/x/tools/cmd/guru \
    && go get github.com/josharian/impl \
    && go get github.com/dominikh/go-tools/cmd/keyify \
    && go get github.com/fatih/motion \
    && go get honnef.co/go/tools/cmd/megacheck \
    && go get -u github.com/golang/dep/cmd/dep \
    && go get -u github.com/cweill/gotests/...
# 安装maven
RUN wget -O maven.tgz http://www.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz \
    && tar -C /usr/local -xzf maven.tgz \
    && rm maven.tgz \
    && ln -s /usr/local/apache-maven-3.5.4/ /usr/local/maven
# 安装vim
RUN git clone https://github.com/vim/vim.git \
    && cd vim \
    && git checkout v8.1.0280 \
    && ./configure --prefix=/usr \
        --with-features=huge \
        --enable-multibyte \
        --enable-cscope=yes \
        --enable-luainterp=yes \
        --with-luajit \
        --enable-rubyinterp=yes \
        --with-ruby-command=/usr/bin/ruby \
        --enable-perlinterp \
        --enable-pythoninterp=yes \
        --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu/ \
        --enable-python3interp=yes \
        --with-python3-config-dir=/usr/lib/python3.7/config-3.7m-x86_64-linux-gnu \
        --enable-tclinterp=yes \
        --enable-gui=auto \
    && make \
    && make install \
    && cd .. \
    && rm -rf vim/
# 安装rtags
RUN wget https://andersbakken.github.io/rtags-releases/rtags-2.16.tar.gz \
    && tar zxvf rtags-2.16.tar.gz \
    && cd rtags-2.16 \
    && cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 . \
    && make \
    && make install \
    && cd .. \
    && rm -rf rtags-2.16/ \
    && rm -rf rtags-2.16.tar.gz
# 安装bear用于通过Makefile生成JSON compilation database
RUN git clone https://github.com/rizsotto/Bear.git \
    && cd Bear \
    # && git checkout 2.2.1 \
    && cmake . \
    && make all \
    && make install \
    && cd .. \
    && rm -rf Bear

COPY .vimrc /root/
COPY .tmux.conf /root/
COPY .zshrc /root/

#work dir
WORKDIR /work

#cmd
CMD zsh

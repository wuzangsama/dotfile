#/bin/bash
set -e

# 语言相关
apt-get update
apt-get install -y locales
localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# 安装zsh并修改shell为zsh
apt install -y git
apt install -y zsh
git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
chsh -s /bin/zsh

# 安装一些工具类软件
apt install -y build-essential
apt install -y libtool
apt install -y automake
apt install -y gdb
apt install -y cmake
apt install -y clang
apt install -y libclang-dev
apt install -y valgrind
apt install -y ctags
apt install -y cscope
apt install -y openssl
apt install -y silversearcher-ag
apt install -y tmux
apt install -y wget
apt install -y curl
apt install -y man

# 安装java(暂时不设置环境变量)
apt install -y software-properties-common
add-apt-repository -y ppa:webupd8team/java
apt-get update
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
apt-get install -y oracle-java8-installer
update-java-alternatives -s java-8-oracle

# 安装maven(环境变量设置在zshrc中)
wget -O maven.tgz http://www.apache.org/dist/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz
tar -C /usr/local -xzf maven.tgz
ln -s /usr/local/apache-maven-3.5.3/ /usr/local/maven
rm maven.tgz

# 安装编译vim的依赖
apt install -y ruby
apt install -y ruby-dev
apt install -y lua5.1
apt install -y liblua5.1-0-dev
apt install -y luajit
apt install -y libluajit-5.1-dev
apt install -y perl
apt install -y libperl-dev
apt install -y tcl
apt install -y tcl-dev
apt install -y libtcl8.6
apt install -y libncurses5-dev
apt install -y python
apt install -y python-dev
apt install -y python3
apt install -y python3-dev

# 清理
rm -rf /var/lib/apt/lists/*

# 安装go
export GOROOT=/usr/local/go
export GOPATH=/go
export PATH=$GOROOT/bin:$GOROOT/pkg/tool/linux_amd64:$GOPATH/bin:$PATH
export go_download_url=https://golang.org/dl/go1.10.3.linux-amd64.tar.gz
wget -O go.tgz "$go_download_url"
tar -C /usr/local -xzf go.tgz
rm go.tgz
go version
go get -u github.com/klauspost/asmfmt/cmd/asmfmt
go get -u github.com/derekparker/delve/cmd/dlv
go get -u github.com/kisielk/errcheck
go get -u github.com/davidrjenni/reftools/cmd/fillstruct
go get -u github.com/nsf/gocode
go get -u github.com/rogpeppe/godef
go get -u github.com/zmb3/gogetdoc
go get -u golang.org/x/tools/cmd/goimports
go get -u github.com/golang/lint/golint
go get -u github.com/alecthomas/gometalinter
go get -u github.com/fatih/gomodifytags
go get -u golang.org/x/tools/cmd/gorename
go get -u github.com/jstemmer/gotags
go get -u golang.org/x/tools/cmd/guru
go get -u github.com/josharian/impl
go get -u github.com/dominikh/go-tools/cmd/keyify
go get -u github.com/fatih/motion
go get -u github.com/golang/dep/cmd/dep
go get -u github.com/cweill/gotests/...

# 安装vim
cd /usr/local/src
git clone https://github.com/vim/vim.git
cd vim
git checkout v8.1.0042
./configure --prefix=/usr \
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
    --with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \
    --enable-tclinterp=yes \
    --enable-gui=auto
make
make install
cd ..
rm -rf vim

# 安装rtags
wget https://andersbakken.github.io/rtags-releases/rtags-2.16.tar.gz
tar zxvf rtags-2.16.tar.gz
cd rtags-2.16
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .
make
make install
cd ..
rm -rf rtags-2.16/
rm -rf rtags-2.16.tar.gz

# 安装bear
git clone https://github.com/rizsotto/Bear.git
cd Bear
# git checkout 2.2.1
cmake .
make all
make install
cd ..
rm -rf Bear

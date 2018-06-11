#/bin/bash

# 语言相关
sudo apt-get update
sudo apt-get install -y locales
sudo localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# 安装一些工具类软件
sudo apt install -y gcc
sudo apt install -y g++
sudo apt install -y make
# sudo apt install -y libtool
# sudo apt install -y automake
sudo apt install -y gdb
sudo apt install -y cmake
sudo apt install -y clang
# sudo apt install -y libclang-dev
sudo apt install -y valgrind
sudo apt install -y ctags
# sudo apt install -y cscope
sudo apt install -y openssl
sudo apt install -y git
sudo apt install -y silversearcher-ag
sudo apt install -y tmux
sudo apt install -y wget
sudo apt install -y curl
sudo apt install -y man
sudo apt install -y zsh
sudo git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
sudo chsh -s /bin/zsh

# 安装编译vim的依赖
sudo apt install -y ruby
sudo apt install -y ruby-dev
sudo apt install -y lua5.1
sudo apt install -y liblua5.1-0-dev
sudo apt install -y luajit
sudo apt install -y libluajit-5.1-dev
sudo apt install -y perl
sudo apt install -y libperl-dev
sudo apt install -y tcl
sudo apt install -y tcl-dev
sudo apt install -y libtcl8.6
sudo apt install -y libncurses5-dev
sudo apt install -y python3
sudo apt install -y python3-dev

# 清理
sudo rm -rf /var/lib/apt/lists/*

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
    # --enable-pythoninterp=yes \
    # --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu/ \
    --enable-python3interp=yes \
    --with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \
    --enable-tclinterp=yes \
    --enable-gui=auto
make
sudo make install
cd ..
rm -rf vim

# 安装rtags
wget https://andersbakken.github.io/rtags-releases/rtags-2.16.tar.gz
tar zxvf rtags-2.16.tar.gz
cd rtags-2.16
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .
make
sudo make install
cd ..
rm -rf rtags-2.16/
rm -rf rtags-2.16.tar.gz

# 安装bear
git clone https://github.com/rizsotto/Bear.git
cd Bear
# git checkout 2.2.1
cmake .
make all
sudo make install
cd ..
rm -rf Bear

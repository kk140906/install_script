#!/bin/bash
###
 # @Author       : KK
 # @Date         : 2021-10-13 15:28:52
 # @LastEditTime : 2021-10-21 14:19:47
 # @LastEditors  : KK
 # @Description  : Install vim plugin
 # @FilePath     : \debian_install_script\vim_plugin.sh
### 


set -e
set -o pipefail
SCRIPT_PATH=$(dirname $0)
if [[ ${SCRIPT_PATH} == "." ]]
then 
    SCRIPT_PATH=$(pwd)
fi

source ${SCRIPT_PATH}/common.sh

cd ~

apt_updated

# install vim-plug
printf_color "Install vim plug" ${TEXT_GREEN}
VIM_PLUG_SCRIPT_PATH=${HOME}/.vim/autoload/plug.vim
backup_exist ${VIM_PLUG_SCRIPT_PATH}
# https://gitee.com/yzymickey/vim-plug/raw/master/plug.vim
bash -c "curl -fLo ${VIM_PLUG_SCRIPT_PATH} --create-dirs ${GITHUB_MIRROR_RAW}/junegunn/vim-plug/master/plug.vim"
replace ${GITHUB_SRC} ${GITHUB_MIRROR} ${VIM_PLUG_SCRIPT_PATH}


# rebuild vim with python3
# https://github.com/ycm-core/YouCompleteMe/wiki/Building-Vim-from-source
printf_color "Rebuild vim with python3" ${TEXT_GREEN}

sudo apt remove vim vim-runtime gvim -y
sudo apt autoremove -y

sudo apt install libncurses5-dev libgtk2.0-dev libatk1.0-dev \
libcairo2-dev libx11-dev libxpm-dev libxt-dev \
python3-dev lua5.2 liblua5.2-dev libperl-dev git -y

git clone --depth=1 ${GITHUB_MIRROR}/vim/vim.git /tmp/vim
cd ${VIM_TEMP_PATH}
./configure --with-features=huge \
            --enable-multibyte \
            --enable-python3interp=yes \
            --with-python3-config-dir=$(python3-config --configdir) \
            --enable-perlinterp=yes \
            --enable-luainterp=yes \
            --enable-gui=gtk2 \
            --enable-cscope \
            --prefix=${VIM_BIN_REBUILD_PATH%/b*}
sudo make -j4 && sudo make install

if [[ -L ${VIM_BIN_PATH} ]]
then 
    sudo rm -rf ${VIM_BIN_PATH}
fi
sudo ln -s ${VIM_BIN_REBUILD_PATH} ${VIM_BIN_PATH}
cd ~
sudo rm -rf ${VIM_TEMP_PATH}


printf_color "Install youcompleteme plug" ${TEXT_GREEN}
# make sure the dns is up to date, from dnschecker.org
update_hosts "bitbucket.org" "104.192.141.1"

# Install vim YouCompleteMe plugin
# There is a simple solution to install youcompleteme, just install from the debian's repository package.
# but this solution is not a offical install solution,and the development people don't support any third package.
# https://github.com/ycm-core/YouCompleteMe/issues/3874
# https://stackoverflow.com/questions/33982603/vim-youcompleteme-not-working-in-debian-jessie
# sudo apt install vim-youcompleteme -y
# vam install youcompleteme 
# If don't work ,uncomment this.
# And add 'let g:ycm_global_ycm_extra_conf = "~/.vim/manually/YouCompleteMe/ycm_extra_conf.py"' to .vimrc file
# mkdir -p ${VIM_PLUGIN_MANUAL_PATH}/YouCompleteMe
# cp /usr/lib/ycmd/ycm_extra_conf.py ${VIM_PLUGIN_MANUAL_PATH}/YouCompleteMe/ycm_extra_conf.py
backup_exist ${VIM_PLUGIN_MANUAL_PATH}/YouCompleteMe
git clone ${GITHUB_MIRROR}/ycm-core/YouCompleteMe.git ${VIM_PLUGIN_MANUAL_PATH}/YouCompleteMe
walk_submodule ${VIM_PLUGIN_MANUAL_PATH}/YouCompleteMe
replace ${GITHUB_SRC} ${GITHUB_MIRROR} ${VIM_PLUGIN_MANUAL_PATH}/YouCompleteMe/third_party/ycmd/cpp/CMakeLists.txt
replace ${GITHUB_SRC} ${GITHUB_MIRROR_DOWN} ${VIM_PLUGIN_MANUAL_PATH}/YouCompleteMe/third_party/ycmd/cpp/ycm/CMakeLists.txt
replace ${GITHUB_SRC} ${GITHUB_MIRROR_DOWN} ${VIM_PLUGIN_MANUAL_PATH}/YouCompleteMe/third_party/ycmd/build.py
export GOPROXY=${GO_PROXY}
export RUSTUP_DIST_SERVER=${RUSTUP_DIST_MIRROR}
export RUSTUP_UPDATE_ROOT=${RUSTUP_UPDATE_MIRROR}

# install  youcompleteme build environment
sudo apt install build-essential cmake vim-nox python3-dev -y
sudo apt install mono-complete golang nodejs default-jdk npm -y

python3 ${VIM_PLUGIN_MANUAL_PATH}/YouCompleteMe/install.py --all

wait
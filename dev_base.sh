#!/bin/bash
###
 # @Author       : KK
 # @Date         : 2021-10-14 09:05:57
 # @LastEditTime : 2021-10-21 14:18:53
 # @LastEditors  : KK
 # @Description  : Install some tools of system/development/runtime environment 
 # @FilePath     : \debian_install_script\dev_base.sh
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

printf_color "Install some system tools." ${TEXT_GREEN}
sudo apt install man fontconfig unzip curl wget figlet htop exa rsync -y

# copy meslo ttf to  default system-wide fonts
# sudo cp -r Meslo /usr/share/fonts/truetype/ && fc-cache

# c++ c development environment 
printf_color "Install c/c++/python/golang/node.js/java development(runtime) environment." ${TEXT_GREEN}
sudo apt update
sudo apt install git vim make cmake autoconf gcc g++ gdb python2-dev python3-pip python3-dev build-essential -y
sudo apt install mono-complete golang nodejs default-jdk npm rust -y

check_pip

if [[ -L /usr/bin/python ]]
then 
    sudo rm -rf /usr/bin/python
fi
sudo ln -s $(which python3) /usr/bin/python

wait
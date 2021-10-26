#!/bin/bash
###
 # @Author       : KK
 # @Date         : 2021-10-12 15:03:33
 # @LastEditTime : 2021-10-26 16:17:34
 # @LastEditors  : KK
 # @Description  : Install oh-my-zsh terminal
 # @FilePath     : \debian_install_script\oh_my_zsh.sh
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

# install zsh
printf_color "Install zsh terminal." ${TEXT_GREEN}
sudo apt install zsh -y

# install oh-my-zsh,the oh-my-zsh install script will change terminal
printf_color "Downloading the oh-my-zsh install script." ${TEXT_GREEN}

backup_exist  ${ZSH_INSTALL_SCRIPT_TEMP_PATH}
# bash -c "$(curl -fsSL https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh)"
wget --output-document ${ZSH_INSTALL_SCRIPT_TEMP_PATH} https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh
replace ${GITHUB_SRC} ${GITHUB_MIRROR} ${ZSH_INSTALL_SCRIPT_TEMP_PATH}
replace "exec" "\#exec" ${ZSH_INSTALL_SCRIPT_TEMP_PATH}
chmod +x ${ZSH_INSTALL_SCRIPT_TEMP_PATH}

backup_exist ${ZSH_INSTALL_PATH}
backup_exist ~/.zshrc

bash -c "${ZSH_INSTALL_SCRIPT_TEMP_PATH}" &

# wait install process done
wait

rm -rf ${ZSH_INSTALL_SCRIPT_TEMP_PATH}

# change to the zsh
check_zsh

wait
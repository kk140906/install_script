#!/bin/bash
###
 # @Author       : KK
 # @Date         : 2021-10-12 17:07:30
 # @LastEditTime : 2021-10-21 14:19:00
 # @LastEditors  : KK
 # @Description  : Install oh my zsh plugin  
 # @FilePath     : \debian_install_script\oh_my_zsh_plugin.sh
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

# change to the zsh
check_zsh

# install zsh plugins
printf_color "Downloading zsh plugins." ${TEXT_GREEN}

backup_exist ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
git clone ${GITHUB_MIRROR}/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM}/plugins/zsh-autosuggestions

backup_exist ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
git clone ${GITHUB_MIRROR}/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting

backup_exist ${ZSH_CUSTOM}/plugins/zsh-zsh-autojump
git clone ${GITHUB_MIRROR}/wting/autojump.git ${ZSH_CUSTOM}/plugins/zsh-autojump

backup_exist ${ZSH_CUSTOM}/plugins/figlet/fonts
git clone ${GITHUB_MIRROR}/xero/figlet-fonts.git ${ZSH_CUSTOM}/plugins/figlet/fonts

printf_color "Install autojump plugins." ${TEXT_GREEN}
# python3 ${ZSH_CUSTOM}/plugins/zsh-autojump/install.py # module bug

# install powerlevel10k
printf_color "Downloading zsh's powerlevel10k theme." ${TEXT_GREEN}
backup_exist ${ZSH_CUSTOM}/themes/powerlevel10k
backup_exist ~/.p10k.zsh
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM}/themes/powerlevel10k

wait
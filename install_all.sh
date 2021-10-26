#!/bin/bash
###
 # @Author       : KK
 # @Date         : 2021-10-12 14:02:35
 # @LastEditTime : 2021-10-26 16:33:13
 # @LastEditors  : KK
 # @Description  : Run all script
 # @FilePath     : \debian_install_script\install_all.sh
### 

set -e
set -o pipefail
SCRIPT_PATH=$(dirname $0)
if [[ ${SCRIPT_PATH} == "." ]]
then 
    SCRIPT_PATH=$(pwd)
fi

function change_to_user() {
    usermod -aG sudo ${1}
    mv ${SCRIPT_PATH} /home/${1}/
    cd /home/${1}
    printf "\033[31m Changing root to ${1}. Need to rerun install script from /home/${1}.\n\033[0m"
    chown -R ${1}:${1} /home/${1}/install_scirpt
    su ${1}
}

if [[ $(whoami) == "root" ]]
then 
    apt install sudo
    if [[ -n "$(which usermod)" ]]
    then 
        export PATH="/usr/sbin:${PATH}"
    fi
    # add user
    users=($(cat /etc/passwd | awk -F : '$3>=1000 && $3<=65530' | cut -f 1 -d :))
    if [[ ${#users[@]} -gt 1 ]]
    then
        num=1
        for user in ${users[@]}
        do
            printf "%d) - %s\n" ${num} "${user}"
            let num++
        done
        let num--
        read -p "Input the number of default user. [1-${num}] " var
        change_to_user ${users[${var}-1]}
    elif [[ ${#users[@]} -eq 1 ]]
    then
        change_to_user ${users[0]}
    fi
fi


source ${SCRIPT_PATH}/common.sh

cd ~

printf_color "Running ${0##*/} script." ${TEXT_CYAN} ${TEXT_BOLD} 
printf_color "Partial installation process should be carried out in sequence." ${TEXT_CYAN} ${TEXT_BOLD} 

SCRIPT_ALL=(
    apt.sh
    dev_base.sh
    tldr_python.sh
    oh_my_zsh.sh
    oh_my_zsh_plugin.sh
    oh_my_zsh_zshrc.sh
    vim_plugin.sh
    vim_vimrc.sh
)

ERROR_FILE=/tmp/install_error
function log_error() {
        echo ${1} > ${ERROR_FILE}
}

if [[ -e ${ERROR_FILE} ]]
then 
    CONTINUE_INSTALL_SCRIPT_NAME=$(cat ${ERROR_FILE})
    # CONTINUE_INSTALL_SCRIPT_NAME=$(tail -n 1 ${ERROR_FILE})
    read -p "$(printf ${TEXT_RED})Preinstall error in script ${CONTINUE_INSTALL_SCRIPT_NAME}, continue install form error script (Y/n)? $(printf ${TEXT_RESET})" opt
    case ${opt:-y} in
    y*|Y*|${null})
        ;;
    *)
        CONTINUE_INSTALL_SCRIPT_NAME=''
        ;;
    esac
fi


for shname in "${SCRIPT_ALL[@]}"
do
    if [[ ! -e ${SCRIPT_PATH}/${shname} ]] ; then continue ; fi
    if [[ (-n ${CONTINUE_INSTALL_SCRIPT_NAME}) && (${CONTINUE_INSTALL_SCRIPT_NAME} != ${shname}) ]] ; then continue ; fi
    CONTINUE_INSTALL_SCRIPT_NAME=''
    printf_color "Runing ${shname} script." ${TEXT_CYAN}
    source ${SCRIPT_PATH}/${shname} || log_error ${shname} ; exit 1
    wait
done

rm -rf ${ERROR_FILE}

printf_color "All install Done!" ${TEXT_MAGENTA}
printf_color "Configure the powerlevel10k theme, maybe need to restart terminal." ${TEXT_GREEN}
# restart zsh terminal, it will start to config the powelevel10k automatically
zsh && source ~/.zshrc
# p10k configure

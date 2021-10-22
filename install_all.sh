#!/bin/bash
###
 # @Author       : KK
 # @Date         : 2021-10-12 14:02:35
 # @LastEditTime : 2021-10-21 14:24:57
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
    source ${SCRIPT_PATH}/${shname} || (log_error ${shname} && exit 1)
    wait
done

rm -rf ${ERROR_FILE}

printf_color "All install Done!" ${TEXT_MAGENTA}
printf_color "Configure the powerlevel10k theme, maybe need to restart terminal." ${TEXT_GREEN}
# restart zsh terminal, it will start to config the powelevel10k automatically
zsh && source ~/.zshrc
# p10k configure

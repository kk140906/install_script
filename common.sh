#!/bin/bash
###
 # @Author       : KK
 # @Date         : 2021-10-14 09:05:57
 # @LastEditTime : 2021-10-22 17:01:04
 # @LastEditors  : KK
 # @Description  : In User Settings Edit
 # @FilePath     : \debian_install_script\common.sh
### 



if [[ ${COMMON_SOURCED} -ne 1 ]] 
then
    # set terminal color
    TEXT_RED="\033[31m"
    TEXT_GREEN="\033[32m"
    TEXT_YELLOW="\033[33m"
    TEXT_BLUE="\033[34m"
    TEXT_MAGENTA="\033[35m"
    TEXT_CYAN="\033[36m"
    TEXT_BOLD="\033[1m"
    TEXT_RESET="\033[0m"

    # apt source mirror
    APT_SOURCES_MIRRORS=(
        "https://mirrors.ustc.edu.cn/debian/ bullseye main contrib non-free"
        "https://mirrors.ustc.edu.cn/debian/ bullseye-updates main contrib non-free"
        "https://mirrors.ustc.edu.cn/debian/ bullseye-backports main contrib non-free"
        "https://mirrors.ustc.edu.cn/debian-security/ bullseye-security main contrib non-free"
    )

    PYTHON_PIP_INDEX_SOURCE=https://pypi.tuna.tsinghua.edu.cn/simple
    PYTHON_PIP_TRUST_HOST_SOURCE=https://pypi.tuna.tsinghua.edu.cn

    # set zsh_custom path
    ZSH_INSTALL_PATH=${HOME}/.oh-my-zsh/
    ZSH_CUSTOM=${ZSH_INSTALL_PATH}/custom
    ZSH_INSTALL_SCRIPT_TEMP_PATH=/tmp/install.sh

    # set github info
    GITHUB_USER=""
    GITHUB_EMAIL=""
    GITHUB_SRC=https://github.com
    GITHUB_SRC_RAW=https://raw.githubusercontent.com
    GITHUB_MIRROR=https://github.com.cnpmjs.org
    GITHUB_MIRROR_DOWN=https://download.fastgit.org
    GITHUB_MIRROR_RAW=https://raw.staticdn.net 

    # vim config
    VIM_PLUGIN_AUTO_PATH=${HOME}/.vim/plugged
    VIM_PLUGIN_MANUAL_PATH=${HOME}/.vim/manually
    VIM_BIN_PATH=/usr/bin/vim
    VIM_BIN_REBUILD_PATH=/usr/local/bin/vim
    VIM_TEMP_PATH=/tmp/vim

    # go config
    GO_PROXY=https://goproxy.cn/

    # rust config
    # RUSTUP_DIST_MIRROR=https://mirrors.ustc.edu.cn/rust-static
    # RUSTUP_UPDATE_MIRROR=https://mirrors.ustc.edu.cn/rust-static/rustup
    RUSTUP_DIST_MIRROR=https://rsproxy.cn     # bytedance
    RUSTUP_UPDATE_MIRROR=https://rsproxy.cn/rustup # bytedance
    # RUSTUP_DIST_MIRROR=https://mirrors.sjtug.sjtu.edu.cn/rust-static
    # RUSTUP_UPDATE_MIRROR=https://mirrors.sjtug.sjtu.edu.cn/rust-static/rustup


    #docker 
    DOCKER_GPG_MIRROR=https://mirrors.aliyun.com/docker-ce/linux/debian/gpg
    DOCKER_INSTALL_MIRROR="https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian bullseye stable"
    DOCKER_HUB_MIRRORS=(
        https://hub-mirror.c.163.com
        https://mirror.baidubce.com
        https://mirror.ccs.tencentyun.com
        https://docker.mirrors.ustc.edu.cn
    )

    export APT_UPDATED=0

    function printf_color(){
        printf "${3}${2}%s${TEXT_RESET}\n" "${1}"
    }
    
    function exist_in_file() { 
        old_ifs=${IFS}
        IFS=''
        while read -r line
        do
            # echo ${line}
            if [[ ${line} == *"${1}"* ]]
            then
                IFS=${old_ifs}
                return 1
            fi
        done < ${2}
        IFS=${old_ifs}
        return 0
    }
    
    function backup_exist() {
        if [[ -d ${1} || -e ${1} ]]
        then 
            str=$(random_str)
            name=${1##*/}
            if [[ -n ${name} ]]
            then 
                tmp=${1%*/}
                name=${tmp##*/}
            fi
            printf_color "${1} already exist, it will backup to '/tmp/${name}.${str}'" ${TEXT_MAGENTA}
            sudo mv ${1} /tmp/${name}.${str}
        fi
    }

    function backup_exist_interactive() {
        if [[ -d ${1} || -e ${1} ]]
        then
            read -p "${1} already exist, do you want to backup and delete it (Y/n)? " opt
            case ${opt:-y} in
            y*|Y*|${null})
                str=$(random_str)
                name=${1##*/}
                if [[ -n ${name} ]]
                then 
                    tmp=${1%*/}
                    name=${tmp##*/}
                fi
                printf_color "${1} already exist, it will backup to '/tmp/${name}.${str}'" ${TEXT_MAGENTA}
                sudo mv ${1} /tmp/${name}.${str}
                return 1
                ;;
            *)
                return 2
                ;;
            esac
        fi
        return 0
    }

    function update_hosts() {
        printf_color "Updating '${1}' host dns." ${TEXT_YELLOW}
        read -p "Please make sure ${2} is valid in dnschecker.org. (Y/n)? " valid
        case ${valid} in 
        y*|Y*|${null})
            sudo bash -c "sed -i '/${1}/d' /etc/hosts"
            sudo bash -c "echo '${2} ${1}' >> /etc/hosts"
            ;;
        n*|N*)
            read -p "Input the new ip: " ip
            sudo bash -c "sed -i '/${1}/d' /etc/hosts"
            sudo bash -c "echo '${ip} ${1}' >> /etc/hosts"
            ;;
        *)
            printf_color "Invalid input, skiping." ${TEXT_RED}
            ;;
        esac
    }

    function update_url() {
        sudo bash -c "sed -i 's#${1}#${2}#g' ${3}"
    }

    function add_apt_source() {
        apt_sources_path=/etc/apt/sources.list
        exist_in_file "${1}" ${apt_sources_path}
        # sudo bash -c "echo 'deb ${1}' >> /etc/apt/sources.list"
        if [[ $? -ne 1 ]]
        then 
            sudo bash -c "echo 'deb ${1}' >> ${apt_sources_path}"
        fi
    }
    
    # argument must be absolutely path
    function walk_submodule() {
        cd ${1}
        if [[ ! -e ".gitmodules" ]]
        then
            return
        fi
        sed -i "s#${GITHUB_SRC}/#${GITHUB_MIRROR}/#g" ".gitmodules" # find and replace with "/"
        while read title
        do
            read path
            read url
            printf_color "Clone url: ${url##*' '}" ${TEXT_YELLOW}
            printf_color "Cloning ${path##*' '} to ${1}/${path##*' '}" ${TEXT_CYAN}
            backup_exist ${1}/${path##*' '}
            git clone --depth=1 ${url##*' '} "${1}/${path##*' '}"
            git submodule init
            walk_submodule "${1}/${path##*' '}"
        done < ".gitmodules"
    }

    function random_str() {
        echo $(cat /dev/urandom | head -n 100 | md5sum | head -c ${1:-6})
    }

    function apt_updated() {
        if [[ ${APT_UPDATED} -ne 1 ]] 
        then 
            sudo apt update && sudo apt upgrade -y
            APT_UPDATED=1
        fi
    }

    function check_zsh() {
        # change to the zsh
        if [[ ${SHELL##*/} == "zsh" ]]
        then 
            return 
        elif [[ ${ZSH_CHANGED} -ne 1 ]]
        then
            printf_color "Change to zsh terminal,Please input the password" ${TEXT_RED}
            chsh -s "$(which zsh)"
            export ZSH_CHANGED=1
        fi
    }

    function check_pip() {
        if [[ ! -d ${HOME}/.pip ]]
        then 
            mkdir -p ${HOME}/.pip
        fi

        if [[ ! -e ${HOME}/.pip/pip.conf ]]
        then
            # touch ${HOME}/.pip/pip.conf
            
            cat > ${HOME}/.pip/pip.conf <<- EOF
				[global] 
				index-url = ${PYTHON_PIP_INDEX_SOURCE}
				[install]
				trusted-host = ${PYTHON_PIP_TRUST_HOST_SOURCE}
			EOF
        fi
    }

    export COMMON_SOURCED=1
    wait
fi




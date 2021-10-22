#!/bin/bash
###
 # @Author       : KK
 # @Date         : 2021-10-12 14:47:34
 # @LastEditTime : 2021-10-21 14:19:22
 # @LastEditors  : KK
 # @Description  : Update apt mirror source lists
 # @FilePath     : \debian_install_script\apt.sh
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

if [[ whoami = "root" ]]
then 
    apt install sudo
    #add user
fi

printf_color "Update apt source lists." ${TEXT_GREEN}

backup_exist /etc/apt/sources.list

ishttps=0
for url in "${APT_SOURCES_MIRRORS[@]}"
do 
    if [[ ${url%:*} == "https" ]]
    then 
        add_apt_source "${url/https/http}"
        ishttps=1
    else    
        add_apt_source "${url}"
    fi
done

# update to ustc apt source
# sudo bash -c "echo 'deb http://mirrors.ustc.edu.cn/debian/ bullseye main contrib non-free' > /etc/apt/sources.list"
# sudo bash -c "echo 'deb http://mirrors.ustc.edu.cn/debian/ bullseye-updates main contrib non-free' >> /etc/apt/sources.list"
# sudo bash -c "echo 'deb http://mirrors.ustc.edu.cn/debian/ bullseye-backports main contrib non-free' >> /etc/apt/sources.list"
# sudo bash -c "echo 'deb http://mirrors.ustc.edu.cn/debian-security/ bullseye-security main contrib non-free' >> /etc/apt/sources.list"

# update to tsinghua apt source
# sudo bash -c "echo 'deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free' > /etc/apt/sources.list"
# sudo bash -c "echo 'deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free' >> /etc/apt/sources.list"
# sudo bash -c "echo 'deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free' >> /etc/apt/sources.list"
# sudo bash -c "echo 'deb http://mirrors.tuna.tsinghua.edu.cn/debian-security/ buster/updates main contrib non-free' >> /etc/apt/sources.list"

sudo apt update && sudo apt install apt-transport-https ca-certificates -y

if [[ ishttps -eq 1 ]]
then 
    update_url "http" "https" /etc/apt/sources.list
    sudo apt update && sudo apt upgrade -y
fi


APT_UPDATED=1
wait
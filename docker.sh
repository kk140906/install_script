#!/bin/bash
###
 # @Author       : KK
 # @Date         : 2021-10-22 10:11:14
 # @LastEditTime : 2021-10-22 11:48:54
 # @LastEditors  : KK
 # @Description  : 
 # @FilePath     : \debian_install_script\docker.sh
### 


# set -e
# set -o pipefail
SCRIPT_PATH=$(dirname $0)
if [[ ${SCRIPT_PATH} == "." ]]
then 
    SCRIPT_PATH=$(pwd)
fi

source ${SCRIPT_PATH}/common.sh

cd ~

function create_mirrors_file() {
    mirrors_file_path=/etc/docker/daemon.json
    sudo bash -c  "echo -e '{ \n\t\"registry-mirrors\"' : [> ${mirrors_file_path}"
    for mirror in ${DOCKER_HUB_MIRRORS[@]}
    do 
        sudo bash -c "echo -e '\t\t\"${mirror}\"', >> ${mirrors_file_path}"
    done
    sudo bash -c "echo -e '\t]\n}' >> ${mirrors_file_path}"
}

apt_updated

printf_color "Install some dependecies." ${TEXT_GREEN}
sudo apt install apt-transport-https ca-certificates curl gnupg2 lsb-release software-properties-common -y

printf_color "Create gpg keyring file and add to apt sources.list." ${TEXT_GREEN}
docker_keyring_path=/usr/share/keyrings/docker-archive-keyring.gpg
curl -fsSL ${DOCKER_GPG_MIRROR} | sudo gpg --dearmor -o ${docker_keyring_path}
add_apt_source "[arch=amd64 signed-by=${docker_keyring_path}] ${DOCKER_INSTALL_MIRROR}"

sudo apt update

sudo apt install docker-ce docker-ce-cli containerd.io docker-compose -y

create_mirrors_file

sudo systemctl enable docker
sudo systemctl start docker
#!/bin/bash
###
 # @Author       : KK
 # @Date         : 2021-10-14 09:05:58
 # @LastEditTime : 2021-10-21 14:19:42
 # @LastEditors  : KK
 # @Description  : Install tldr-pages python client
 # @FilePath     : \debian_install_script\tldr_python.sh
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

# install tldr
printf_color "Install tldr page, update database maybe take a moment." ${TEXT_GREEN}

if [[ ! -d ${HOME}/.cache/tldr ]]
then 
    mkdir -p ${HOME}/.cache/tldr
fi

check_pip 

export TLDR_LANGUAGE="en"
# export TLDR_PAGES_SOURCE_LOCATION="${GITHUB_MIRROR_RAW}/tldr-pages/tldr/master/pages"
# export TLDR_DOWNLOAD_CACHE_LOCATION="${GITHUB_MIRROR_RAW}/tldr-pages/tldr-pages.github.io/master/assets/tldr.zip"

# make sure the dns is up to date, from dnschecker.org
# update_hosts "tldr-pages.github.io" "185.199.108.153"

sudo pip3 install tldr && tldr -u

wait
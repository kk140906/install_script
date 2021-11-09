#!/bin/bash
###
 # @Author       : KK
 # @Date         : 2021-10-21 15:02:24
 # @LastEditTime : 2021-11-09 13:12:19
 # @LastEditors  : KK
 # @Description  : Just for vps.
 # @FilePath     : \debian_install_script\shadowsocks_libev.sh
### 

apt update

read -p $'Select shadowsocks version:\n1):shaowsocks-libev\n2):shadowsocks-python\nInput Version: ' version
read -p $'Input your server port: ' server_port
read -p $'Input your password: ' password

case ${version} in 
1)
    apt install shadowsocks-libev ufw -y
    cat > /etc/shadowsocks/config.json << EOF
{
    "server":"0.0.0.0",
    "mode":"tcp_and_udp",
    "server_port":${server_port},
    "local_address":"127.0.0.1",
    "local_port":1854,
    "password":"${password}",
    "timeout":60,
    "method":"aes-256-gcm"
}
EOF
    systemctl start shadowsocks-libev.service
    ;;
2)
    apt install python3-pip libsodium* ufw -y
    pip install https://github.com/shadowsocks/shadowsocks/archive/master.zip -U
    cat > /etc/shadowsocks.json << EOF
{
    "server":"0.0.0.0",
    "mode":"tcp_and_udp",
    "server_port":${server_port},
    "local_address":"127.0.0.1",
    "local_port":1854,
    "password":"${password}",
    "timeout":60,
    "method":"aes-256-gcm"
}
EOF
    ssserver -c /etc/shadowsocks.json -d start
    ;;
*)
    echo "invalid input"
    exit 1
    ;;
esac

ufw allow ${server_port}

echo "install complete"
echo "server port : " ${server_port}
echo "password : " ${password}
echo "method : aes-256-gcm" 



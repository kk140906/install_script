#!/bin/bash
###
 # @Author       : KK
 # @Date         : 2021-10-21 15:02:24
 # @LastEditTime : 2021-10-22 09:45:13
 # @LastEditors  : KK
 # @Description  : Just for vps.
 # @FilePath     : \debian_install_script\shadowsocks_libev.sh
### 

apt update
apt install shadowsocks-libev ufw -y
read -p "\nInput your server port: " server_port
read -p "\nInput your password: " password

cat > /etc/shadowsocks/config.json<<EOF
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

ufw allow ${server_port}
systemctl restart shadowsocks-libev.service



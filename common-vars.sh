#!/bin/bash

# set enviroment variables


export LISTEN_PORT=1194
export VPN_NET=10.8.0.0
export VPN_MASK=255.255.255.0

INTERFACE=eth0
export INTERFACE_IP=`/sbin/ifconfig $INTERFACE 2>/dev/null | /usr/bin/awk '/inet addr:/ {print $2}' | /bin/sed 's/addr://'`
# REMOTE_IP - ip of vpn server
export REMOTE_IP=` echo $VPN_NET | sed -e "s/[0-9]*$/1/" `
export MAIN_DIR=/opt/ovpn-server
export LOG_DIR=/etc/openvpn/log

export SERVER_CONF=/etc/openvpn/server.conf

export STATICCLIENT_DIR=/etc/openvpn/staticclients
export CLIENT_CONF_DIR=/etc/openvpn/client

export EASY_RSA=/etc/openvpn/easy-rsa
export OPENSSL="openssl"
export PKCS11TOOL="pkcs11-tool"
export GREP="grep"
export KEY_CONFIG=`$EASY_RSA/whichopensslcnf $EASY_RSA`
export KEY_DIR="$EASY_RSA/keys"
export PKCS11_MODULE_PATH="dummy"
export PKCS11_PIN="dummy"
export KEY_SIZE=2048
export CA_EXPIRE=3650
export KEY_EXPIRE=3650
export KEY_COUNTRY="US"
export KEY_PROVINCE="CA"
export KEY_CITY="SanFrancisco"
export KEY_ORG="Fort-Funston"
export KEY_EMAIL="me@myhost.mydomain"
export KEY_OU="MyOrganizationalUnit"
export KEY_NAME="EasyRSA"

export PROXY_CONF=/usr/local/etc/3proxy/3proxy.cfg



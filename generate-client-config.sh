#!/bin/bash
# install openvpn server
# korolev-ia [at] yandex.ru
# v1.2 20161117

CLIENT=$1
if [ -z "$CLIENT" ] ; then
	echo "Usage:$0 client_name"
	exit 1
fi

# set enviroment variables
DIR=`dirname $0`
source "$DIR/common-vars.sh"


CLIENT_CONF=$CLIENT_CONF_DIR/$CLIENT.ovpn

"$EASY_RSA/pkitool" $CLIENT


####################################
############ generate client config now 

cat <<EOF_CLIENT_CONF > $CLIENT_CONF
############ $CLIENT_CONF
client
dev tun
proto tcp
remote $INTERFACE_IP $LISTEN_PORT
remote-cert-tls server
verb 3
comp-lzo
persist-key
persist-tun
nobind
route-method exe
route-delay 2
###########################
EOF_CLIENT_CONF

echo '<ca>' >> $CLIENT_CONF
cat $KEY_DIR/ca.crt >> $CLIENT_CONF
echo '</ca>' >> $CLIENT_CONF

echo '<cert>' >> $CLIENT_CONF
cat $KEY_DIR/$CLIENT.crt >> $CLIENT_CONF
echo '</cert>' >> $CLIENT_CONF

echo '<key>' >> $CLIENT_CONF
cat $KEY_DIR/$CLIENT.key >> $CLIENT_CONF
echo '</key>' >> $CLIENT_CONF

SERIAL=`cat /etc/openvpn/easy-rsa/keys/serial`
let  "IFL = $SERIAL * 4 + 1"
let  "IFR = $IFL + 1"

STATIC_IP=` echo $VPN_NET | sed -e "s/[0-9]*$/$IFL/" `
STATIC_REMOTE_IP=` echo $VPN_NET | sed -e "s/[0-9]*$/$IFR/" `
echo "ifconfig-push $STATIC_IP $STATIC_REMOTE_IP" > $STATICCLIENT_DIR/$CLIENT

echo "##################################################"
echo "copy config file $CLIENT_CONF to your client computer"
echo "and connect to openvpn server"


exit 0
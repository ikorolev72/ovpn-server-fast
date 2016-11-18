#!/bin/bash
# install openvpn server
# korolev-ia [at] yandex.ru
# v1.2 20161117

apt-get -y install openvpn  openssl easy-rsa

cp -r /usr/share/easy-rsa /etc/openvpn

# set enviroment variables
DIR=`dirname $0`
source "$DIR/common-vars.sh"

if [ -f "$SERVER_CONF" ]; then
	if [ "x$1" != "x-f" ] ; then
		echo "Found existing server config $SERVER_CONF"
		echo "Please add '-f' option if you would like to rewrite configuration"
		echo "Usage:$0 [-f]"
		exit 1
	fi	
fi

# remove old files 
rm -rf $STATICCLIENT_DIR $CLIENT_CONF_DIR $LOG_DIR $MAIN_DIR/etc $SERVER_CONF

# create all dirs
mkdir -p $STATICCLIENT_DIR $CLIENT_CONF_DIR $LOG_DIR $MAIN_DIR/etc
ln -s $STATICCLIENT_DIR $MAIN_DIR/etc/
ln -s $CLIENT_CONF_DIR $MAIN_DIR/etc/
ln -s $LOG_DIR $MAIN_DIR/etc/


if [ "$KEY_DIR" ]; then
    rm -rf "$KEY_DIR"
    mkdir "$KEY_DIR" && \
        chmod go-rwx "$KEY_DIR" && \
        touch "$KEY_DIR/index.txt" && \
        echo 01 >"$KEY_DIR/serial"
fi
"$EASY_RSA/pkitool" --initca
"$EASY_RSA/pkitool" --server server
$OPENSSL dhparam -out ${KEY_DIR}/dh${KEY_SIZE}.pem ${KEY_SIZE}

####################################
############ generate server config now 


cat <<EOF > $SERVER_CONF
############# server.conf
daemon
port $LISTEN_PORT
proto $PROTOCOL
dev tun
server  $VPN_NET $VPN_MASK
client-config-dir $STATICCLIENT_DIR
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 10 120
comp-lzo
user nobody
group nogroup
persist-key
persist-tun
status $LOG_DIR/openvpn-status.log
log $LOG_DIR/openvpn.log
log-append $LOG_DIR/openvpn.log
verb 3
#duplicate-cn
#client-to-client
#
EOF


echo '<ca>' >> $SERVER_CONF
cat $KEY_DIR/ca.crt >> $SERVER_CONF
echo '</ca>' >> $SERVER_CONF

echo '<cert>' >> $SERVER_CONF
cat $KEY_DIR/server.crt >> $SERVER_CONF
echo '</cert>' >> $SERVER_CONF

echo '<key>' >> $SERVER_CONF
cat $KEY_DIR/server.key >> $SERVER_CONF
echo '</key>' >> $SERVER_CONF

echo '<dh>' >> $SERVER_CONF
cat ${KEY_DIR}/dh${KEY_SIZE}.pem >> $SERVER_CONF
echo '</<dh>' >> $SERVER_CONF



############ server config finished
####################################

####################################
####################################
# uncomment next lines if you need enable packet forwarding
#
# echo "1" > /proc/sys/net/ipv4/ip_forward
# sysctl -w net.ipv4.ip_forward=1
# iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
####################################
####################################



if [ "x$ENABLE_FORWARDING" = "x1" ]; then
	echo 1 > /proc/sys/net/ipv4/ip_forward
	sysctl -w net.ipv4.ip_forward=1
	#echo '#' >> /etc/sysctl.conf
	#echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
	iptables -t nat -A POSTROUTING -s $VPN_NET/$VPN_MASK -o $INTERFACE -j MASQUERADE
	apt-get install -y iptables-persistent
	service iptables-persistent start 2>/dev/null
	service iptables-persistent save 2>/dev/null
	service netfilter-persistent start 2>/dev/null
	service netfilter-persistent save 2>/dev/null
fi

systemctl daemon-reload
echo "##################################################"
echo "# You can start openvpn server with commands:"
echo "# service openvpn start"
echo "##################################################"


exit 0

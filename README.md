#   openvpn server/client config generator for Debian 8/Ubuntu

##  What is it?
Script for install openvpn and generate config files.

##  The Latest Version

	version 1.2 2016.11.17


### 		How to install
```
cd /opt
git clone https://github.com/ikorolev72/ovpn-server-fast.git
```


Files in archive:
```
common-vars.sh
generate-client-config.sh
server-install.sh
```

### 		How to run
Change the current dir to `/opt/ovpn-server-fast/` ( or in the dir you install this application )  
Change the variables in file common-vars.sh ( eg VPN_NET, VPN_MASK, KEY_COUNTRY, KEY_COUNTRY, etc). 

1. Install and generate config file for openvpn server: `./server-install.sh`
( if you have existing server config, you need start script with force option `./server-install.sh -f`). 
Now you can start openvpn server with command `service openvpn start` or `openvpn --config /etc/openvpn/server.conf`.

2. Generate config files for client: `./generate-client-config.sh CLIENT_NAME`. For every CLIENT_NAME generated
unique config files and reserve ip address. All client configs are in `/etc/openvpn/client`.


## Known bugs

 
  Licensing
  ---------
	GNU

  Contacts
  --------

     o korolev-ia [at] yandex.ru
     o http://www.unixpin.com

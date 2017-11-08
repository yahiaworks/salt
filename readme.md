# VIPS Salt Master
## Configuration/provisioning
Master config and scripts are provided to make a VIPS salt master.

## Running Locally
### First Steps
Three passwords must be replaced in order to get full functionality (Secret Server links are in each file):
* cloud.providers.d/vmware.conf
* cloud.profiles.d/vmware.conf
* master
### Build and Run
```sh
cd vagrant
vagrant up
```
The Salt master will start automatically
### Running Commands on Salt Master
SSH into the Vagrant guest and run "docker exec":
```sh
vagrant ssh
sudo docker exec salt_master [command]
```
Alternatively, you can start an interactive session on the master, then run commands:
```sh
sudo docker exec -i -t salt_master /bin/bash
```
##### Examples
Accept all keys:
```sh
sudo docker exec salt_master salt-key -y --accept-all
```
Ping minions:
```sh
sudo docker exec salt_master salt '*' test.ping
```
Clone a new WWW VM in VMWare:
```sh
sudo docker exec salt_master salt-cloud -p vmware-www-template [vm name] -l debug
```
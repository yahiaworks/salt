#!/bin/bash

set -x

master_hostname=$1

master_key="\[MASTER NAME\]"
config_file="/etc/salt/cloud.profiles.d/vmware.conf"

sed -i -e "s/$master_key/$master_hostname/g" $config_file

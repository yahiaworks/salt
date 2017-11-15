#!/bin/bash

set -x

master_hostname=$1

if [ -z ${master_hostname+x} ]; then master_hostname="devsaltvips.vistaprint.net"; fi

echo "Using hostname $master_hostname"
./set_master_hostname.sh $master_hostname

salt-master -c /etc/salt --log-file-level=quiet --log-level=info

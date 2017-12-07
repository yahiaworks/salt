#!/bin/bash

set -x

./replace_credentials.sh

nginx

# Create local salt-api user
useradd -ms /bin/bash $SALTAPI_USERNAME
echo "$SALTAPI_USERNAME:$SALTAPI_PASSWORD" | chpasswd

# Decrypt key
openssl rsa -in /etc/salt/certs/star.vistaprint.net.key.encrypted -out /etc/salt/certs/star.vistaprint.net.key -passin pass:$PEM_PASSPHRASE

salt-api -d
salt-run winrepo.update_git_repos
salt-master -c /etc/salt --log-file-level=quiet --log-level=info
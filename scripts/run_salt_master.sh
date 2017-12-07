#!/bin/bash

set -x

./replace_credentials.sh

nginx

# Create local salt-api user
useradd -ms /bin/bash $SALTAPI_USERNAME
echo "$SALTAPI_USERNAME:$SALTAPI_PASSWORD" | chpasswd

salt-api -d
salt-run winrepo.update_git_repos
salt-master -c /etc/salt --log-file-level=quiet --log-level=info
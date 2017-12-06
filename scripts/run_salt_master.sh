#!/bin/bash

set -x

./replace_credentials.sh

nginx

salt-api -d
salt-run winrepo.update_git_repos
salt-master -c /etc/salt --log-file-level=quiet --log-level=info

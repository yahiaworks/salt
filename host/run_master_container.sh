#!/bin/bash

docker_host=$1

sudo docker run -d --name salt-master --env-file /vagrant/secrets.txt -v saltkeys:/etc/salt/pki -p 4505:4505 -p 4506:4506 -p 5985:5985 -p 5986:5986 -p 8000:8000 -p 8080:8080 salt-master

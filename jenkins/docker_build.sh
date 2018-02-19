#!/bin/bash

set -x

function build_image {
    sudo docker rm -f $(sudo docker ps -aq) || true
    sudo docker rmi -f $(sudo docker images -aq)
    sudo docker build -t salt-master .
}

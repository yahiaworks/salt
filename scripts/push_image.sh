#!/bin/bash

set -x
set -e

function docker_login {
    sudo docker login docker-development.docker.vips.vistaprint.io
}

function docker_push {
    tag=$1

    sudo docker tag salt_master docker-development.docker.vips.vistaprint.io/vips/salt-master:$tag
    sudo docker push docker-development.docker.vips.vistaprint.io/vips/salt-master:$tag
}

version="0.0.0.11"
docker_login
docker_push $version
docker_push latest

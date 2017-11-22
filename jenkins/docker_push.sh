#!/bin/bash

set -e

image_repo="docker-development.docker.vips.vistaprint.io"
image_name="vips/salt-master"
image_full_name="$image_repo/$image_name"

function publish {
    version=$1
    user=$2
    password=$3

    docker_login $user $password
    docker_push $version
}

function docker_login {
    user=$1
    password=$2

    sudo docker login $image_repo --username $user --password $password
}

function docker_push {
    version=$1

    sudo docker tag salt-master $image_full_name:$version
    sudo docker push $image_full_name:$version

    sudo docker tag salt-master $image_full_name:latest
    sudo docker push $image_full_name:latest
}

function cleanup {
    version=$1
    sudo docker rmi -f salt-master || true
    sudo docker rmi -f $image_full_name:$version || true
    sudo docker rmi -f $image_full_name:latest || true
}

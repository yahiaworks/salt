#!/bin/bash

set -e

image_name="vips/salt-master"

function publish {
    repo=$1
    version=$2
    user=$3
    password=$4

    docker_login $repo $user $password
    docker_push $repo $version
}

function docker_login {
    repo=$1
    user=$2
    password=$3

    sudo docker login $repo --username $user --password $password
}

function docker_push {
    repo=$1
    version=$2

    image_full_name="$repo/$image_name"

    sudo docker tag salt-master $image_full_name:$version
    sudo docker push $image_full_name:$version

    sudo docker tag salt-master $image_full_name:latest
    sudo docker push $image_full_name:latest
}

function cleanup {
    repo=$1
    version=$2

    image_full_name="$repo/$image_name"

    sudo docker rmi -f salt-master || true
    sudo docker rmi -f $image_full_name:$version || true
    sudo docker rmi -f $image_full_name:latest || true
}

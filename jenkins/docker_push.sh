#!/bin/bash

set -e

image_name="vips/salt-master"

function publish {
    repo=$1
    version=$2
    user=$3
    password=$4

    docker_login $repo $user $password
    docker_tag_build_and_push $repo $version
}

function promote {
    src_repo=$1
    dst_repo=$2
    version=$3
    user=$4
    password=$5

    sudo docker tag "$src_repo/$image_name:$version" "$dst_repo/$image_name:$version"
    
    docker_login $dst_repo $user $password
    docker_push "$dst_repo/$image_name:$version"
}

function docker_login {
    repo=$1
    user=$2
    password=$3

    sudo docker login $repo --username $user --password $password
}

function docker_tag_build_and_push {
    repo=$1
    version=$2

    image_full_name="$repo/$image_name"

    sudo docker tag salt-master $image_full_name:$version
    docker_push $image_full_name:$version

    sudo docker tag salt-master $image_full_name:latest
    docker_push $image_full_name:latest
}

function docker_push {
    image=$1

    sudo docker push $image
}

function cleanup {
    repo=$1
    version=$2

    image_full_name="$repo/$image_name"

    sudo docker rmi -f salt-master || true
    sudo docker rmi -f $image_full_name:$version || true
    sudo docker rmi -f $image_full_name:latest || true
}

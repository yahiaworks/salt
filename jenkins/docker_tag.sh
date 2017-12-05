#!/bin/bash

set -e
set -x 
image_name="vips/salt-master"

function retag {
    from_repo=$1
    to_repo=$2
    version=$3

    sudo docker tag "$from_repo/$image_name:$version" "$to_repo/$image_name:$version"
}

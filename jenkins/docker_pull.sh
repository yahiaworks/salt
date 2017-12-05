#!/bin/bash

set -e

image_name="vips/salt-master"

function pull {
    repo=$1
    version=$2

    image_full_name="$repo/$image_name"

    sudo docker pull $repo $image_full_name:$version
}

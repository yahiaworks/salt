#!/bin/bash

set -x

function build_image {
    sudo docker build -t salt-master .
}

#!/bin/bash

version="0.0.0.6"

sudo docker tag salt_master docker-development.docker.vips.vistaprint.io/vips/salt-master:$version
sudo docker login docker-development.docker.vips.vistaprint.io
sudo docker push docker-development.docker.vips.vistaprint.io/vips/salt-master:$version
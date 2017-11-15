#!/bin/bash

sudo docker run -d --name salt_master -p 4505:4505 -p 4506:4506 -p 5985:5985 -p 5986:5986 salt_master
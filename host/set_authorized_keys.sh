#!/bin/bash

chown -R vipssalt /home/vipssalt/.ssh
cat ~vipssalt/.ssh/id_rsa.pub >> /home/vipssalt/.ssh/authorized_keys
#!/bin/bash


function main {
    install_docker

    create_octopus_user
    install_octopus_dependencies

    get_ssh_keys
}

function install_docker {
    apt-get -y install docker.ce
}

function create_octopus_user {
    echo "Creating octopus user, use this password: https://scrt.vistaprint.net/SecretView.aspx?secretid=18581"
    adduser vipssalt
    usermod -aG sudo vipssalt
}

function install_octopus_dependencies {
    apt-get install -y libunwind8
}

function get_ssh_keys {
    mkdir -p /home/vipssalt/.ssh

    echo "Get the public/private SSH key from here: https://scrt.vistaprint.net/SecretView.aspx?secretid=18586 and put them in /home/vipssalt/.ssh/"
    read -p "Press enter to confirm"
}

main
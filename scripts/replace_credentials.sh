#!/bin/bash
 
PROFILE_FILENAME="/etc/salt/cloud.profiles.d/vmware.conf"
PROVIDER_FILENAME="/etc/salt/cloud.providers.d/vmware.conf"
MASTER_FILENAME="/etc/salt/master"

MASTER_NAME_KEY="\[MASTER_NAME\]"
PRIVATE_PILLAR_USERNAME_KEY="\[USERNAME\]"
PRIVATE_PILLAR_PASSWORD_KEY="\[PASSWORD\]"
VIPSADMIN_PASSWORD_KEY="\[VIPSADMIN_PASSWORD\]"
VCENTER_PASSWORD_KEY="\[VCENTER_VIPS_PASSWORD\]"

function main {
    # Allow config to already have replacements performed (for local dev)
    if [ -n "$CHECK_ENV_VARS" ]; then
        check_env_vars
    fi

    replace_value "$MASTER_NAME_KEY" $MASTER_HOSTNAME $PROFILE_FILENAME
    replace_value "$PRIVATE_PILLAR_USERNAME_KEY" $PRIVATE_PILLAR_USER $MASTER_FILENAME
    replace_value "$PRIVATE_PILLAR_PASSWORD_KEY" $PRIVATE_PILLAR_PASSWORD $MASTER_FILENAME
    replace_value "$VIPSADMIN_PASSWORD_KEY" $VIPSADMIN_PASSWORD $PROFILE_FILENAME
    replace_value "$VCENTER_PASSWORD_KEY" $VCENTER_PASSWORD $PROVIDER_FILENAME
}

function replace_value {
    key=$1
    value=$2
    file=$3

    if [ -n "$value" ]; then
        echo "Replacing $key in $file"
        sed -i -e "s/$key/$value/g" $file
    fi
}

function check_env_vars {
    check_env_var "PRIVATE_PILLAR_USER" $PRIVATE_PILLAR_USER
    check_env_var "PRIVATE_PILLAR_PASSWORD" $PRIVATE_PILLAR_PASSWORD
    check_env_var "MASTER_HOSTNAME" $MASTER_HOSTNAME
    check_env_var "VIPSADMIN_PASSWORD" $VIPSADMIN_PASSWORD
    check_env_var "VCENTER_PASSWORD" $VCENTER_PASSWORD
}

function check_env_var {
    name=$1
    value=$2
    if [ -z "$value" ]; then
        echo "Error: Missing environment variable $name"
        exit 1
    fi
}

main
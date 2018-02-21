#!/bin/bash

PROFILE_FILENAME="/etc/salt/cloud.profiles.d/vmware.conf"
PROVIDER_FILENAME="/etc/salt/cloud.providers.d/vmware.conf"
MASTER_FILENAME="/etc/salt/master"
SALTPAD_FILENAME="/etc/nginx/sites-enabled/default"

MASTER_NAME_KEY="\[MASTER_NAME\]"
PRIVATE_PILLAR_USERNAME_KEY="\[USERNAME\]"
PRIVATE_PILLAR_PASSWORD_KEY="\[PASSWORD\]"
VIPSADMIN_PASSWORD_KEY="\[VIPSADMIN_PASSWORD\]"
VCENTER_PASSWORD_KEY="\[SALT_CLOUD_PASSWORD\]"

LDAPSALT_PASSWORD_KEY="\[LDAPSALT_PASSWORD\]"
LDAPSALT_USERNAME_KEY="\[LDAPSALT_USERNAME\]"

PARAM_PREFIX="/Salt/WWW"

function main {
    # Allow config to already have replacements performed (for local dev)
    if [ -n "$CHECK_ENV_VARS" ]; then
        check_env_vars
    fi

    replace_value_from_aws "$PRIVATE_PILLAR_USERNAME_KEY" "$PARAM_PREFIX/PRIVATE_PILLAR_USER" $MASTER_FILENAME
    replace_value_from_aws "$PRIVATE_PILLAR_PASSWORD_KEY" "$PARAM_PREFIX/PRIVATE_PILLAR_PASSWORD" $MASTER_FILENAME
    replace_value_from_aws "$VIPSADMIN_PASSWORD_KEY" "$PARAM_PREFIX/VIPSADMIN_PASSWORD" $PROFILE_FILENAME
    replace_value_from_aws "$VCENTER_PASSWORD_KEY" "$PARAM_PREFIX/VCENTER_PASSWORD" $PROVIDER_FILENAME
    replace_value_from_aws "$LDAPSALT_PASSWORD_KEY" "$PARAM_PREFIX/SALTAPI_PASSWORD" $MASTER_FILENAME
    replace_value_from_aws "$LDAPSALT_USERNAME_KEY" "$PARAM_PREFIX/SALTAPI_USERNAME" $MASTER_FILENAME

    replace_value "$MASTER_NAME_KEY" $MASTER_HOSTNAME $PROFILE_FILENAME
    replace_value "$MASTER_NAME_KEY" $MASTER_HOSTNAME $SALTPAD_FILENAME
}

function replace_value_from_aws {
    key=$1
    parameter_name=$2
    file=$3

    parameter_value=`aws ssm get-parameter --name $parameter_name --with-decryption | jq -r ".Parameter.Value"`
    replace_value $key $parameter_value $file
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
    check_env_var "AWS_ACCESS_KEY_ID"
    check_env_var "AWS_SECRET_ACCESS_KEY"
    check_env_var "MASTER_HOSTNAME"
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
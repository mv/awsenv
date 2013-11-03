#!/bin/bash
#
# Changing between amazon accounts
#
# This script must be sourced by your ~/.bashrc or something
#
# Marcus Vinicius Fereira            ferreira.mv[ at ].gmail.com
# 2012-11


###
### My different profiles
###
[ -z "$AWSENV_PROFILES_DIR" ] && {

    echo
    echo "AWSENV_PROFILES_DIR is not set. See readme."
    echo
    return

}

 profiles_dir="$AWSENV_PROFILES_DIR"
templates_dir="$AWSENV_TEMPLATES_DIR"


###
### to be used by PS1
###
function __awsenv_ps1() {
    if [ "$AWSENV_PROFILE" != "" ]
    then
        echo "[aws:$AWSENV_PROFILE]"
    fi
}

###
### Routines
###

function awsenv-ls() {

    echo
    echo "AWSEnv: Profiles"
    echo "----------------"
    builtin cd "${profiles_dir}" && find * -type d -o -type l -prune | sort
    echo

}

function awsenv-set() {

    profile="$1"
    if [ ! -d "${profiles_dir}/${profile}" ]
    then
        echo
        echo "Profile: DOES NOT exist: [${profile}]"
        echo
        return
    fi

    ###
    ### credentials
    ###
#   ln -nsf "${profiles_dir}/${profile}" ~/.awsenv && \
    export AWSENV_PROFILE="${profile}"

    # From my credential-file, all other vars are evaluated when read
    export   AWS_CREDENTIAL_FILE="${profiles_dir}/${profile}/aws-credential-file.cfg"
    export     AWS_ACCESS_KEY_ID=$( awk -F= '/AccessKey/ {print $2}' $AWS_CREDENTIAL_FILE 2>/dev/null || echo 'NOT-FOUND' )
    export AWS_SECRET_ACCESS_KEY=$( awk -F= '/SecretKey/ {print $2}' $AWS_CREDENTIAL_FILE 2>/dev/null || echo 'NOT-FOUND' )

    # EC2
    export         EC2_CERT="$(/bin/ls ${profiles_dir}/${profile}/cert-*.pem 2>/dev/null || echo 'NOT-FOUND' )"
    export  EC2_PRIVATE_KEY="$(/bin/ls ${profiles_dir}/${profile}/pk-*.pem   2>/dev/null || echo 'NOT-FOUND' )"

}


# vim:ft=sh:


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
### Enforcing...
###
[ ! -e ~/.aws ] && {
    mkdir ~/.aws && chmod 700 ~/.aws
}


###
### to be used by PS1
###
function __awsenv_ps1() {
    if [ "$AWSENV_PROFILE" != "" ]
    then
        echo "[aws:$AWSENV_PROFILE]"
    fi
}

current_profile=$( readlink ~/.aws )
export AWSENV_PROFILE=${current_profile##*/}


###
### Routines
###

function awsenv-ls() {

    echo
    echo "AWSEnv: Profiles"
    echo "----------------"
    builtin cd "${profiles_dir}" && find * -type d -prune
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
    ln -nsf "${profiles_dir}/${profile}" ~/.aws && \
    export AWSENV_PROFILE="${profile}"

    # From my credential-file, all other vars are evaluated when read
    export   AWS_CREDENTIAL_FILE="$HOME/.aws/aws-credential-file.cfg"
    export     AWS_ACCESS_KEY_ID=$( awk -F= '/AccessKey/ {print $2}' $AWS_CREDENTIAL_FILE 2>/dev/null || echo 'NOT-FOUND' )
    export AWS_SECRET_ACCESS_KEY=$( awk -F= '/SecretKey/ {print $2}' $AWS_CREDENTIAL_FILE 2>/dev/null || echo 'NOT-FOUND' )

    # EC2
    export         EC2_CERT="$(/bin/ls $HOME/.aws/cert-*.pem 2>/dev/null || echo 'NOT-FOUND' )"
    export  EC2_PRIVATE_KEY="$(/bin/ls $HOME/.aws/pk-*.pem   2>/dev/null || echo 'NOT-FOUND' )"

}

function awsenv-generate() {

    profile="$1"

    if [ -z "${profile}" ]
    then
        echo
        echo "Usage: awsenv-generate profile"
        echo
        return
    fi

    if [ ! -d "${profiles_dir}/${profile}" ]
    then
        echo
        echo "Profile: DOES NOT exist: [${profile}]"
        echo
        return
    fi

    if [ ! -d "${templates_dir}" ]
    then
        echo
        echo "Templates dir: DOES NOT exist: [${profile}]"
        echo "See readme."
        echo
        return
    fi

    credentials="${profiles_dir}/${profile}/aws-credential-file.cfg"
    if [ ! -f "${credentials}" ]
    then
        echo
        echo "Credentials file: DOES NOT exist: [${credentials}]"
        echo "You must create it!"
        echo
        echo "File contents:"
        echo "  AWSAccessKeyId=<<your-key-here!!>>"
        echo "  AWSSecretKey=<<your-secret-here!!>>"
        echo
        return
    fi

    aws_access_key=$( awk -F= '/AccessKey/ {print $2}' $credentials )
    aws_secret_key=$( awk -F= '/SecretKey/ {print $2}' $credentials )

    # do it.
    echo
    echo "Using credentials: [$credentials]"
    echo "Using  Access_Key: [$aws_access_key]"
    echo

    builtin cd "${templates_dir}"
    for f in `find . -type f `
    do
        file=${f#./*}
        echo "Generating: $file"

        sed -e "s|__my_access_key__|${aws_access_key}|" \
            -e "s|__my_secret_key__|${aws_secret_key}|" \
        $file > "${profiles_dir}/${profile}/generated-${file}"

        ln -nsf "$HOME/.aws/generated-${file}" $HOME/${file}

    done
    echo

}

# vim:ft=sh:


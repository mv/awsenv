#!/bin/bash
#
# awsenv.sh
#
# Marcus Vinicius Fereira            ferreira.mv[ at ].gmail.com
# 2012-05
#


[ -z "$1" ] && {

    echo
    echo "Usage: awskeys current | list | <aws-profile>"
    echo
    echo "    current:       show current profile"
    echo "    list:          list profiles"
    echo "    <aws-profile>: set profile <aws-profile>"
    echo
#   exit 2
}

export __awsenv_dir=~/.awsenv
export __awsenv_current=default
[ -z "__awsenv_dir"     ] && export __awsenv_dir=~/.awsenv
[ -z "__awsenv_current" ] && export __awsenv_current=default

[ -d ${__awsenv_current} ] || mkdir -p ${__awsenv_current}

__awsenv_current() {
    echo
    echo "Current profile: [ $__awsenv_current ]"
    for v in $( env | sort | egrep 'EC2_CERT|EC2_PRIVATE_KEY|AWS_.*KEY' )
    do
        echo "    $v"
    done
    echo
}

__awsenv_list() {
    echo "AWS profiles:"
    for profile in $( find ${__awsenv_dir}/profiles/* -type d -prune )
    do
        [ "${profile##*/}" == "$__awsenv_current" ] && color='green ' || color='cyan  '
        echo "    - ${color} ${profile##*/}"
    done
    echo
}

__awsenv_set() {

    prf="$1"
    for profile in $( find ${__awsenv_dir}/profiles/* -type d -prune )
    do
        if [ "$prf" == "${profile##*/}" ]
        then
            ### AWS env vars
            export             EC2_CERT=$( echo ${__awsenv_dir}/${prf}/cert*pem )
            export      EC2_PRIVATE_KEY=$( echo ${__awsenv_dir}/${prf}/pk*pem   )
            export  AWS_CREDENTIAL_FILE=$( echo ${__awsenv_dir}/${prf}/aws-credentials-master )

            ### my additional vars
            export     AWS_ACCESS_KEY_ID=$( awk -F": " '/Access Key Id/     {print $2}' $AWS_CREDENTIAL_FILE )
            export AWS_SECRET_ACCESS_KEY=$( awk -F": " '/Secret Access Key/ {print $2}' $AWS_CREDENTIAL_FILE )

            ### current mark
            ln -nsf ${__awsenv_dir}/profiles/${prf} ${__awsenv_dir}/current

            new_profile="$prf"
        fi
    done

    ### result
    if [ ! -z "$new_profile" ]
    then
        echo "Profile [$new_profile] set."
    else
        # Profile not found
        echo "Profile [$1] does not exist."
        echo
        echo "To set a profile: awsenv <aws-profile>"
        echo
    fi
    unset new_profile

}

case $1 in
    cur*)
        __awsenv_current
        ;;
    list)
        __awsenv_list
        ;;
    *)
        __awsenv_set "$1"
        ;;
esac

# vim:ft=sh:foldlevel=9


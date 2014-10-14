###
### Removed from awsenv.sh
###
###    This is depracted now.....
###


function awsenv_generate() {

    profile="$1"

    if [ -z "${profile}" ]
    then
        echo
        echo "Usage: awsenv_generate profile"
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

    if [ ! -d "${template_dir}" ]
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

    builtin cd "${template_dir}"
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


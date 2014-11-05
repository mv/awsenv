AWSenv
======


<WARNING...>


I stopped using templates. My motivation was to playfully circunvent *__s3cmd__*
lack of support to enviroment variables.

Since the new release of AWS CLI command tools *__s3cmd__* is left to the past.


</WARNING...>




### Using templates

Some tools do not read directly from AWS environment variables. Generally they
have some local config file with your credentials inside.

In this scenario, if you switch credentials you would probably have to edit each
file manually to update it. To prevent this a simplistic template approach is
used.

Inside a *__template__* dir, defined by the variable *__awsenv_template_dir__*
you can copy each config file to it and edit for your credentials.

After that, you call *__awsenv_generate__* for each account you want:


    awsenv_generate  account1
    awsenv_generate  account2


#### Examples:

For [Tim Kay's AWS Perl script](http://timkay.com/aws/):

    # .awssecret
    __my_access_key__
    __my_secret_key__



For [CLAWS - command line AWS](https://github.com/wbailey/claws):

    # .claws.yml
    ---
    aws:
    access_key_id: __my_access_key__
    secret_access_key: __my_secret_key__
    ...



For [s3tools: s3cmd](http://s3tools.org/s3cmd)

    # .s3cfg

    [default]
    access_key = __my_access_key__
    secret_key = __my_secret_key__
    ...



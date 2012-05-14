AWSenv
======

AWSenv - AWS API Keys environment variables, à la RVM/RBenv


### Install

Copy _**awsenv.sh**_ to _**/usr/local/bin**_ or anywhere in your PATH.

Add to your _**~/.bashrc**_

    source /usr/local/bin/awsenv.sh


### Setup

Your AWS keys and certificates must reside in a directory, one
set of keys per account, inside _**~/.awsenv/profiles/**_ :

    ~/.awsenv/
      +- profiles/
      |    +- account1/
      |    |    +- aws-credentials-master
      |    |    +- cert-XXXXX.pem
      |    |    +- pk-XXXXXXX.pem
      |    |
      |    +- account2/
      |    |    +- aws-credentials-master
      |    |    +- cert-YYYYY.pem
      |    |    +- pk-YYYYYYY.pem
      ...

Files _**pk-*.pem**_ and _**cert-*.pem**_ are downloaded from you AWS
account.

File _**aws-credentials-master**_ must in the following format,
with your key values copied and pasted from your AWS account:


    Access Key Id: AXxyxyxyxyxyxyxyxy
    Secret Access Key: 7ZYababababababababababababa


### Using

    $ awsenv -h        # usage

    $ awsenv list      # list all profiles

    $ awsenv current   # show current profile/account

    $ awsenv account1  # set profile to use 'account1'


Marcus Vinicius Fereira      -      ferreira.mv[ at ].gmail.com  
2012-05


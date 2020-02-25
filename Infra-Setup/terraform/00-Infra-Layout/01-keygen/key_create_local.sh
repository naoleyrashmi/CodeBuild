#!/bin/bash
set -e
#!/bin/bash
export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
export AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN}
export AWS_DEFAULT_REGION=${REGION}
export MODULE=00-Infra-Layout/01-keygen
export KEY_DIR=$(pwd)/.ssh
export KEY_NAME=${ACCOUNT_NAME}
export SOURCE=${KEY_DIR}/${KEY_NAME}.pem
export PUBLIC_KEY_PATH=${KEY_DIR}/${KEY_NAME}.pub
export PRIVATE_KEY_PATH=${KEY_DIR}/${KEY_NAME}.pem
export MIGRATION_KEY=env/${REGION}/${ACCOUNT_NAME}/${KEY_NAME}.pem

if aws ec2 describe-key-pairs --key-name ${KEY_NAME} ; then
    echo "Key exists"
else
    rm -rf ${KEY_DIR}
    mkdir -p ${KEY_DIR}
    key_file_path=${KEY_DIR}/${KEY_NAME}
    echo ${key_file_path}
    private_key=${key_file_path}.pem
    public_key=${key_file_path}.pub

    echo "################### ${private_key} ####################"
    ssh-keygen -f ${private_key} -t rsa -N ''
    chmod 400 ${private_key}

    echo "################### ${public_key} ####################"
    ssh-keygen -y -f ${private_key} > ${public_key}
    chmod 400 ${public_key}

    export MODULE=utility/misc/s3upload
    cd ../../${MODULE}/ci && ./run.sh
    export MODULE=00-Infra-Layout/01-keygen
    
    cd ../../../../${MODULE}/ci && ./run.sh
    rm -rf ${KEY_DIR}
fi

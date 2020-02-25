#!/bin/bash
set -e

ws_dir=$(pwd)
aws_key_name=${1}
aws_key_dir=${ws_dir}/.ssh
mkdir -p ${aws_key_dir}
key_file_path=${aws_key_dir}/${aws_key_name}
echo ${key_file_path}
key_json=${key_file_path}.json
private_key=${key_file_path}.pem
public_key=${key_file_path}.pub

# Create the ssh key on AWS
aws ec2 create-key-pair --key-name ${aws_key_name} > ${key_json}
echo "################### ${key_json} ######################"
cat ${key_json}

# Read the private key from json
echo "################### ${private_key} ###################"
cat ${key_json} | jq -r '.KeyMaterial' > ${private_key}
chmod 400 ${private_key}
cat ${private_key}

# Get Public key from private key
echo "################### ${public_key} ####################"
ssh-keygen -y -f ${private_key} > ${public_key}
chmod 400 ${public_key}
cat ${public_key}
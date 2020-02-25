#!/bin/bash

set -e

DIR=$1
cd ${DIR}
echo ${DIR}

export AWS_ACCESS_KEY_ID=${TF_VAR_aws_access_key}
export AWS_SECRET_ACCESS_KEY=${TF_VAR_aws_secret_key}
export AWS_SESSION_TOKEN=${TF_VAR_token}
export AWS_DEFAULT_REGION=${TF_VAR_aws_region}

export INF_DIR=${HOME}/ec
rm -rf .terraform terraform.tfstate terraform.tfstate.backup

terraform init \
	-backend-config="bucket=tieto-${ACCOUNT_NAME}-tfstate" \
	-backend-config="key=env/${REGION}/${ACCOUNT_NAME}/${MODULE}/terraform.tfstate" \
	-backend-config="region=${REGION}"

terraform get
terraform show

if [ "$APPLY_CHANGES" == "true" ] 
then
	terraform destroy -force
else
	terraform plan -destroy
fi

terraform show
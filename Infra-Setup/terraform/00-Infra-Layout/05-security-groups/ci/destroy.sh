#!/bin/bash

export VPC_MODULE=00-Infra-Layout/02-vpc
export TF_VAR_env_name=${ACCOUNT_NAME}
export TF_VAR_aws_region=${REGION}
export TF_VAR_aws_access_key=${AWS_ACCESS_KEY_ID}
export TF_VAR_aws_secret_key=${AWS_SECRET_ACCESS_KEY}
export TF_VAR_token=${AWS_SESSION_TOKEN}
export TF_VAR_az_zone_1a=
export TF_VAR_az_zone_1b=
export TF_VAR_vpc_cidr="0.0.0.0/0"
export TF_VAR_private_subnet_cidr_az_a="0.0.0.0/0"
export TF_VAR_private_subnet_cidr_az_b="0.0.0.0/0"
export TF_VAR_public_subnet_cidr_az_a="0.0.0.0/0"
export TF_VAR_public_subnet_cidr_az_b="0.0.0.0/0"
export TF_VAR_hosted_zone=
export TF_VAR_vpc_backend_bucket=tieto-${ACCOUNT_NAME}-tfstate
export TF_VAR_vpc_backend_key=env/${REGION}/${ACCOUNT_NAME}/${VPC_MODULE}/terraform.tfstate
export TF_VAR_vpc_backend_region=${REGION}

export TF_VAR_project_id=
export TF_VAR_assets_expity_date=
export TF_VAR_build_user=
export TF_VAR_build_user_email=

../../../utility/ci/destroy.sh $(dirname $(pwd))

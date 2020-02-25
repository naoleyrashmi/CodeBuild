#!/bin/bash

export VPC_MODULE=00-Infra-Layout/02-vpc
export TF_VAR_env_name=${ACCOUNT_NAME}
export TF_VAR_aws_region=${REGION}
export TF_VAR_aws_access_key=${AWS_ACCESS_KEY_ID}
export TF_VAR_aws_secret_key=${AWS_SECRET_ACCESS_KEY}
export TF_VAR_token=${AWS_SESSION_TOKEN}
export TF_VAR_az_zone_1a=${REGION}a
export TF_VAR_az_zone_1b=${REGION}b
export TF_VAR_vpc_cidr=${VPC_CIDR}
export TF_VAR_private_subnet_cidr_az_a=${PRIVATE_SUBNET_CIDR_AZ_A}
export TF_VAR_private_subnet_cidr_az_b=${PRIVATE_SUBNET_CIDR_AZ_B}
export TF_VAR_public_subnet_cidr_az_a=${PUBLIC_SUBNET_CIDR_AZ_A}
export TF_VAR_public_subnet_cidr_az_b=${PUBLIC_SUBNET_CIDR_AZ_B}
export TF_VAR_hosted_zone=${HOSTED_ZONE}
export TF_VAR_vpc_backend_bucket=tieto-${ACCOUNT_NAME}-tfstate
export TF_VAR_vpc_backend_key=env/${REGION}/${ACCOUNT_NAME}/${VPC_MODULE}/terraform.tfstate
export TF_VAR_vpc_backend_region=${REGION}

export TF_VAR_project_id=${PROJECT_ID}
export TF_VAR_assets_expity_date=${ASSETS_EXPIRY_DATE}
export TF_VAR_build_user=${BUILD_USER}
export TF_VAR_build_user_email=${BUILD_USER_EMAIL}

../../../utility/ci/run.sh $(dirname $(pwd))
